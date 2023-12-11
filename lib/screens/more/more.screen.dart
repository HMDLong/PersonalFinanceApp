import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/screens/more/manage_category.screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<MoreScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "More", 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          ElevatedButton.icon(
            icon: Icon(
              CupertinoIcons.circle_grid_hex, 
              color: Colors.blue.shade900,
            ),
            label: const Text("Manage Categories"),
            onPressed: () {
              pushNewScreen(context, screen: const ManageCategoryScreen());
            },
          ),
          ElevatedButton.icon(
            icon: Icon(
              CupertinoIcons.arrow_2_circlepath, 
              color: Colors.blue.shade900,
            ),
            label: const Text("Restore & Backup"),
            onPressed: () async {
              // List<Map<String, dynamic>> data = [];
              // for (var cate in builtInCategories) {
              //   data.add(cate.toJson());
              // }
              // Directory dir = await getApplicationDocumentsDirectory();
              // File file = File('${dir.path}/categories.json');
              // if(!file.existsSync()){
              //   file.createSync();
              // }
              // file.writeAsString(jsonEncode({"data": data}));
            },
          ),
        ],
      ),
    );
  }
}

