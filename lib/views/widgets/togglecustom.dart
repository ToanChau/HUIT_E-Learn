import 'package:flutter/material.dart';

class Togglecustom extends StatefulWidget {
  final bool isList;
  final Function(bool) onToggle;

  const Togglecustom({super.key, required this.isList, required this.onToggle});

  @override
  State<Togglecustom> createState() => _TogglecustomState();
}

class _TogglecustomState extends State<Togglecustom> {
  late bool isList;

  @override
  void initState() {
    super.initState();
    isList = widget.isList;
  }

  @override
  void didUpdateWidget(Togglecustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isList != widget.isList) {
      isList = widget.isList;
    }
  }

  void _toggle() {
    setState(() {
      isList = !isList;
    });
    widget.onToggle(isList);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 104, 104, 104)
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: CircleAvatar(
                  backgroundColor:
                      isList ? Color.fromARGB(255, 44, 62, 80) : Colors.white,
                  child: Icon(
                    Icons.view_list_rounded,
                    color: isList ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: CircleAvatar(
                  backgroundColor:
                      isList ? Colors.white : Color.fromARGB(255, 44, 62, 80),
                  child: Icon(
                    Icons.view_module_rounded,
                    color: isList ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
