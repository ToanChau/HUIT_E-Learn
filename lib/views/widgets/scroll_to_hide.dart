import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HiddenNav extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final ValueNotifier<bool> isHideNotifier;
  final double height;

  const HiddenNav({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 100),
    required this.isHideNotifier,
    required this.height,
  });

  @override
  State<HiddenNav> createState() => _HiddenNavState();
}

class _HiddenNavState extends State<HiddenNav> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
    widget.isHideNotifier.addListener(updateVisibility);
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

  void updateVisibility() {
    setState(() {
      isVisible = !widget.isHideNotifier.value;
    });
  }

  void show() {
  if (!isVisible) {
    widget.isHideNotifier.value = false; 
    setState(() => isVisible = true);
  }
}

void hide() {
  if (isVisible) {
    widget.isHideNotifier.value = true; 
    setState(() => isVisible = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isHideNotifier,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: widget.duration,
          height: isVisible ? widget.height + 10 : 0,
          child: Wrap(children: [widget.child]),
        );
      },
    );
  }
}
