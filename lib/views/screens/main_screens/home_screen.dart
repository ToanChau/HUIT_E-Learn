import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/screens/main_screens/detail_faculty_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/faculty_screen.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/othongtin.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

// ignore: must_be_immutable
class HomeSceen extends StatefulWidget {
  late ScrollController controller;

  HomeSceen({super.key, required ScrollController control}) {
    controller = control;
  }
  @override
  _HomeSceenState createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeSceen> {
  String? selectedValue;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<DocBloc>().add(DocInitialEvent());
  }

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
              if (state is DocInitialState || state is DocLoadingState) {
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
              } else if (state is DocSearchState) {
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
                              state.faculties.isEmpty
                                  ? "Không tìm thấy khoa nào"
                                  : "Kết quả tìm kiếm: ${state.faculties.length} khoa",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8D6E63),
                              ),
                            ),
                          ),
                        ),
                        ...state.faculties
                            .map(
                              (faculty) =>OThongTin(
                                title: faculty.tenKhoa,
                                subtitle: faculty.maKhoa,
                                logoWidget:
                                    faculty.anhKhoa.isNotEmpty
                                        ? Image.network(faculty.anhKhoa)
                                        : Image.asset("assets/images/cnm.jpg"),
                                onContainerTap: () {
                                  BlocProvider.of<DocBloc>(
                                    context,
                                  ).add(DocChoseFacultyEvent(faculty: faculty));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FacultyScreen(),
                                    ),
                                  );
                                },
                                onDetailTap: () {
                                  context.read<DocBloc>().add(
                                    DocChoseDetailFacultyEvent(
                                      faculty: faculty,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailFacultyScreen(
                                            faculty: faculty,
                                          ),
                                    ),
                                  );
                                  MainView.hideNav.value = true;
                                },
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ]),
                );
              } else if (state is DocLoadedState) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          width: double.infinity,
                          height: size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg_test.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Bạn muốn\ntạo bài kiểm tra?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.go("/create");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        "Tạo ngay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              "Chọn một khoa",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF8D6E63),
                              ),
                            ),
                          ),
                        ),
                        ...state.faculties
                            .map(
                              (faculty) => OThongTin(
                                title: faculty.tenKhoa,
                                subtitle: faculty.maKhoa,
                                logoWidget:
                                    faculty.anhKhoa.isNotEmpty
                                        ? Image.network(faculty.anhKhoa)
                                        : Image.asset("assets/images/cnm.jpg"),
                                onContainerTap: () {
                                  BlocProvider.of<DocBloc>(
                                    context,
                                  ).add(DocChoseFacultyEvent(faculty: faculty));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FacultyScreen(),
                                    ),
                                  );
                                },
                                onDetailTap: () {
                                  context.read<DocBloc>().add(
                                    DocChoseDetailFacultyEvent(
                                      faculty: faculty,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailFacultyScreen(
                                            faculty: faculty,
                                          ),
                                    ),
                                  );
                                  MainView.hideNav.value = true;
                                },
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ]),
                );
              } else {}
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
