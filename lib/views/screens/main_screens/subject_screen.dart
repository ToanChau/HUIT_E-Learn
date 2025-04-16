// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:huit_elearn/views/screens/main_screens/doc_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/widgets/doccard.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  _SubjectSceenState createState() => _SubjectSceenState();
}

class _SubjectSceenState extends State<SubjectScreen> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      final direction = _controller.position.userScrollDirection;
      if (direction == ScrollDirection.reverse) {
        MainView.hideNav.value = true;
      } else if (direction == ScrollDirection.forward) {
        MainView.hideNav.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppbarMainCustom(size: size, searchBar: true, menuIcon: false),
          BlocBuilder<DocBloc, DocState>(
            builder: (context, state) {
              if (state is DocLoadingState) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is DocErrorState) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<DocBloc>(
                                context,
                              ).add(DocInitialEvent());
                            },
                            child: Text("Thử lại"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is DocChoseSubject) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    state.subject.tenMH,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8D6E63),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ...state.documents.map(
                              (doc) => DocCard(
                                title: doc.tenTaiLieu,
                                subtitle: doc.moTa,
                                type: doc.loai,
                                date: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(doc.ngayDang),
                                logoWidget:
                                    (doc.previewImages != null &&
                                            doc.previewImages!.isNotEmpty)
                                        ? Image.network(doc.previewImages![0])
                                        : Image.asset(
                                          "assets/images/doctest.jpg",
                                        ),
                                onContainerTap: () {
                                  context.read<DocBloc>().add(
                                    DocChoseDocEvent(
                                      document: doc,
                                      faculty: state.faculty,
                                      subject: state.subject,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocScreen(),
                                    ),
                                  );
                                  MainView.hideNav.value = true;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                );
              }
              else if(state is DocSearchSubjectState)
              {
                  return SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              state.documents.isEmpty
                                  ? "Không tìm thấy tài liệu nào"
                                  : "Kết quả tìm kiếm: ${state.documents.length} tài liệu",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8D6E63),
                              ),
                            ),
                          ),
                        ),
                       ...state.documents.map(
                              (doc) => DocCard(
                                title: doc.tenTaiLieu,
                                subtitle: doc.moTa,
                                type: doc.loai,
                                date: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(doc.ngayDang),
                                logoWidget:
                                    (doc.previewImages != null &&
                                            doc.previewImages!.isNotEmpty)
                                        ? Image.network(doc.previewImages![0])
                                        : Image.asset(
                                          "assets/images/doctest.jpg",
                                        ),
                                onContainerTap: () {
                                  context.read<DocBloc>().add(
                                    DocChoseDocEvent(
                                      document: doc,
                                      faculty: state.faculty,
                                      subject: state.subject,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocScreen(),
                                    ),
                                  );
                                  MainView.hideNav.value = true;
                                },
                              ),
                            ),
                      ],
                    ),
                  ]),
                );
              }
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
