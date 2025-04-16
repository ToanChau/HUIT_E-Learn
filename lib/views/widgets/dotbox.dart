import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/upload/upload_bloc.dart';
import 'package:huit_elearn/viewModels/upload/upload_event.dart';
import 'package:huit_elearn/viewModels/upload/upload_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';

class DotBox extends StatefulWidget {
  const DotBox({super.key});

  @override
  State<DotBox> createState() => _DotboxState();
}

class _DotboxState extends State<DotBox> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadBloc, UploadState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(
                "Tải các tập tin của bạn",
                style: TextStyle(
                  color: Color.fromARGB(255, 44, 62, 80),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                "Bạn có thể tải tối đa 1 tệp mỗi lần",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
              SizedBox(height: 15),
              DottedBorder(
                borderType: BorderType.RRect,
                strokeWidth: 1.5,
                strokeCap: StrokeCap.butt,
                radius: Radius.circular(10),
                dashPattern: [8, 8, 8, 8],
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icons/upload_icon.png",
                        cacheHeight: 40,
                      ),
                    ),
                    Text("Nhấn để chọn tập tin và tải lên"),
                    state is UploadInitialState
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                File file = File(result.files.single.path!);
                                String fileName = result.files.single.name;

                                context.read<UploadBloc>().add(
                                  UploadStarted(file: file, FileName: fileName),
                                );
                                setState(() {
                                  MainView.hideNav.value = true;
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Duyệt tập tin",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Duyệt tập tin",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
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
      },
    );
  }
}
