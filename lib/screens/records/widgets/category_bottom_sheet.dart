import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/providers/local/category_repository.dart';

import '../../../constants/built_in_categories.dart';

class CategoryBottomSheet extends StatefulWidget {
  final bool type;
  const CategoryBottomSheet({super.key, required this.type});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late List<bool> state;
  
  @override
  void initState() {
    state = List.generate(builtInCategories.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categoryRepo = context.watch<CategoryRepository>();
    var categories = categoryRepo.getByType(widget.type);
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), 
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), 
                topRight: Radius.circular(10.0),
              ),
              color: Colors.blue,
            ),
            child: const Text(
              "Choose a category",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              prefixIcon: Icon(CupertinoIcons.search),
            ),
            onChanged: (value) {

            },
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int panelIndex, bool isExpanded) {
                  setState(() {
                    state[panelIndex] = isExpanded;
                  });
                },
                children: List.generate(
                  categories.length, 
                  (index) {
                    final currentCate = categories[index];
                    return ExpansionPanel(
                      isExpanded: state[index],
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(currentCate.name),
                        );
                      }, 
                      body: Column(
                        children: currentCate.subCategories.map((subCategory) => ListTile(
                          leading: Icon(IconData(
                            subCategory.icon, 
                            fontFamily: subCategory.iconFont
                          )),
                          title: Text(subCategory.name),
                          onTap: () {
                            Navigator.of(context).pop(subCategory);
                          },
                        )).toList(),
                      )
                    );
                  }
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}