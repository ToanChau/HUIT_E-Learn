import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/library/library_bloc.dart';
import 'package:huit_elearn/viewModels/library/library_event.dart';
import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
        slivers: [
          SliverAppbarMainCustom(
            size: size,
            searchBar: false,
            menuIcon: true,
            onlyserachbar: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          "File",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        color: Color.fromARGB(255, 44, 62, 80),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 35, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    String maNguoiDung =
                        (BlocProvider.of<AuthBloc>(context).state
                                as AuthAuthenticated)
                            .user
                            .maNguoiDung;
                    BlocProvider.of<LibraryBloc>(context).add(
                      LibraryChoseAcceptedDocEvent(maNguoiDung: maNguoiDung),
                    );
                    context.push("/accept");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Đã phê duyệt",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Icon(Icons.navigate_next_rounded),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 35, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    String maNguoiDung =
                        (BlocProvider.of<AuthBloc>(context).state
                                as AuthAuthenticated)
                            .user
                            .maNguoiDung;
                    BlocProvider.of<LibraryBloc>(context).add(
                      LibraryChoseUnAcceptedDocEvent(maNguoiDung: maNguoiDung),
                    );
                    context.push("/accept");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Đang chờ duyệt",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Icon(Icons.navigate_next_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
