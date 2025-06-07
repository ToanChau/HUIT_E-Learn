import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/views/screens/main_screens/changepass_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/create_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/detail_faculty_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/detail_subject_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/doc_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/editprofile_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/home_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/faculty_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/library_acceptdoc.dart';
import 'package:huit_elearn/views/screens/main_screens/library_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/profile_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/search_screen.dart';
import 'package:huit_elearn/views/screens/flash_view.dart';
import 'package:huit_elearn/views/screens/login_view.dart';
import 'package:huit_elearn/views/screens/main_screens/subject_screen.dart';
import 'package:huit_elearn/views/screens/main_screens/taketest_screen.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/screens/signin_view.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/flash',
  routes: [
    GoRoute(path: '/flash', builder: (context, state) => const FlashView()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(path: '/signin', builder: (context, state) => const SigninView()),
    GoRoute(path: '/faculty', builder: (context, state) => FacultyScreen()),
    GoRoute(path: '/subject', builder: (context, state) => SubjectScreen()),
    GoRoute(
      path: '/detailfaculty',
      builder:
          (context, state) =>
              DetailFacultyScreen(faculty: state.extra as Faculty),
    ),
    GoRoute(
      path: '/detailsubject',
      builder: (context, state) => DetailSubjectScreen(),
    ),
    GoRoute(path: '/doc', builder: (context, state) => DocScreen()),
    GoRoute(path: '/taketest', builder: (context, state) => TaketestScreen()),
    GoRoute(path: '/accept', builder: (context, state) => LibraryAcceptdoc()),
    GoRoute(path: '/edit', builder: (context, state) => EditProfileScreen()),
    GoRoute(path: '/changepass', builder: (context, state) => ChangepassScreen()),


    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainView(location: state.uri.toString(), child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder:
              (context, state) => HomeSceen(controller: MainView.controller),
          routes: [],
        ),

        GoRoute(
          path: '/search',
          builder:
              (context, state) => SearchScreen(controller: MainView.controller),
        ),

        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateScreen(),
        ),

        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryScreen(),
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
