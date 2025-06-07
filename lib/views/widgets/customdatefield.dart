import 'package:flutter/material.dart';

Widget buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextField(
            readOnly: true,
            controller: controller,
            style: TextStyle(fontSize: 12),
            onTap: onTap,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today, size: 16),
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