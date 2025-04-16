// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/screens/main_screens/doc_screen.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/widgets/doccard.dart';

import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

class SearchScreen extends StatefulWidget {
  final ScrollController controller;

  const SearchScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return DrawerCustom(user: state.user);
          }
          return DrawerCustom(
            user: UserModel(
              maNguoiDung: "anonymous_id",
              eMail: "exemple@gmail.com",
              sDT: "09090909",
              anhDaiDien:  "Anonymous",
              gioiTinh: "Nam",
              matKhau: "",
              ngaySinh: DateTime.now(),
              tenNguoiDung: "Anonymous"
            ),
          );
        },
      ),
      body: CustomScrollView(
        controller: widget.controller,
        slivers: [
          SliverAppbarMainCustom(
            size: size,
            searchBar: true,
            menuIcon: true,
            onlyserachbar: true,
          ),
          BlocBuilder<DocBloc, DocState>(
            builder: (context, state) {
              if (state is SearchingonScreen) {
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
                            date: DateFormat('dd/MM/yyyy').format(doc.ngayDang),
                            logoWidget:
                                (doc.previewImages != null &&
                                        doc.previewImages!.isNotEmpty)
                                    ? Image.network(doc.previewImages![0])
                                    : Image.asset("assets/images/doctest.jpg"),
                            onContainerTap: () {
                              context.read<DocBloc>().add(
                                    SearchChoseDocEvent(
                                      document: doc,
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
              } else if (state is SearchScreenstate) {
                return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: Text("Bạn cần tìm tài liệu gì")),
                ),
              );
              }
               return SliverToBoxAdapter(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<DocBloc>().add(SearchOnSearchScreenEvent());
                          context.go("/search");
                        },
                        child: Text("Quay lại"),
                      ),
                    ],
                  ),
              );
            },
          ),
        ],
      ),
    );
  }
}
