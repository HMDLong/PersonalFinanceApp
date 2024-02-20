import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart' as provider;
import "package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart";
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/local/model_repos/records/transact_repo.dart';
import 'package:saving_app/data/local/repository_impl/category_repo_impl.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/local/model_repos/budget/budget_json_repo.dart';
import 'package:saving_app/data/local/model_repos/account/credit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/debit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/savings_repo.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/domain/providers/category_provider.dart';
import 'package:saving_app/presentation/screens/home/home.dart';
import 'package:saving_app/services/notification_service.dart';
import 'package:saving_app/presentation/managers/category_manager.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/accounts/accounts.screen.dart';
import 'package:saving_app/presentation/screens/stats/stats.screen.dart';
import 'presentation/screens/more/more.screen.dart';
import 'presentation/screens/plan/plan.screen.dart';

Future<void> main() async {
  await initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initFlutter() async {
  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  await Hive.openBox<Transaction>(transactionBoxName);
  // Init AwesomeNotification
  NotificationService.initialize();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() => 
  [
    // const RecordScreen(),
    const HomeScreen(),
    const StatisticsScreen(),
    const AccountsScreen(),
    const PlanScreen(),
    const MoreScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() =>
  [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: "Ghi chép",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.chart_bar_square),
      title: "Thống kê",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Boxicons.bx_wallet),
      title: "Tài khoản",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.graph_circle),
      title: "Kế hoạch",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.bars),
      title: "Thêm nữa",
      activeColorPrimary: CupertinoColors.activeBlue,
      activeColorSecondary: CupertinoColors.white,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];

  @override
  void initState() {
    NotificationService.initListeners();
    super.initState();
  }

  @override
  void dispose() async {
    await Hive.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (context) => TransactionRepository()),
        provider.ChangeNotifierProvider(create: (context) => CategoryRepository()),
        provider.ChangeNotifierProvider(create: (context) => BudgetJsonRepository(repoName: budgetJsonRepoName)),
        provider.ChangeNotifierProvider(create: (context) => PlanTransactJsonRepository(repoName: planTransactRepoName)),
        provider.ChangeNotifierProvider(create: (context) => CategoryController(
          repository: context.read<CategoryRepository>(),
          budgetJsonRepository: context.read<BudgetJsonRepository>()
        )),
        provider.ChangeNotifierProvider(create: (context) => SavingRepository()),
        provider.ChangeNotifierProvider(create: (context) => DebitRepository()),
        provider.ChangeNotifierProvider(create: (context) => CreditRepository()),
        provider.ChangeNotifierProvider(create: (context) => TransactionProvider(
          transactRepo: context.read<TransactionRepository>(), 
          planTransactRepo: context.read<PlanTransactJsonRepository>()
        )),
        provider.ChangeNotifierProvider(create: (_) => CategoryProvider(CategoryRepositoryLocalImpl())),
        provider.Provider(create: (context) => PlanSettings()),
        provider.ChangeNotifierProxyProvider3<
          PlanTransactJsonRepository,
          TransactionRepository,
          BudgetJsonRepository, 
          PlanController
        >(
          lazy: true,
          create: (context) => PlanController(
            planTransactRepo: context.read<PlanTransactJsonRepository>(), 
            budgetRepo: context.read<BudgetJsonRepository>(),
            categoryRepo: context.read<CategoryRepository>(),
            planSettings: context.read<PlanSettings>(),
            transactRepo: context.read<TransactionRepository>(),
          ), 
          update: (_, myPlanTransactRepo ,myTransactRepo, myBudgetRepo, myNotifier) {
            myNotifier?.notifyPlanController();
            return myNotifier!;
          }
        ),
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
