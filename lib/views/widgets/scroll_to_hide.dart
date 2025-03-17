import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HiddenNav extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;

  const HiddenNav({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  State<HiddenNav> createState() => _HiddenNavState();
}

class _HiddenNavState extends State<HiddenNav> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() => isVisible = true);
    }
  }

  void hide() {
    if (isVisible) {
      setState(() => isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? kBottomNavigationBarHeight + 20 : 0,
      child: Wrap(children: [widget.child]),
    );
  }
}
