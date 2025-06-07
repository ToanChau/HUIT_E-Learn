 import 'package:flutter/material.dart';

Widget buildTextField({
    required String lable,
    required TextEditingController controller,
  }) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            lable,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextField(
            cursorColor: Colors.black,
            cursorHeight: 20,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }