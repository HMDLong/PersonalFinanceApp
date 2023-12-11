import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import "package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart";
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/models/transaction.model.dart';
import 'package:saving_app/providers/local/category_repository.dart';
import 'package:saving_app/providers/local/model_providers/budget_repo.dart';
import 'package:saving_app/providers/local/model_providers/credit_repo.dart';
import 'package:saving_app/providers/local/model_providers/debit_repo.dart';
import 'package:saving_app/providers/local/model_providers/savings_repo.dart';
import 'package:saving_app/screens/accounts/accounts.screen.dart';
import 'package:saving_app/screens/records/records.screen.dart';
import 'package:saving_app/screens/stats/stats.screen.dart';
import 'screens/more/more.screen.dart';
import 'screens/plan/plan.screen.dart';

Future<void> main() async {
  await initFlutter();
  runApp(const MyApp());
}

Future<void> initFlutter() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>(transactionBoxName);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() => 
  [
    const RecordScreen(),
    const StatisticsScreen(),
    const AccountsScreen(),
    const PlanScreen(),
    const MoreScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() =>
  [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: "Record",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.chart_bar_square),
      title: "Stats",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.money_dollar),
      title: "Accounts",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.graph_circle),
      title: "Plan",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.bars),
      title: "More",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];

  @override
  void dispose() async {
    await Hive.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryRepository()),
        ChangeNotifierProvider(create: (context) => BudgetRepository()),
        ChangeNotifierProvider(create: (context) => SavingRepository()),
        ChangeNotifierProvider(create: (context) => DebitRepository()),
        ChangeNotifierProvider(create: (context) => CreditRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PersistentTabView(
          context,
          controller: _tabController,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style7,
        ),
      ),
    );
  }
}
