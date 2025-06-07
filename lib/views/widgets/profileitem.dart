import 'package:flutter/material.dart';

Widget ProfileItem(IconData icon, String title, String subTitle,VoidCallback ontap) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Container(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
        subtitle: Text(subTitle,maxLines: 1,style: TextStyle(fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: ()=>ontap(),
        
      ),
      decoration: BoxDecoration(
       border: Border.all(width: 0.2,color: Colors.grey,),
       borderRadius: BorderRadius.all(Radius.circular(8)) 
      ),
    ),
   );
}
