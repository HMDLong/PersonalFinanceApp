import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/features/accounts/models/account.dart';
import 'package:saving_app/features/accounts/models/debit.dart';
import 'package:saving_app/features/accounts/viewmodels/accounts.viewmodel.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/debit/debit_detail.screen.dart';

class DebitsCarousel extends ConsumerStatefulWidget {
  const DebitsCarousel({super.key});

  @override
  ConsumerState<DebitsCarousel> createState() => _DebitsCarouselState();
}

class _DebitsCarouselState extends ConsumerState<DebitsCarousel> {
  int _getTotalBalance(List<Debit> debits) {
    return debits
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!)!;
  }

  @override
  Widget build(BuildContext context) {
    // var debits = context.watch<DebitRepository>();
    // var allDebits = debits.getAll();
    final allDebitsFuture = ref.watch(accountsProvider).getAccountByType(AccountType.debit);
    return FutureBuilder(
      future: allDebitsFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting ){
          return const CircularProgressIndicator();
        }
        print(snapshot.data);
        final allDebits = (snapshot.data ?? []).cast<Debit>();
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: Text(
              "Tài khoản tiêu dùng (${allDebits.length})",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: allDebits.isEmpty
                      ? null
                      : Row(
                        children: [
                          Text(
                            NumberFormat.decimalPattern().format(_getTotalBalance(allDebits)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent.shade700,
                            ),
                          ),
                          const Text(
                            "VND", 
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ],
                      ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            childrenPadding: const EdgeInsets.all(5.0),
            initiallyExpanded: true,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => _DebitListTile(debit: allDebits[index]), 
                separatorBuilder: ((context, index) => const Divider()), 
                itemCount: allDebits.length,
              )
            ],
          ),
        );
      }
    );
  }
}

class _DebitListTile extends StatelessWidget {
  final Debit debit;
  const _DebitListTile({Key? key, required this.debit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        "${debit.title}",
        // style: const TextStyle(
        //   color: Colors.black54,
        //   fontSize: 12,
        // ),
      ),
      trailing: IconButton(
        onPressed: () => _accountDetail(context, debit), 
        icon: const Icon(Icons.chevron_right_sharp),
      ),
      subtitle: Row(
        children: [
          Text(
            NumberFormat.decimalPattern().format(debit.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigoAccent.shade700,
            ),
          ),
          const Text("VND",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
  
  void _accountDetail(BuildContext context, Debit debit) {
    pushNewScreen(
      context, 
      screen: DebitDetailScreen(account: debit)
    );
  }
}
