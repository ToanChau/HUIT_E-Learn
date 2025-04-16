import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_bloc.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_state.dart';
import 'package:huit_elearn/views/screens/main_screens/createtest_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/upload_screen.dart';
import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var state = context.watch<CreatetestBloc>().state;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppbarMainCustom(
            size: size,
            searchBar: false,
            menuIcon: (state is ChoseFacultyState||state is ChoseSubjectState||state is CreateTestLoadingState||state is ChoseCreateTestState)?false:true,
            onlyserachbar: true,
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[200],
                      ),
                      child: TabBar(
                        controller: controller,
                        unselectedLabelColor: const Color.fromARGB(
                          255,
                          1,
                          53,
                          42,
                        ),
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: const Color.fromARGB(255, 44, 62, 80),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: "Tải lên tài liệu"),
                          Tab(text: "Tạo bài kiểm tra"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: const [
                        UploadScreen(),
                        CreateTestScreen()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
