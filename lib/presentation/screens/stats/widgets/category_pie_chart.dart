import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/models/transaction.model.dart';

import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryPieChart extends StatefulWidget {
  final Box<Transaction> transactionBox;
  const CategoryPieChart({super.key, required this.transactionBox, });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  bool displayParentCategory = true;
  String parentId = "";

  List<ChartData> _getChartDataByCategory() {
    final controller = context.read<PlanController>();
    return widget.transactionBox.values
    .where((transact) {
      if(parentId.isEmpty) return true;
      return parentId == controller.getGroupCategoryBySubId(transact.categoryId)?.id;
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
          )
        );
        return previousValue;
      }
    );
  }

  List<ChartData> _getChartDataByGroup() {
    final controller = context.read<PlanController>();
    return widget.transactionBox.values
    .fold(
      builtInCategories.asMap().map((index, e) => MapEntry(e.name, 0)), 
      (prev, transact) {
        final parent = controller.getGroupCategoryBySubId(transact.categoryId);
        prev[parent!.name] = prev[parent.name]! + transact.amount;
        return prev;
      }
    ).entries.fold(
      <ChartData>[], 
      (previousValue, e) {
        previousValue.add(ChartData(e.key!, e.value));
        return previousValue;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ValueListenableBuilder(
            valueListenable: widget.transactionBox.listenable(),
            builder: (context, box, _) {
              final displayData = displayParentCategory
                                  ? _getChartDataByGroup()
                                  : _getChartDataByCategory();
              return SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    onPointTap: (pointInteractionDetails) {
                      if(displayParentCategory){
                        setState(() {
                          displayParentCategory = !displayParentCategory;
                          parentId = displayData[pointInteractionDetails.seriesIndex!].x;
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
                      isVisible: true,
                    ),
                    dataLabelMapper: (datum, index) => datum.x,
                  )
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final num y;
}
