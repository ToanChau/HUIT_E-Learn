import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/widgets/sliverappbar.dart';
import 'package:huit_elearn/views/widgets/title.dart';

class DetailSubjectScreen extends StatelessWidget {
  const DetailSubjectScreen({super.key});

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
                      context.read<DocBloc>().add(DocInitialEvent());
                      context.go("/home");
                    },
                    child: Text("Quay lại"),
                  ),
                ],
              ),
            );
          } else if (state is DocChoseDetailSubject) {
            return CustomScrollView(
              slivers: [
                SliverAppbarDetailCustom(
                  uRLImage: state.subject.anhMon,
                  Name: state.subject.tenMH,
                  Subtitle: state.subject.maMH,
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
                      child: Text(state.subject.gioiThieu),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TitleCustom(
                        tieude: "Chương trình giảng dạy",
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(state.subject.chuongTrinhDT),
                    ),
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
