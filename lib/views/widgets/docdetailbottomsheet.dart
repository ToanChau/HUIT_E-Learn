// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Docdetailbottomsheet extends StatelessWidget {
  const Docdetailbottomsheet({
    super.key,
    required this.type,
    required this.size,
    required this.date,
  });

  final String type;
  final String size;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _builDetailItem("Loại", type),
          _builDetailItem("Kích cỡ", size),
          _builDetailItem("Ngày đăng tải", date),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _builDetailItem(String label, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(label, maxLines: 1)),
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
