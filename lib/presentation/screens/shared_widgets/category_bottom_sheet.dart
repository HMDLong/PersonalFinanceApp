import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';

import '../../../constants/built_in_categories.dart';

class CategoryBottomSheet extends StatefulWidget {
  final TransactionType type;
  final bool allowGroup;
  const CategoryBottomSheet({
    super.key, 
    required this.type,
    this.allowGroup = false,
  });

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
              "Chọn 1 phân loại",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final group = categories[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Text(
                        group.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Wrap(
                        spacing: 5,
                        children: (widget.allowGroup
                        ? [
                            InputChip(
                              label: Text(group.name!),
                              onPressed: () {
                                Navigator.of(context).pop(group);
                              },
                            )
                          ]
                        : <Widget>[])
                        + group.subCategories.map(
                          (e) => InputChip(
                            label: Text(e.name!),
                            onPressed: () {
                              Navigator.of(context).pop(e);
                            },
                          )
                        ).toList(),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  );
                }
              ),
            )
          )
        ],
      ),
    );
  }
}
