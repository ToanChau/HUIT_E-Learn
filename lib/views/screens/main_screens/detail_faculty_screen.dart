// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/widgets/lecturercard.dart';
import 'package:huit_elearn/views/widgets/sliverappbar.dart';
import 'package:huit_elearn/views/widgets/title.dart';

class DetailFacultyScreen extends StatelessWidget {
  final Faculty faculty;
  const DetailFacultyScreen({super.key, required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
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
                      context.read<DocBloc>().add(
                        DocChoseDetailFacultyEvent(faculty: faculty),
                      );
                    },
                    child: Text("Thử lại"),
                  ),
                ],
              ),
            );
          } else if (state is DocChoseDetailFaculty) {
            return CustomScrollView(
              slivers: [
                SliverAppbarDetailCustom(
                  uRLImage: faculty.anhKhoa,
                  Name: faculty.tenKhoa,
                  Subtitle: faculty.maKhoa,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TitleCustom(
                        tieude: "Giới thiệu",
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(faculty.gioiThieu),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TitleCustom(
                        tieude: "Giảng viên",
                        color: Colors.black,
                      ),
                    ),
                    state.lecturers.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height:MediaQuery.of(context).size.height*0.3,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.lecturers.length,
                              itemBuilder: (context, index) {
                                var lecturer = state.lecturers[index];
                                return LecturerCard(lecturer: lecturer);
                              },
                            ),
                          ),
                        )
                        : SizedBox(),
                  ]),
                ),
              ],
            );
          }
          return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
