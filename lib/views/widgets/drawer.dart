import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';

class DrawerCustom extends StatelessWidget {
  final UserModel user;
  const DrawerCustom({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    user.tenNguoiDung ?? 'Anonymus',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(user.eMail),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        state.user.anhDaiDien != null &&
                                state.user.anhDaiDien!.isNotEmpty
                            ? NetworkImage(state.user.anhDaiDien!)
                            : const AssetImage("assets/images/user.jpg")
                                as ImageProvider,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 44, 62, 80),
                  ),
                );
              }
              return UserAccountsDrawerHeader(
                accountName: Text(
                  'Anonymous',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text('Anonymous@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      const AssetImage("assets/images/user.jpg")
                          as ImageProvider,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 44, 62, 80),
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              children: [
                DrawerItem(
                  icon: Icons.person,
                  title: "Tài khoản",
                  subtitle: "Quản lý tài khoảng của bạn",
                  onTap: () {
                    context.go('/profile');
                    context.push('/edit');
                  },
                ),

                GestureDetector(
                  child: DrawerItem(
                    icon: Icons.security,
                    title: "Bảo mật",
                    subtitle: "Đổi mật khẩu của bạn",
                  ),
                ),
                GestureDetector(
                  child: DrawerItem(
                    icon: Icons.folder,
                    title: "Thư viện của tôi",
                    subtitle: "Quản lý tất cả tập tin của bạn",
                    onTap: () {
                      context.go('/library');
                    },
                  ),
                ),
                GestureDetector(
                  child: DrawerItem(
                    icon: Icons.settings,
                    title: "Cài đặt",
                    subtitle: "Đặt thông báo",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 44, 62, 80)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle!,
                maxLines: 1,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              )
              : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}
