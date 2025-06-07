import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/library/library_bloc.dart';
import 'package:huit_elearn/viewModels/library/library_event.dart';
import 'package:huit_elearn/viewModels/library/library_state.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_bloc.dart';
import 'package:huit_elearn/views/screens/main_screens/pdfview_Screen.dart';
import 'package:huit_elearn/views/widgets/docitem.dart';
import 'package:huit_elearn/views/widgets/doclistitem.dart';
import 'package:huit_elearn/views/widgets/docoptionbottomsheet.dart';
import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/docsortbottomsheet.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';
import 'package:huit_elearn/views/widgets/togglecustom.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LibraryAcceptdoc extends StatefulWidget {
  const LibraryAcceptdoc({super.key});

  @override
  State<LibraryAcceptdoc> createState() => _LibraryAcceptdocState();
}

class _LibraryAcceptdocState extends State<LibraryAcceptdoc> {
  bool isListView = true;
  bool isSearching = false;
  final FocusNode _focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.nameAscending;
  List<Document> _sortedDocuments = [];
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _searchController.text.isEmpty) {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return DrawerCustom(user: state.user);
          }
          return DrawerCustom(
            user: UserModel(
              maNguoiDung: "anonymous_id",
              eMail: "exemple@gmail.com",
              sDT: "09090909",
              anhDaiDien: "Anonymous",
              gioiTinh: "Nam",
              matKhau: "",
              ngaySinh: DateTime.now(),
              tenNguoiDung: "Anonymous",
            ),
          );
        },
      ),
      body: BlocListener<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if (state is LibraryChoseDocState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfviewScreen(filePath: state.filePath),
              ),
            );
          }
        },
        child: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppbarMainCustom(
                  size: size,
                  searchBar: false,
                  menuIcon: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Icon(Icons.navigate_before_outlined),
                              ),
                            ),
                            SizedBox(width: 20),
                            isSearching
                                ? Expanded(
                                  flex: 10,
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: _searchController,
                                    onChanged: (value) {
                                      _sortedDocuments = [];
                                      context.read<LibraryBloc>().add(
                                        LibrarySearchingEvent(query: value),
                                      );
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            isSearching = !isSearching;
                                            if (!isSearching) {
                                              _searchController.clear();

                                              final currentState =
                                                  context
                                                      .read<LibraryBloc>()
                                                      .state;

                                              if (currentState
                                                  is LibrarySearchState) {
                                                if (currentState.originalState
                                                    is LibraryChoseAcceptedState) {
                                                  context.read<LibraryBloc>().add(
                                                    LibraryChoseAcceptedDocEvent(
                                                      maNguoiDung:
                                                          context
                                                                      .read<
                                                                        AuthBloc
                                                                      >()
                                                                      .state
                                                                  is AuthAuthenticated
                                                              ? (context
                                                                          .read<
                                                                            AuthBloc
                                                                          >()
                                                                          .state
                                                                      as AuthAuthenticated)
                                                                  .user
                                                                  .maNguoiDung
                                                              : "anonymous_id",
                                                    ),
                                                  );
                                                } else if (currentState
                                                        .originalState
                                                    is LibraryChoseUnAcceptedState) {
                                                  context.read<LibraryBloc>().add(
                                                    LibraryChoseUnAcceptedDocEvent(
                                                      maNguoiDung:
                                                          context
                                                                      .read<
                                                                        AuthBloc
                                                                      >()
                                                                      .state
                                                                  is AuthAuthenticated
                                                              ? (context
                                                                          .read<
                                                                            AuthBloc
                                                                          >()
                                                                          .state
                                                                      as AuthAuthenticated)
                                                                  .user
                                                                  .maNguoiDung
                                                              : "anonymous_id",
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                : Expanded(
                                  flex: 10,
                                  child: Text(
                                    _getTitle(state),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                            isSearching
                                ? SizedBox()
                                : IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      isSearching = !isSearching;
                                    });
                                  },
                                ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showSortBottomSheet(context, state);
                                },
                                child: Wrap(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        _getSortLabel(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_outlined),
                                  ],
                                ),
                              ),
                              Togglecustom(
                                isList: isListView,
                                onToggle: (bool value) {
                                  setState(() {
                                    isListView = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildContent(state, context),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getTitle(LibraryState state) {
    if (state is LibraryChoseAcceptedState) {
      return "Đã phê duyệt";
    } else if (state is LibraryChoseUnAcceptedState) {
      return "Đang chờ duyệt";
    }
    return "Tài liệu";
  }

  String _getSortLabel() {
    switch (_currentSortOption) {
      case SortOption.nameAscending:
        return "Sắp xếp theo tên (A đến Z)";
      case SortOption.nameDescending:
        return "Sắp xếp theo tên (Z đến A)";
      case SortOption.dateOldest:
        return "Sắp xếp theo ngày đăng (cũ nhất)";
      case SortOption.dateNewest:
        return "Sắp xếp theo ngày đăng (mới nhất)";
      case SortOption.sizeLargest:
        return "Sắp xếp theo kích thước (lớn nhất)";
      case SortOption.sizeSmallest:
        return "Sắp xếp theo kích thước (nhỏ nhất)";
    }
  }

  void _onTapOnDoc(Document document) async {
    final url = document.uRL;
    String fileName = url.split('/').last;
    final isPdf = document.loai.toLowerCase().contains("pdf");
    if (fileName.contains('?')) {
      fileName = fileName.split('?').first;
}
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    color: Color.fromARGB(255, 44, 62, 80),
                  ),
                  SizedBox(height: 16),
                  Text("Đang tải..."),
                ],
              ),
            ),
          ),
    );
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    
    await file.writeAsBytes(bytes);
    if (!isPdf) {
      Navigator.pop(context);
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Mở tệp không thành công')));
      }
      return;
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfviewScreen(filePath: file)),
      );
    }
  }

  void _showSortBottomSheet(BuildContext context, LibraryState state) {
    List<Document> documents = [];

    if (state is LibraryChoseAcceptedState) {
      documents = state.documents;
    } else if (state is LibraryChoseUnAcceptedState) {
      documents = state.documents;
    } else if (state is LibrarySearchState) {
      documents = state.documents;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DocumentSortBottomSheet(
            documents: documents,
            onSort: (sortedDocs, option) {
              setState(() {
                _sortedDocuments = sortedDocs;
                _currentSortOption = option;
              });
            },
          ),
    );
  }

  Widget _buildContent(LibraryState state, BuildContext context) {
    List<Document> docs = [];

    if (state is LibrarySearchState) {
      docs = _sortedDocuments.isNotEmpty ? _sortedDocuments : state.documents;
    } else if (state is LibraryChoseAcceptedState) {
      docs = _sortedDocuments.isNotEmpty ? _sortedDocuments : state.documents;
    } else if (state is LibraryChoseUnAcceptedState) {
      docs = _sortedDocuments.isNotEmpty ? _sortedDocuments : state.documents;
    } else {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return isListView
        ? _buildListContent(docs, context)
        : _buildGridContent(docs);
  }

  Widget _buildListContent(List<Document> documents, BuildContext context) {
    if (documents.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text("Không có tài liệu nào")),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return DocListItem(
          document: documents[index],
          onContainerTap: () => _onTapOnDoc(documents[index]),
          onDetailTap: () {
            showBottomSheet(
              context: context,
              builder:
                  (context) => BlocProvider(
                    create: (_) => LibrarydownloadBloc(),
                    child: Docoptionbottomsheet(document: documents[index]),
                  ),
            );
          },
        );
      }, childCount: documents.length),
    );
  }

  Widget _buildGridContent(List<Document> documents) {
    if (documents.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text("Không có tài liệu nào")),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return DocItem(
            document: documents[index],
            onContainerTap: () => _onTapOnDoc(documents[index]),
            onDetailTap: () {
              showBottomSheet(
                context: context,
                builder:
                    (context) =>
                        Docoptionbottomsheet(document: documents[index]),
              );
            },
          );
        }, childCount: documents.length),
      ),
    );
  }
}
