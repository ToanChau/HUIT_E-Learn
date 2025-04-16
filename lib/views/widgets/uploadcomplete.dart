import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:huit_elearn/viewModels/upload/upload_bloc.dart';
import 'package:huit_elearn/viewModels/upload/upload_event.dart';
import 'package:path/path.dart' as p;

class Uploadcomplete extends StatelessWidget {
  final String fileName;
  final int fileSize;
  Uploadcomplete({super.key, required this.fileName, required this.fileSize});

  String formatFileSize(int fileSizeInBytes) {
    if (fileSizeInBytes >= 1024 * 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
    } else if (fileSizeInBytes >= 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    } else {
      return "${(fileSizeInBytes / 1024).toStringAsFixed(1)} KB";
    }
  }

  final Map<String, String> fileIcons = {
    "pdf": "assets/icons/pdf_icon.svg",
    "docx": "assets/icons/doc_icon.svg",
    "doc": "assets/icons/doc_icon.svg",
    "txt": "assets/icons/txt_icon.svg",
    "ppt": "assets/icons/ppt_icon.svg",
  };

  @override
  Widget build(BuildContext context) {
    String type = p.extension(fileName).replaceFirst(".", '').toLowerCase();
    String path = fileIcons[type.toLowerCase()] ?? "assets/icons/txt_icon.svg";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 219, 219, 219),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(path, fit: BoxFit.scaleDown),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Flexible(
                          child: Text(
                            formatFileSize(fileSize),
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: IconButton(
                      iconSize: 12,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        context.read<UploadBloc>().add(UploadCancelled());
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 120, 120, 120),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
