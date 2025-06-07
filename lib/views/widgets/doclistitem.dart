import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:huit_elearn/models/documents.dart';

Widget DocListItem({required Document document,required Function() onContainerTap, required Function() onDetailTap}) {
  final Map<String, String> fileIcons = {
    "pdf": "assets/icons/pdf_icon.svg",
    "docx": "assets/icons/doc_icon.svg",
    "doc": "assets/icons/doc_icon.svg",
    "txt": "assets/icons/txt_icon.svg",
    "ppt": "assets/icons/ppt_icon.svg",
  };
  String formatFileSize(int fileSizeInBytes) {
    if (fileSizeInBytes >= 1024 * 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
    } else if (fileSizeInBytes >= 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    } else {
      return "${(fileSizeInBytes / 1024).toStringAsFixed(1)} KB";
    }
  }

  String path = fileIcons[document.loai.toLowerCase()] ?? "assets/icons/txt_icon.svg";

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListTile(
      onTap: () => onContainerTap(),
      contentPadding: EdgeInsets.zero,
      leading: 
       SizedBox(
          height: 30,width: 30,child: SvgPicture.asset(path, fit: BoxFit.scaleDown)),
      
      title: Text(document.tenTaiLieu, style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1,),
      subtitle: Text("${DateFormat('dd/MM/yyyy').format(document.ngayDang)} • ${formatFileSize(document.kichThuoc)}",style: TextStyle(fontSize: 13,color: Colors.grey),overflow: TextOverflow.ellipsis,maxLines: 1,),
      trailing: GestureDetector(onTap: ()=> onDetailTap(),child: Icon(Icons.more_vert)),
    ),
  );
}
