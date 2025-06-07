// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/screens/main_screens/detail_subject_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/subject_screen.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/widgets/othongtin.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

class FacultyScreen extends StatefulWidget {
  const FacultyScreen({super.key});

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  String? selectedValue;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppbarMainCustom(
              size: size,
              searchBar: true,
              menuIcon: false,
              onlyserachbar: true,
            ),
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
                } else if (state is DocChoseFaculty) {
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
                                      state.faculty.tenKhoa,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8D6E63),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ...state.subjects.map(
                                (sub) => OThongTin(
                                  title: sub.tenMH,
                                  subtitle: sub.maMH,
                                  logoWidget:
                                      sub.anhMon.isNotEmpty
                                          ? Image.network(sub.anhMon)
                                          : Image.asset(
                                            "assets/images/cnm.jpg",
                                          ),
                                  onContainerTap: () {
                                    context.read<DocBloc>().add(
                                      DocChoseSubjecEvent(
                                        faculty: state.faculty,
                                        subject: sub,
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubjectScreen(),
                                      ),
                                    );
                                  },
                                  onDetailTap: () {
                                    context.read<DocBloc>().add(
                                      DocChoseDetailSubjectEvent(
                                        faculty: state.faculty,
                                        subject: sub,
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailSubjectScreen(),
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
                } else if (state is DocSearchFacultyState) {
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
                                state.subjects.isEmpty
                                    ? "Không tìm thấy khoa nào"
                                    : "Kết quả tìm kiếm: ${state.subjects.length} khoa",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFF8D6E63),
                                ),
                              ),
                            ),
                          ),
                          ...state.subjects.map(
                            (sub) => OThongTin(
                              title: sub.tenMH,
                              subtitle: sub.maMH,
                              logoWidget:
                                  sub.anhMon.isNotEmpty
                                      ? Image.network(sub.anhMon)
                                      : Image.asset("assets/images/cnm.jpg"),
                              onContainerTap: () {
                                context.read<DocBloc>().add(
                                  DocChoseSubjecEvent(
                                    faculty: state.faculty,
                                    subject: sub,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubjectScreen(),
                                  ),
                                );
                              },
                              onDetailTap: () {
                                context.read<DocBloc>().add(
                                  DocChoseDetailSubjectEvent(
                                    faculty: state.faculty,
                                    subject: sub,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailSubjectScreen(),
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
      ),
    );
  }
}
