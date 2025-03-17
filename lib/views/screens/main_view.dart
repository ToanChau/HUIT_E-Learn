import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/views/widgets/scroll_to_hide.dart';

class MainView extends StatefulWidget {
  final Widget child;
  static late ScrollController controller;
  

  const MainView({Key? key, required this.child}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final iCons = <Widget>[
    Icon(Icons.home_rounded, color: const Color.fromARGB(255, 255, 255, 255)),
    Icon(Icons.search_rounded, color: Colors.white),
    Icon(Icons.add, color: Colors.white),
    Icon(Icons.edit_document, color: Colors.white),
    Icon(Icons.person, color: const Color.fromARGB(255, 255, 255, 255)),
  ];

  @override
  void initState() {
    super.initState();
    MainView.controller = ScrollController();
  }

  @override
  void dispose() {
    MainView.controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/document');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: HiddenNav(
          controller: MainView.controller,
          child: CurvedNavigationBar(
            index: _currentIndex,
            onTap: _onTap,
            items: iCons,
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 33, 33, 33),
            animationDuration: Duration(milliseconds: 400),
          ),
        ),
      ),
    );
  }
}
