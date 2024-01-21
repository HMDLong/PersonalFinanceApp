import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/category_bottom_sheet.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class CategoryPicker extends StatefulWidget {
  final TransactionType transactionType;
  final void Function(CustomCategory category) onCategoryChanged;
  final String? Function(String? value)? validator;
  final String? label;
  final bool allowGroup;
  final bool requiredPicked;
  const CategoryPicker({
    super.key, 
    required this.transactionType, 
    required this.onCategoryChanged, 
    this.validator, 
    this.label,
    this.allowGroup = false,
    this.requiredPicked = true,
  });

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  final _categoryController = TextEditingController();

  void _selectCategory() async {
    CustomCategory? pickedCategory = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0), 
        topRight: Radius.circular(10.0),
      )),
      builder: (context) {
        return CategoryBottomSheet(
          type: widget.transactionType,
          allowGroup: widget.allowGroup,
        );
      }
    );

    if(pickedCategory != null) {
      setState(() {
        widget.onCategoryChanged(pickedCategory);
        _categoryController.text = "${pickedCategory.name}";
      });
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabelWithPadding(widget.label ?? "Loại"),
        TextFormField(
          controller: _categoryController,
          readOnly: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.circle_grid_hex)),
          onTap: _selectCategory,
          validator: widget.validator,
        ),
      ],
    );
  }
}