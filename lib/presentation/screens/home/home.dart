import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/records/records.screen.dart';
import 'package:saving_app/presentation/screens/records/widgets/record_logs/transaction_card.dart';
import 'package:saving_app/utils/format.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  List<Transaction> _transactsToDisplay(List<Transaction> transactions) {
    if(transactions.length < 10) {
      return transactions;
    }
    return transactions.sublist(transactions.length - 10);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsViewModelProvider).getTransactions();
    final last10Transactions = _transactsToDisplay(transactions);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40,),
                    const Text(
                      "Tổng số dư",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      amountToDecimal(10000000),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        const SizedBox(width: 4,),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3366FF),
                                    Color(0xFF00CCFF),
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text("Thu nhập"),
                                    Text(amountToDecimal(10000)),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ),
                        const SizedBox(width: 4,),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3366FF),
                                    Color(0xFF00CCFF),
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Chi phí",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      amountToDecimal(10000),
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ),
                        const SizedBox(width: 4,),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 6, 10, 6),
                      child: Row(
                        children: [
                          const Expanded(flex: 1, child: Text("Giao dịch gần đây")),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text("Chi tiết"),
                                onPressed: () {
                                  pushNewScreen(context, screen: const RecordScreen());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: last10Transactions.length + 1,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if(index == last10Transactions.length) {
                            return const SizedBox(height: 60,);
                          }
                          return TransactionCard(transaction: last10Transactions[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}