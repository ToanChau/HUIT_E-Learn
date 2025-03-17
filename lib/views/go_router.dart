import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/views/screens/main_sceens/detail_major_screen.dart';
import 'package:huit_elearn/views/screens/main_sceens/detail_subject_screen.dart';
import 'package:huit_elearn/views/screens/main_sceens/home_screen.dart';
import 'package:huit_elearn/views/screens/main_sceens/major_screen.dart';
import 'package:huit_elearn/views/screens/main_sceens/search_screen.dart';
import 'package:huit_elearn/views/screens/flash_view.dart';
import 'package:huit_elearn/views/screens/login_view.dart';
import 'package:huit_elearn/views/screens/main_sceens/subject_screen.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/screens/signin_view.dart';

// Define your router
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/flash',
  routes: [
    GoRoute(path: '/flash', builder: (context, state) => const FlashView()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(path: '/signin', builder: (context, state) => const SigninView()),

    GoRoute(
      path: '/detailmajor',
      builder: (context, state) => DetailMajorScreen(),
    ),
    GoRoute(
      path: '/detailsubject',
      builder: (context, state) => DetailSubjectScreen(),
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainView(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeSceen(control: MainView.controller),
          routes: [
            
            GoRoute(path: 'major', builder: (context, state) => MajorSceen()),

            // GoRoute(
            //   path: 'detail',
            //   builder:
            //       (context, state) => DetailMajorScreen(), 
            // ),
          ],
        ),
       
        GoRoute(
          path: '/search',
          builder: (context, state) =>  SearchScreen(control:  MainView.controller,),
        ),
        
        GoRoute(
          path: '/create',
          builder: (context, state) => const Placeholder(),
        ),
       
        GoRoute(
          path: '/document',
          builder: (context, state) => const Placeholder(),
        ),
      
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
  ],
);
