// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String maNguoiDung;
  final String eMail;
  final String sDT;
  final String? tenNguoiDung;
  final String? anhDaiDien;
  final String matKhau;
  final DateTime ngaySinh;
  final String gioiTinh;

  const UserModel({
    required this.maNguoiDung,
    required this.eMail,
    required this.sDT,
    this.tenNguoiDung,
    this.anhDaiDien,
    required this.matKhau,
    required this.ngaySinh,
    required this.gioiTinh,
  });

  UserModel copyWith({
    String? maNguoiDung,
    String? eMail,
    String? sDT,
    String? tenNguoiDung,
    String? anhDaiDien,
    String? matKhau,
    DateTime? ngaySinh,
    String? gioiTinh
  }) {
    return UserModel(
      maNguoiDung: maNguoiDung ?? this.maNguoiDung,
      eMail: eMail ?? this.eMail,
      sDT: sDT ?? this.sDT,
      tenNguoiDung: tenNguoiDung ?? this.tenNguoiDung,
      anhDaiDien: anhDaiDien ?? this.anhDaiDien,
      matKhau: matKhau ?? this.matKhau,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      gioiTinh: gioiTinh?? this.gioiTinh,
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'MaNguoiDung': maNguoiDung,
      'EMail': eMail,
      'Sdt': sDT,
      'TenNguoiDung': tenNguoiDung,
      'AnhDaiDien': anhDaiDien,
      'MatKhau': matKhau,
      'NgaySinh': ngaySinh.toIso8601String(),
      'GioiTinh': gioiTinh
    };
  }

 factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      maNguoiDung: map['MaNguoiDung'] as String,
      eMail: map['EMail'] as String,
      sDT: map['Sdt'] as String,
      tenNguoiDung: map['TenNguoiDung'] as String?,
      anhDaiDien: map['AnhDaiDien'] as String?,
      matKhau: map['MatKhau'] as String,
      ngaySinh: DateTime.parse(map['NgaySinh'] as String),
      gioiTinh: map['GioiTinh']
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        maNguoiDung,
        eMail,
        sDT,
        tenNguoiDung,
        anhDaiDien,
        matKhau,
        ngaySinh,
        gioiTinh,
      ];

  
}
