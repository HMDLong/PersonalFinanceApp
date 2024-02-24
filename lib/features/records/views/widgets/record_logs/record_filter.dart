import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordFilterDialog extends ConsumerStatefulWidget {
  const RecordFilterDialog({super.key});

  @override
  ConsumerState<RecordFilterDialog> createState() => _RecordFilterDialogState();
}

class _RecordFilterDialogState extends ConsumerState<RecordFilterDialog> {
  _setFilter() {
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bộ lọc"),
      content: const SizedBox(
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Loại"),
                ),
                Expanded(
                  child: DropdownMenu(
                    dropdownMenuEntries: []
                  )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Sắp xếp theo"),
                ),
                Expanded(
                  child: DropdownMenu(
                    dropdownMenuEntries: []
                  )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Hướng sắp xếp"),
                ),
                Expanded(
                  child: DropdownMenu(
                    dropdownMenuEntries: []
                  )
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _setFilter, 
          child: const Text("Xác nhận"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("Hủy"),
        ),
      ],
    );
  }
}