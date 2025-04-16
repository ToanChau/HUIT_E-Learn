import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:huit_elearn/views/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        // Thiết lập font mặc định bằng textTheme
        textTheme: GoogleFonts.robotoFlexTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Thiết lập font cho dark theme
        textTheme: GoogleFonts.robotoMonoTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      routerConfig: router,
    );
  }
}
