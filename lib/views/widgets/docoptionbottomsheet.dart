import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_bloc.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_event.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_state.dart';
import 'package:huit_elearn/views/widgets/docdetailbottomsheet.dart';
import 'package:intl/intl.dart';

class Docoptionbottomsheet extends StatefulWidget {
  final Document document;
  const Docoptionbottomsheet({super.key, required this.document});

  @override
  State<Docoptionbottomsheet> createState() => _DocoptionbottomsheetState();
}

class _DocoptionbottomsheetState extends State<Docoptionbottomsheet> {
  String formatFileSize(int fileSizeInBytes) {
    if (fileSizeInBytes >= 1024 * 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
    } else if (fileSizeInBytes >= 1024 * 1024) {
      return "${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    } else {
      return "${(fileSizeInBytes / 1024).toStringAsFixed(1)} KB";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        :  Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30),
            child: Text(
              widget.document.tenTaiLieu,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 30),
            child: Row(
              children: [
                Text(
                  "${DateFormat('dd/MM/yyyy').format(widget.document.ngayDang)}  •  ${formatFileSize(widget.document.kichThuoc)}",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color:Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        :  Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _buildOptionItem(
            context,
            icon: Icons.share,
            text: "Chia sẻ",
            ontap: () {},
          ),
          _buildOptionItem(
            context,
            icon: Icons.download_for_offline_outlined,
            text: "Tải xuống",
            ontap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  return BlocProvider(
                    create:
                        (_) =>
                            LibrarydownloadBloc()..add(
                              LibrarydownloadStartEvent(
                                document: widget.document,
                              ),
                            ),
                    child: BlocBuilder<
                      LibrarydownloadBloc,
                      LibrarydownloadState
                    >(
                      builder: (context, state) {
                        if (state is LibrarydownloadingState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LinearProgressIndicator(
                                    value: state.progress,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey[300],
                                    color: Color.fromARGB(255, 44, 62, 80),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Đang tải: ${(state.progress * 100).toStringAsFixed(1)}%",
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is LibrarydownloadComplete) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 60,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Tải xuống thành công!',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<LibrarydownloadBloc>().add(
                                    LibrarydownloadInitialEvent(),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                44,
                                                62,
                                                80,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is Librarydownloadfailed) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline, size: 60),
                                SizedBox(height: 12),
                                Text(
                                  "Tải xuống thất bại!",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<LibrarydownloadBloc>().add(
                                    LibrarydownloadInitialEvent(),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                44,
                                                62,
                                                80,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text("Đang chuẩn bị tải..."),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
          _buildOptionItem(
            context,
            icon: Icons.info_outlined,
            text: "Chi tiết",
            ontap: () {
              showBottomSheet(
                context: context,
                builder:
                    (context) => Docdetailbottomsheet(
                      type: widget.document.loai,
                      size: formatFileSize(widget.document.kichThuoc),
                      date: DateFormat(
                        'dd/MM/yyyy',
                      ).format(widget.document.ngayDang),
                    ),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Function() ontap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ontap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 35, 35, 35)
        :  Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(icon),
                SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
