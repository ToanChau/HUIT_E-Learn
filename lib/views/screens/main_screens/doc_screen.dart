import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/widgets/scroll_to_hide.dart';
import 'package:huit_elearn/views/widgets/sliverappbar.dart';
import 'package:huit_elearn/views/widgets/title.dart';

class DocScreen extends StatefulWidget {
  const DocScreen({super.key});

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  final ScrollController controller = ScrollController();
  static ValueNotifier<bool> hide = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          body: BlocBuilder<DocBloc, DocState>(
            builder: (context, state) {
              if (state is DocLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DocErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: TextStyle(color: Colors.red)),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DocBloc>().add(DocInitialEvent());
                          context.go("/home");
                        },
                        child: Text("Quay lại"),
                      ),
                    ],
                  ),
                );
              } else if (state is DocChoseDoc || state is SearchChoseDocState) {
                Document doc =
                    state is DocChoseDoc
                        ? state.document
                        : (state as SearchChoseDocState).document;
                return CustomScrollView(
                  controller: controller,
                  slivers: [
                    SliverAppbarDetailCustom(
                      uRLImage:
                          (doc.previewImages != null &&
                                  doc.previewImages!.isNotEmpty)
                              ? doc.previewImages![0]
                              : "assets/images/doctest.jpg",
                      Name: doc.tenTaiLieu,
                      Subtitle:
                          "Ngày đăng ${DateFormat('dd/MM/yyyy').format(doc.ngayDang)}",
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TitleCustom(
                            tieude: "Mô tả",
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(doc.moTa),
                        ),
                      ]),
                    ),
                  ],
                );
              } else if (state is DocDownloadingState ||
                  state is DocDownloadCompleteState) {
                final Document document =
                    state is DocDownloadingState
                        ? state.document
                        : (state as DocDownloadCompleteState).document;

                return CustomScrollView(
                  controller: controller,
                  slivers: [
                    SliverAppbarDetailCustom(
                      uRLImage:
                          (document.previewImages != null &&
                                  document.previewImages!.isNotEmpty)
                              ? document.previewImages![0]
                              : "assets/images/doctest.jpg",
                      Name: document.tenTaiLieu,
                      Subtitle:
                          "Ngày đăng ${DateFormat('dd/MM/yyyy').format(document.ngayDang)}",
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TitleCustom(
                            tieude: "Mô tả",
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(document.moTa),
                        ),
                      ]),
                    ),
                  ],
                );
              }
             return CustomScrollView(
  controller: controller,
  slivers: [
    SliverToBoxAdapter(
      child: Center(child: CircularProgressIndicator()),
    ),
  ],
);
            },
          ),
        ),
        Positioned(
          top: 30,
          right: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 231, 231),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite, color: Colors.red, size: 30),
          ),
        ),
        Positioned(
          bottom: 0,
          child: HiddenNav(
            height: kBottomNavigationBarHeight * 2.5,
            isHideNotifier: hide,
            controller: controller,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(21, 255, 255, 255),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final document =
                            (context.read<DocBloc>().state as DocChoseDoc)
                                .document;

                        bool isDownloading = true;
                        double progress = 0;
                        double remainingTime = 0;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return BlocListener<DocBloc, DocState>(
                                  listener: (context, state) {
                                    if (state is DocDownloadingState) {
                                      setState(() {
                                        isDownloading = true;
                                        progress = state.progress;
                                        remainingTime = state.remainingSeconds;
                                      });
                                    } else if (state
                                            is DocDownloadCompleteState ||
                                        state is DocErrorState) {
                                      setState(() {
                                        isDownloading = false;
                                      });
                                    }
                                  },
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    titlePadding: const EdgeInsets.fromLTRB(
                                      24,
                                      24,
                                      24,
                                      0,
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                      24,
                                      12,
                                      24,
                                      24,
                                    ),
                                    actionsPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isDownloading) ...[
                                            LinearProgressIndicator(
                                              value: progress,
                                              minHeight: 6,
                                              backgroundColor: Colors.grey[300],
                                              color: Color.fromARGB(
                                                255,
                                                44,
                                                62,
                                                80,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Đang tải: ${(progress * 100).toStringAsFixed(0)}%',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Còn lại: ${remainingTime > 60 ? '${(remainingTime / 60).toStringAsFixed(0)} phút' : '${remainingTime.toStringAsFixed(0)} giây'}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ] else
                                            Column(
                                              children: const [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 60,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  'Tải xuống thành công!',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      if (!isDownloading)
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Color.fromARGB(
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
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text('OK'),
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
                          },
                        );

                        context.read<DocBloc>().add(
                          DocDownloadEvent(document: document),
                        );
                      },
                      child: Text(
                        "Tải xuống",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 44, 62, 80),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextButton(
                      onPressed: () {},
                      child: FittedBox(
                        child: Text(
                          "Báo cáo",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          168,
                          226,
                          204,
                          204,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
