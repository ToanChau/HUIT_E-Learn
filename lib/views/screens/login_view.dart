import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_event.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/views/screens/signin_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          }
          if (state is AuthLoading) {
            Scaffold(body: Center(child: CircularProgressIndicator()));
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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

                      SizedBox(height: size.height * 0.05),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(letterSpacing: 3),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                          ),

                          if (_emailController.text.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
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
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(letterSpacing: 3),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: Colors.transparent,
                          ),
                          child: Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.01),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              AuthSignIn(
                                email: _emailController.text,
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
                            'Đăng nhập',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SigninView(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * (isSmallScreen ? 0.01 : 0.05),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[400])),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                      SizedBox(
                        height: size.height * (isSmallScreen ? 0.01 : 0.05),
                      ),

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
                          onPressed: () {
                            context.go("/home");
                          },
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

                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
