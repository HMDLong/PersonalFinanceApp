// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/account/credit_repo.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/credit/credit_detail.dart';

class CreditCarousel extends StatefulWidget {
  const CreditCarousel({super.key});

  @override
  State<CreditCarousel> createState() => _CreditCarouselState();
}

class _CreditCarouselState extends State<CreditCarousel> {
  int _getTotalBalance(List<Credit> debits) {
    return debits
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!)!;
  }

  @override
  Widget build(BuildContext context) {
    var creditRepo = context.watch<CreditRepository>();
    var credits = creditRepo.getAll();
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          "Tài khoản tín dụng (${credits.length})",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: credits.isEmpty
                  ? null
                  : Row(
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(_getTotalBalance(credits)),
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
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => _CreditListTile(credit: credits[index]), 
            separatorBuilder: ((context, index) => const Divider()), 
            itemCount: credits.length,
          )
        ],
      ),
    );
  }
}

class _CreditListTile extends StatelessWidget{
  final Credit credit;
  const _CreditListTile({Key? key, required this.credit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context, 
          screen: CreditDetail(credit: credit),
        );
      },
      child: ListTile(
        title: Text(
          "${credit.title}"
        ),
        subtitle: Text(
          "${NumberFormat.decimalPattern().format(credit.amount)} VND/${credit.payment}",
          style: const TextStyle(
    
          ),
        ),
        trailing: const Icon(Icons.chevron_right_sharp),
      ),
    );
  }
}