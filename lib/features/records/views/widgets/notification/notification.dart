import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class NoticationBox extends StatelessWidget {
  const NoticationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Bạn không có thông báo. Chúc 1 ngày tốt lành"
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Icon(Boxicons.bx_error, color: Colors.red),
            ),
            Expanded(
              child: Text("Bạn có 2 khoản lên lịch sắp tới: Tiền nhà, tiền học"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Icon(Boxicons.bx_error, color: Colors.amber,),
            ),
            Expanded(
              child: Icon(Boxicons.bx_error, color: Colors.amber,),
            ),
          ],
        ),
      ],
    );
  }
}