import 'package:flutter/material.dart';

Widget OThongTin({
  required String title,
  required String subtitle,
  required Image logoWidget,
  required Function() onContainerTap,
  required Function() onDetailTap,
}) {
  return GestureDetector(
    onTap: onContainerTap,  
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: FittedBox(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: logoWidget.image, fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
            trailing: SizedBox(width: 80), 
          ),
        
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: (){ 
                onDetailTap();
              },
          
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "xem chi tiết",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}