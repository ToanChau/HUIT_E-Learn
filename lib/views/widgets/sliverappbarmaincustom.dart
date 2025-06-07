import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_bloc.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_event.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_state.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/viewModels/theme/theme_bloc.dart';
import 'package:huit_elearn/viewModels/theme/theme_event.dart';
import 'package:huit_elearn/viewModels/theme/theme_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';

class SliverAppbarMainCustom extends StatefulWidget {
  final Size size;
  final bool searchBar;
  final bool menuIcon;
  final bool? onlyserachbar;
  const SliverAppbarMainCustom({
    super.key,
    required this.size,
    required this.searchBar,
    required this.menuIcon,
    this.onlyserachbar,
  });

  @override
  State<SliverAppbarMainCustom> createState() => _SliverAppbarMainCustomState();
}

class _SliverAppbarMainCustomState extends State<SliverAppbarMainCustom> {
  final List<String> dropdownItems = ["Tùy chọn 1", "Tùy chọn 2", "Tùy chọn 3"];
  String? selectedValue;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final searchQuery = _searchController.text;
      context.read<DocBloc>().add(DocSearchEvent(searchQuery: searchQuery));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return SliverAppBar(
          backgroundColor: themeState.isDarkMode ? Colors.black : Colors.white,
          toolbarHeight: 0,
          expandedHeight: widget.size.height * (widget.searchBar ? 0.15 : 0.075),
          floating: true,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      widget.menuIcon
                          ? Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Icon(
                                  Icons.menu, 
                                  color: themeState.isDarkMode ? Colors.white : Colors.black
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          )
                          : IconButton(
                            onPressed: () {
                              var createstate =
                                  BlocProvider.of<CreatetestBloc>(context).state;
                              var docstate =
                                  BlocProvider.of<DocBloc>(context).state;
                              if (createstate is ChoseSubjectState) {
                                var currentstate = createstate;
                                context.read<CreatetestBloc>().add(
                                  ChoseFacultyEvent(currentstate.faculty),
                                );
                              } else if (createstate is ChoseCreateTestState) {
                                MainView.hideNav.value = false;
                                context.read<CreatetestBloc>().add(
                                  ChoseSubjectEvent(
                                    subject: createstate.subject,
                                    userID: createstate.useID,
                                    faculty: createstate.faculty,
                                  ),
                                );
                              } else if (createstate is ChoseFacultyState ||
                                  createstate is CreateTestLoadingState) {
                                context.read<CreatetestBloc>().add(
                                  CreateTestInitialEvent(),
                                );
                              } else if (docstate is DocChoseFaculty) {
                                context.read<DocBloc>().add(DocInitialEvent());
                                Navigator.of(context).pop();
                              } else if (docstate is DocChoseSubject) {
                                context.read<DocBloc>().add(
                                  DocChoseFacultyEvent(faculty: docstate.faculty),
                                );
                                Navigator.of(context).pop();
                              } else if (docstate is DocErrorState) {
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                                context.read<DocBloc>().add(DocInitialEvent());
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: themeState.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: themeState.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          context.read<ThemeBloc>().add(ThemeToggleEvent());
                        },
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: CircleAvatar(
                                backgroundImage:
                                    state.user.anhDaiDien != null &&
                                            state.user.anhDaiDien!.isNotEmpty
                                        ? NetworkImage(state.user.anhDaiDien!)
                                        : const AssetImage("assets/images/user.jpg")
                                            as ImageProvider,
                                radius: 18,
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.jpg"),
                              radius: 18,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.searchBar)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              color: themeState.isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm...",
                              hintStyle: TextStyle(
                                color: themeState.isDarkMode ? Colors.white70 : Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              fillColor: themeState.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: themeState.isDarkMode ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        if (widget.onlyserachbar != true) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: selectedValue == null ? 1 : 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                fillColor: themeState.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              value: selectedValue,
                              style: TextStyle(
                                color: themeState.isDarkMode ? Colors.white : Colors.black,
                              ),
                              dropdownColor: themeState.isDarkMode ? Colors.grey[800] : Colors.white,
                              hint: Text(
                                "Chọn",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: themeState.isDarkMode ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: themeState.isDarkMode ? Colors.white : Colors.black,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                              items:
                                  dropdownItems.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}