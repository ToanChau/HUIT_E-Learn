// import 'package:flutter/material.dart';

// class UploadScreenSubmit extends StatelessWidget {
//   final String khoa;
//   final String mon;
//   final String tenTaiLieu;
//   final String moTa;
//   UploadScreenSubmit({
//     super.key,
//     required this.khoa,
//     required this.mon,
//     required this.tenTaiLieu,
//     required this.moTa,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Center(
//           child: Text(
//             "Mô tả2",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//         ),
//         Padding(padding: const EdgeInsets.all(8.0), child: Text("Khoa")),
//         SizedBox(
//           height: 50,
//           child: TextField(
//             readOnly: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         Padding(padding: const EdgeInsets.all(8.0), child: Text("Môn")),
//         SizedBox(
//           height: 50,
//           child: TextField(
//             readOnly: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text("Tên tài liệu"),
//         ),
//         SizedBox(
//           height: 50,
//           child: TextField(
//             readOnly: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         Padding(padding: const EdgeInsets.all(8.0), child: Text("Mô tả")),
//         SizedBox(
//           height: 50,
//           child: TextField(
//             readOnly: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
