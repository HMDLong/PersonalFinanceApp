import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/models/category.model.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> with SingleTickerProviderStateMixin{
  // TabController? _tabController;

  // final List<Tab> _tabs = [
  //   const Tab(child: Text("All"),),
  //   const Tab(child: Text("Custom"),),
  // ];

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(
    //   length: _tabs.length,
    //   initialIndex: 0,
    //   vsync: this,
    // );
    // _tabController?.addListener(() => _handleTabSelection());
  }

  // void _handleTabSelection() {
  //   if(_tabController!.indexIsChanging){
  //     _filterCategory(_tabController!.index);
  //   }
  // }

  void _filterCategory(int tabIndex) {

  }

  @override
  void dispose() {
    // _tabController?.dispose();
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
            "Mục phân loại của bạn", 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context, index) {
            final group = builtInCategories[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: Colors.blue.shade400,
                      ),
                      child: Row(
                        children: [
                          Icon(group.icon),
                          Text("${group.name}"),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _newCategory(group),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        final sub = group.subCategories[i];
                        return ListTile(
                          title: Text("${sub.name}"),
                          dense: true,
                        );
                      }, 
                      separatorBuilder: (context, i) => const Divider(), 
                      itemCount: group.subCategories.length,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: builtInCategories.length,
        ),
      ),
    );
  }

  void _newCategory(CategoryGroup parent) async {
    TransactCategory? newTransactCategory = await showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Xác nhận"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Hủy"),
            ),
          ],
        );
      }
    );
  }
}

class NewCategoryForm extends StatefulWidget {
  final CategoryGroup parent;
  const NewCategoryForm({super.key, required this.parent});

  @override
  State<NewCategoryForm> createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<NewCategoryForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}