import 'package:flutter/material.dart';
import 'package:huit_elearn/models/documents.dart';

enum SortOption {
  nameAscending,
  nameDescending,
  dateOldest,
  dateNewest,
  sizeLargest,
  sizeSmallest,
}

class DocumentSortBottomSheet extends StatelessWidget {
  final List<Document> documents;
  final Function(List<Document>, SortOption) onSort;
  
  const DocumentSortBottomSheet({
    Key? key,
    required this.documents,
    required this.onSort,
  }) : super(key: key);

  void _sortDocuments(BuildContext context, SortOption option) {
    List<Document> sortedDocs = List.from(documents);
    
    switch (option) {
      case SortOption.nameAscending:
        sortedDocs.sort((a, b) => a.maTaiLieu.compareTo(b.maTaiLieu));
        break;
      case SortOption.nameDescending:
        sortedDocs.sort((a, b) => b.maTaiLieu.compareTo(a.maTaiLieu));
        break;
      case SortOption.dateOldest:
        sortedDocs.sort((a, b) => a.ngayDang.compareTo(b.ngayDang));
        break;
      case SortOption.dateNewest:
        sortedDocs.sort((a, b) => b.ngayDang.compareTo(a.ngayDang));
        break;
      case SortOption.sizeLargest:
        sortedDocs.sort((a, b) => b.kichThuoc.compareTo(a.kichThuoc));
        break;
      case SortOption.sizeSmallest:
        sortedDocs.sort((a, b) => a.kichThuoc.compareTo(b.kichThuoc));
        break;
    }
    
    onSort(sortedDocs, option);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortOption(
            context,
            icon: Icons.arrow_upward,
            text: "Sắp xếp theo tên (A đến Z)",
            option: SortOption.nameAscending,
          ),
          _buildSortOption(
            context,
            icon: Icons.arrow_downward,
            text: "Sắp xếp theo tên (Z đến A)",
            option: SortOption.nameDescending,
          ),
          _buildSortOption(
            context,
            icon: Icons.access_time,
            text: "Sắp xếp theo ngày đăng (cũ nhất)",
            option: SortOption.dateOldest,
          ),
          _buildSortOption(
            context,
            icon: Icons.access_time,
            text: "Sắp xếp theo ngày đăng (mới nhất)",
            option: SortOption.dateNewest,
          ),
          _buildSortOption(
            context,
            icon: Icons.aspect_ratio,
            text: "Sắp xếp theo kích thước (lớn nhất)",
            option: SortOption.sizeLargest,
          ),
          _buildSortOption(
            context,
            icon: Icons.aspect_ratio,
            text: "Sắp xếp theo kích thước (nhỏ nhất)",
            option: SortOption.sizeSmallest,
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required SortOption option,
  }) {
    return InkWell(
      onTap: () => _sortDocuments(context, option),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 24),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}