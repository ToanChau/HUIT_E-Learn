// ignore_for_file: public_member_api_docs, sort_constructors_first
class Test {
  String maDe;
  String tenDe;
  DateTime ngayTao;
  int soLuongCauHoi;
  String maNguoiDung;
  String maMon;
  List<String> maCauHoi;
  Test({
    required this.maDe,
    required this.tenDe,
    required this.ngayTao,
    required this.soLuongCauHoi,
    required this.maNguoiDung,
    required this.maMon,
    required this.maCauHoi,
  });
}

class Question {
  String maCauHoi;
  String noiDungCauHoi;
  String phanLoai;
  String maMH;
  List<Answer> cauTraLoi;
  Question({
    required this.maCauHoi,
    required this.noiDungCauHoi,
    required this.phanLoai,
    required this.maMH,
    required this.cauTraLoi,
  });
}

class Answer {
  String noiDung;
  bool isCorrect;
  Answer({required this.noiDung, required this.isCorrect});
}
