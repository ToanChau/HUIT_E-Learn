import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_event.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  Icon? confirmIcon;

  void isValidPassWord() {
    if ((_confirmpasswordController.text == _passwordController.text) &&
        _passwordController.text.isNotEmpty) {
      confirmIcon = const Icon(Icons.check_circle, color: Colors.green);
    } else {
      confirmIcon = null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go("/home");
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * (isSmallScreen ? 0.05 : 0.3),
                ),
                child: ListView(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Center(
                      child: SizedBox(
                        width: isSmallScreen ? size.width * 0.3 : 120,
                        height: isSmallScreen ? size.width * 0.3 : 120,
                        child: Image.asset(
                          "assets/images/logo_dark.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(letterSpacing: 3),
                              border: const UnderlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                              suffixIcon:
                                  _emailController.text.isNotEmpty
                                      ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phonenumberController,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: const TextStyle(letterSpacing: 3),
                              border: const UnderlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              prefixIcon: const Icon(Icons.phone_outlined),
                              suffixIcon:
                                  _phonenumberController.text.isNotEmpty
                                      ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                      : null,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            onChanged:
                                (text) => {
                                  setState(() {
                                    isValidPassWord();
                                  }),
                                },
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(letterSpacing: 3),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: confirmIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _confirmpasswordController,
                            obscureText: true,
                            onChanged: (text) {
                              setState(() {
                                isValidPassWord();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(letterSpacing: 3),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: confirmIcon,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.04),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          UserModel newUser = UserModel(
                            maNguoiDung: "",
                            eMail: _emailController.text,
                            sDT: _phonenumberController.text,
                            anhDaiDien: "",
                            gioiTinh: "nam",
                            matKhau: _passwordController.text,
                            ngaySinh: DateTime.now(),
                            tenNguoiDung: ''
                          );
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthSignUp(
                              user: newUser,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          elevation: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          overlayColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Đăng nhập ngay',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[400])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Text(
                              'Hoặc',
                              style: TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[400])),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.apple,
                              color: Colors.black,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tiếp tục với Apple',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google_icon.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tiếp tục với Google',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
