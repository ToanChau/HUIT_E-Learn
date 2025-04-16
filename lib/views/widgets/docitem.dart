import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:huit_elearn/models/documents.dart';

Widget DocItem({required Document document}) {
  final Map<String, String> fileIcons = {
  "pdf": "assets/icons/pdf_icon.svg",
  "docx": "assets/icons/doc_icon.svg",
  "doc": "assets/icons/doc_icon.svg",
  "txt": "assets/icons/txt_icon.svg",
  "ppt": "assets/icons/ppt_icon.svg",
};

String path = fileIcons[document.loai.toLowerCase()] ?? "assets/icons/txt_icon.svg";

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            path,
            fit: BoxFit.scaleDown,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        document.tenTaiLieu,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        document.ngayDang.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Icon(Icons.more_vert_outlined),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
