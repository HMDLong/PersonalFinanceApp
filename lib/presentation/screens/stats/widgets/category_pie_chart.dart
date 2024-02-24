import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryPieChart extends ConsumerStatefulWidget {
  final Box<Transaction> transactionBox;
  final TimeRange timeRange;
  const CategoryPieChart({super.key, required this.transactionBox, required this.timeRange});

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  bool displayParentCategory = true;
  ChartData? selectedData;
  TransactionType type = TransactionType.expense;

  List<ChartData> _getChartDataByCategory() {
    final controller = context.read<PlanController>();
    return widget.transactionBox.values
    .where((transact) {
      if(selectedData == null) return true;
      return selectedData!.categoryId == controller.getGroupCategoryBySubId(transact.categoryId)?.id;
    })
    .fold(
      <String, num>{}, 
      (previousValue, element) {
        if(!previousValue.containsKey(element.categoryId)){
          previousValue[element.categoryId] = element.amount;
        } else {
          previousValue[element.categoryId] = previousValue[element.categoryId]! + element.amount;
        }
        return previousValue;
      }
    ).entries.fold(
      <ChartData>[], 
      (previousValue, e) {
        previousValue.add(
          ChartData(
            controller.getCategoryById(e.key)!.name!, 
            e.value,
            e.key,
          )
        );
        return previousValue;
      }
    );
  }

  List<ChartData> _getChartDataByGroup() {
    final controller = context.read<PlanController>();
    return widget.transactionBox.values
    .where((e) => widget.timeRange.contain(e.timestamp))
    .fold(
      <String, int>{}, 
      (prev, transact) {
        final parent = controller.getGroupCategoryBySubId(transact.categoryId);
        if(prev.containsKey(parent!.id)){
          prev[parent.id!] = prev[parent.id]! + transact.amount;
        } else {
          prev[parent.id!] = transact.amount;
        }
        return prev;
      }
    ).entries.fold(
      <ChartData>[], 
      (previousValue, e) {
        final category = controller.getCategoryById(e.key);
        previousValue.add(ChartData(category!.name!, e.value, e.key));
        return previousValue;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<PlanController>();
    final int spentAmount;
    final int totalAmount;
    if(type == TransactionType.expense) {
      totalAmount = ref.watch(totalActualExpenseProvider(widget.timeRange));
    } else {
      totalAmount = ref.watch(totalActualIncomeProvider(widget.timeRange));
    }
    if(selectedData != null) {
      if(displayParentCategory) {
        spentAmount = ref.watch(totalAmountByGroupProvider([selectedData!.categoryId, widget.timeRange, type]));
      } else {
        spentAmount = ref.watch(totalAmountByCategoryProvider([selectedData!.categoryId, widget.timeRange, type]));
      }
    } else {
      spentAmount = 0;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thành phần thu chi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Thu chi của tôi cho những gì?",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.3),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          type = TransactionType.expense;
                        });
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: type == TransactionType.expense ? CupertinoColors.activeBlue : Colors.white
                        ),
                        child: Center(
                          child: Text(
                            "Chi phí",
                            style: TextStyle(color: type == TransactionType.expense ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          type = TransactionType.income;
                        });
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: type == TransactionType.income ? CupertinoColors.activeBlue : Colors.white
                        ),
                        child: Center(
                          child: Text(
                            "Thu nhập",
                            style: TextStyle(color: type == TransactionType.income ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selectedData?.x ?? "", style: const TextStyle(fontWeight: FontWeight.bold),),
                      Text(
                        "${NumberFormat.decimalPattern().format(spentAmount)} VND (${(spentAmount/totalAmount * 100).toStringAsFixed(2)} %)", 
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: widget.transactionBox.listenable(),
              builder: (context, box, _) {
                var displayData = displayParentCategory
                                    ? _getChartDataByGroup()
                                    : _getChartDataByCategory();
                return SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: SfCircularChart(
                    backgroundColor: displayData.isEmpty ? Colors.grey : null,
                    legend: const Legend(
                      isVisible: true,
                      isResponsive: true,
                      textStyle: TextStyle(fontSize: 10),
                      position: LegendPosition.bottom,
                      itemPadding: 10,
                      shouldAlwaysShowScrollbar: true,
                      overflowMode: LegendItemOverflowMode.wrap
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        onPointTap: (pointInteractionDetails) {
                          if(displayParentCategory){
                            setState(() {
                              // displayParentCategory = !displayParentCategory;
                              selectedData = displayData[pointInteractionDetails.pointIndex!];
                            });
                          } else {
                            setState(() {
                              // parentId = "";
                              // displayParentCategory = !displayParentCategory;
                            });
                          }
                        },
                        dataSource: displayData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        explode: true,
                        // explodeIndex: 1,
                        dataLabelSettings: const DataLabelSettings(
                          showZeroValue: false,
                          showCumulativeValues: true,
                          isVisible: false,
                        ),
                        legendIconType: LegendIconType.circle,
                        dataLabelMapper: (datum, index) => datum.x,
                      )
                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.categoryId);
  final String x;
  final num y;
  final String categoryId;
}
