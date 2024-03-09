import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/viewmodels/account/account_viewmodel.dart';
import 'package:saving_app/viewmodels/account/cash_viewmodel.dart';

import 'new_account.screen.dart';
import 'widgets/carousel_list/credit_carousel.dart';
import 'widgets/carousel_list/debits_carousel.dart';
import 'widgets/carousel_list/savings_carousel.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountsScreen>{
  int cashInput = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tài khoản", 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _onNewAccount(), 
            icon: const Icon(Icons.add_card, color: Colors.black,),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tổng số dư của bạn"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final totalBalance = ref.watch(totalBalanceProvider);
                    return Text(
                      NumberFormat.decimalPattern().format(totalBalance),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent.shade700
                      ),
                    );
                  }
                ),
                const Text("VND"),
              ],
            ),
            const SizedBox(height: 10,),
            Consumer(
              builder: (context, ref, _) {
                final cash = ref.watch(currentCashAmountProvider).when(
                  data: (data) => data, 
                  error: (error, _) => 0, 
                  loading: () => 0
                );
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tiền mặt", style: TextStyle(fontSize: 16),),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text(
                                    NumberFormat.decimalPattern().format(cash),
                                    style: TextStyle(
                                      color: Colors.indigoAccent.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  const Text("VND"),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                    context: context, 
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: 70,
                                          width: 100,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            decoration: formFieldDecor(
                                              icon: const Icon(Boxicons.bx_money),
                                              suffix: const Text("VND", style: TextStyle(color: Colors.black54)),
                                              label: const Text("Số tiền thêm"),
                                            ),
                                            validator: (value) {
                                              if(value == null || value.isEmpty) {
                                                return "Hãy nhập";
                                              }
                                              final parsed = int.tryParse(value);
                                              if(parsed == null) {
                                                return "Cần là 1 số nguyên";
                                              }
                                              if(parsed <= 0) {
                                                return "Cần dương";
                                              }
                                              cashInput = parsed;
                                              return null;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if(cashInput > 0) {
                                                ref.watch(cashViewModelProvider).addCash(cashInput).then(
                                                  (value) => Navigator.of(context).pop()
                                                );
                                              }
                                            }, 
                                            child: const Text("Thêm")
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(), 
                                            child: const Text("Hủy")
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                },
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: 20.0,),
            const DebitsCarousel(),
            const SizedBox(height: 20.0,),
            const CreditCarousel(),
            const SizedBox(height: 20.0,),
            const SavingsCarousel(),
          ],
        ),
      ),
    );
  }
  
  _onNewAccount() {
    pushNewScreen(
      context, 
      screen: const NewAccountScreen(),
    );
  }
}

