import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  final List<Tab> _tabs = [
    const Tab(child: Text("All"),),
    const Tab(child: Text("Custom"),),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      initialIndex: 0,
      vsync: this,
    );
    _tabController?.addListener(() => _handleTabSelection());
  }

  void _handleTabSelection() {
    if(_tabController!.indexIsChanging){
      _filterCategory(_tabController!.index);
    }
  }

    
  void _filterCategory(int tabIndex) {

  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ), 
            onPressed: () { 
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Your Categories", 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.blue,
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: _tabs,
          ),
        ),
        body: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5.0),
            );
          }
        ),
      ),
    );
  }
}