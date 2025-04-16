// ignore_for_file: public_member_api_docs, sort_constructors_first
class Lecturer {
  final String maGV;
  final String tenGV;
  final String hinhAnh;
  final String eMail;
  final String sDT;
  final int luotThich;
  final String chucVu;
  Lecturer({
    required this.maGV,
    required this.tenGV,
    required this.hinhAnh,
    required this.eMail,
    required this.sDT,
    required this.luotThich,
    required this.chucVu,
  });

  factory Lecturer.fromMap(Map<String, dynamic> map) {
    return Lecturer(
      maGV: map['MaGV']??"",
      tenGV: map['TenGV']??"",
      hinhAnh: map['HinhAnh']??"",
      eMail: map['Email']??"",
      sDT: map['SDT']??"",
      luotThich: map['LuotThich']??0,
      chucVu: map['ChucVu']??"",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'MaGV': maGV,
      'TenGV': tenGV,
      'HinhAnh': hinhAnh,
      'Email': eMail,
      'SDT': sDT,
      'LuotThich': luotThich,
      'ChucVu': chucVu,
    };
  }
}
