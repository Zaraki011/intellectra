import 'package:flutter/material.dart';

Widget buildMenuItem(String title, Function onTap) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: (){
        onTap();
      },
    ),
  );
}

// onPressed => VoidCallback : Void input
// onTap => GestureTapCallback : function avec return 