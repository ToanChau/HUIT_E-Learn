class Document {
  String maTaiLieu;
  String tenTaiLieu;
  DateTime ngayDang;
  String nguoiDang;
  String moTa;
  int kichThuoc;
  String loai;
  String trangThai;
  int? luotTaiVe;
  int? luotThich;
  String maMH;
  String uRL;
  List<String>? previewImages;
  Document({
    required this.maTaiLieu,
    required this.tenTaiLieu,
    required this.ngayDang,
    required this.nguoiDang,
    required this.moTa,
    required this.kichThuoc,
    required this.loai,
    required this.trangThai,
     this.luotTaiVe,
     this.luotThich,
    required this.maMH,
    required this.uRL,
    this.previewImages,
  });

  

  
}
