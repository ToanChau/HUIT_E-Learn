import 'package:flutter/material.dart';
import 'package:huit_elearn/models/lecturer.dart';

class LecturerCard extends StatefulWidget {
  final Lecturer lecturer;

  const LecturerCard({super.key, required this.lecturer});

  @override
  State<LecturerCard> createState() => _LecturerCardState();
}

class _LecturerCardState extends State<LecturerCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, 
      height: 360, 
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                      widget.lecturer.hinhAnh,
                      width: 280,
                      height: 360,
                      fit: BoxFit.cover,
                    ) ??
                    Image.asset(
                      "assets/images/user.jpg",
                      width: 280,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), 
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lecturer.tenGV,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.lecturer.sDT,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      widget.lecturer.eMail,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.lecturer.chucVu,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
