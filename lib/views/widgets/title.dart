import 'package:flutter/material.dart';

class TitleCustom extends StatelessWidget {
  final String tieude;
  final Color color;
  const TitleCustom({Key? key, required this.tieude, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      tieude,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color),
    );
  }
}
