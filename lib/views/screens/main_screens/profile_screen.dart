import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_event.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/views/widgets/profileitem.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String tenNguoiDung = "Anonymous";
          if (state is AuthAuthenticated) {
            tenNguoiDung = state.user.tenNguoiDung ?? tenNguoiDung;

            return Column(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          state.user.anhDaiDien ??
                              'https://firebasestorage.googleapis.com/v0/b/huit-e-learn.firebasestorage.app/o/AnhNguoiDung%2Fnguoidung4.jpg?alt=media&token=850489cf-2e01-4312-a74e-1cf8c85c2bad',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(tenNguoiDung),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      ProfileItem(
                        Icons.person_rounded,
                        "Tài khoản",
                        "Quản lý tài khoản của bạn",
                        () {
                          context.push('/edit');
                        },
                      ),
                      ProfileItem(
                        Icons.security,
                        "Đổi mật khẩu",
                        "Đổi mật khẩu của bạn",
                        () {
                          context.push('/changepass');
                        },
                      ),
                      ProfileItem(
                        Icons.folder,
                        "Thư viện của tôi",
                        "Quản lý tất cả các tập tin của bạn",
                        () {
                          context.push('/library');
                        },
                      ),
                      ProfileItem(
                        Icons.settings,
                        "Cài đặt",
                        "Đặt thông báo",
                        () {
                          context.push('/edit');
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Bạn có chắc chắn muốn\nđăng xuất không?",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(),
                                        SizedBox(height: 10),
                                        Text(
                                          "Bạn phải đăng nhập lại nếu muốn sử dụng ứng dụng này.",
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  BlocProvider.of<AuthBloc>(
                                                    context,
                                                  ).add(AuthSignOut());
                                                  context.go("/login");
                                                },
                                                child: FittedBox(
                                                  child: Text(
                                                    "Đăng xuất",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                child: FittedBox(
                                                  child: Text(
                                                    "Hủy",
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: FittedBox(
                            child: Text(
                              "Đăng xuất",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(0, 246, 245, 245),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: FittedBox(
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 44, 62, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
