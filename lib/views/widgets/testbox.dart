import 'package:flutter/material.dart';
import 'package:huit_elearn/models/tests.dart';

Widget TestBox(
  BuildContext context,
  Test test,
  int index,
  Function()? ontap,
) {
  return GestureDetector(
    onTap: () {
      if (ontap != null) {
        ontap();
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              test.tenDe,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              "Đề số $index",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              "Trạng thái: ",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
  );
}
