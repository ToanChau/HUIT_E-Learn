import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfviewScreen extends StatelessWidget {
  final File filePath;
  const PdfviewScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: SafeArea(
        child: SfPdfViewer.file(filePath),
      ),
      bottomSheet: BottomSheet(
        enableDrag: true,
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                      },
                    ),
                    Text("Share",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info_rounded),
                      onPressed: () {
                      },
                    ),
                     Text("Details",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
