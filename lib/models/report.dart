// ignore_for_file: public_member_api_docs, sort_constructors_first
class Report {
  String MaBaoCao;
  String MaNguoiDung;
  String MaTaiLieu;
  String NoiDung;
  String TrangThai;
  Report({
    required this.MaBaoCao,
    required this.MaNguoiDung,
    required this.MaTaiLieu,
    required this.NoiDung,
    required this.TrangThai,
  });

  Map<String, dynamic> toJson() {
    return {
      'MaBaoCao': MaBaoCao,
      'MaNguoiDung': MaNguoiDung,
      'MaTaiLieu': MaTaiLieu,
      'NoiDung': NoiDung,
      'TrangThai': TrangThai,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      MaBaoCao: json['MaBaoCao'] ?? '',
      MaNguoiDung: json['MaNguoiDung'] ?? '',
      MaTaiLieu: json['MaTaiLieu'] ?? '',
      NoiDung: json['NoiDung'] ?? '',
      TrangThai: json['TrangThai'] ?? 'Chờ duyệt',
    );
  }
}
