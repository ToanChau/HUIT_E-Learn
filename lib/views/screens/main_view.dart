import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/views/widgets/scroll_to_hide.dart';

class MainView extends StatefulWidget {
  final Widget child;
  final String location; 
  static late ScrollController controller;
  static ValueNotifier<bool> hideNav = ValueNotifier<bool>(false);
  const MainView({
    super.key,
    required this.child,
    required this.location, 
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int _currentIndex;

  final iCons = <Widget>[
    Icon(Icons.home_rounded, color: Colors.white),
    Icon(Icons.search_rounded, color: Colors.white),
    Icon(Icons.add, color: Colors.white),
    Icon(Icons.edit_document, color: Colors.white),
    Icon(Icons.person, color: Colors.white),
  ];

  @override
  void initState() {
    super.initState();
    MainView.controller = ScrollController();
    _updateIndex();
  }

  @override
  void didUpdateWidget(MainView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _updateIndex();
    }
  }

  void _updateIndex() {
    _currentIndex = _getIndexFromRoute(widget.location);
  }

  int _getIndexFromRoute(String route) {
    if (route.startsWith('/home')) return 0;
    if (route.startsWith('/search')) return 1;
    if (route.startsWith('/create')) return 2;
    if (route.startsWith('/library')) return 3;
    if (route.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(int index) {
    String newRoute;
    switch (index) {
      case 0:
        newRoute = '/home';
        BlocProvider.of<DocBloc>(context).add(DocInitialEvent());
        break;
      case 1:
        newRoute = '/search';
        BlocProvider.of<DocBloc>(context).add(SearchOnSearchScreenEvent());
        break;
      case 2:
        newRoute = '/create';
        break;
      case 3:
        newRoute = '/library';
        break;
      case 4:
        newRoute = '/profile';
        break;
      default:
        newRoute = '/home';
    }

    if (newRoute != widget.location) {
      context.go(newRoute);
    }
  }

  @override
  void dispose() {
    MainView.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: HiddenNav(
          height: kBottomNavigationBarHeight + 10,
          isHideNotifier: MainView.hideNav,
          controller: MainView.controller,
          child: CurvedNavigationBar(
            index: _currentIndex,
            onTap: _onTap,
            items: iCons,
            backgroundColor: Colors.transparent,
            color: Color.fromARGB(255, 44, 62, 80),
            animationDuration: Duration(milliseconds: 400),
          ),
        ),
      ),
    );
  }
}
