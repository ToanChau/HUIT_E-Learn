import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class FlashView extends StatefulWidget {
  const FlashView({super.key});

  @override
  State<FlashView> createState() => _FlashViewState();
}

class _FlashViewState extends State<FlashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 62, 80),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo_light.png"),
            Text(
              "HUIT E-Learn",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}