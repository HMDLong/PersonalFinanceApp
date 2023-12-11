import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'new_account.screen.dart';
import 'widgets/carousel_list/credit_carousel.dart';
import 'widgets/carousel_list/debits_carousel.dart';
import 'widgets/carousel_list/savings_carousel.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountsScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accounts", 
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DebitsCarousel(),
            SizedBox(height: 20.0,),
            CreditCarousel(),
            SizedBox(height: 20.0,),
            SavingsCarousel(),
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

