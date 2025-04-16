import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/library/library_bloc.dart';
import 'package:huit_elearn/viewModels/library/library_state.dart';
import 'package:huit_elearn/views/widgets/docitem.dart';
import 'package:huit_elearn/views/widgets/doclistitem.dart';
import 'package:huit_elearn/views/widgets/drawer.dart';
import 'package:huit_elearn/views/widgets/docsortbottomsheet.dart';
import 'package:huit_elearn/views/widgets/sliverappbarmaincustom.dart';
import 'package:huit_elearn/views/widgets/togglecustom.dart';

class LibraryAcceptdoc extends StatefulWidget {
  const LibraryAcceptdoc({super.key});

  @override
  State<LibraryAcceptdoc> createState() => _LibraryAcceptdocState();
}

class _LibraryAcceptdocState extends State<LibraryAcceptdoc> {
  bool isListView = true;
  SortOption _currentSortOption = SortOption.nameAscending;
  List<Document> _sortedDocuments = [];
 
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
              anhDaiDien:  "Anonymous",
              gioiTinh: "Nam",
              matKhau: "",
              ngaySinh: DateTime.now(),
              tenNguoiDung: "Anonymous"
            ),
          );
        },
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
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
                          Wrap(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Icon(Icons.navigate_before_outlined),
                              ),
                              SizedBox(width: 20),
                              Text(
                                _getTitle(state),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                             
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.search),
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
                                        color: Colors.black,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_outlined)
                                ]
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
              _buildContent(state),
            ],
          );
        },
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
      default:
        return "Sắp xếp";
    }
  }

  void _showSortBottomSheet(BuildContext context, LibraryState state) {
    List<Document> documents = [];
    
    if (state is LibraryChoseAcceptedState) {
      documents = state.documents;
    } else if (state is LibraryChoseUnAcceptedState) {
      documents = state.documents;
    }
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DocumentSortBottomSheet(
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

  Widget _buildContent(LibraryState state) {
    if (state is LibraryChoseAcceptedState) {
      final docs = _sortedDocuments.isNotEmpty ? _sortedDocuments : state.documents;
      return isListView
          ? _buildListContent(docs)
          : _buildGridContent(docs);
    } else if (state is LibraryChoseUnAcceptedState) {
      final docs = _sortedDocuments.isNotEmpty ? _sortedDocuments : state.documents;
      return isListView
          ? _buildListContent(docs)
          : _buildGridContent(docs);
    } else {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _buildListContent(List<Document> documents) {
    if (documents.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text("Không có tài liệu nào"),
        ),
      );
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return DocListItem(document: documents[index]);
      }, childCount: documents.length),
    );
  }

  Widget _buildGridContent(List<Document> documents) {
    if (documents.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text("Không có tài liệu nào"),
        ),
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
          return DocItem(document: documents[index]);
        }, childCount: documents.length),
      ),
    );
  }
}