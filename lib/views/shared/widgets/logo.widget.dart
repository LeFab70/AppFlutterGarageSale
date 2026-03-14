import 'package:flutter/material.dart';

Widget logoWidget(String imageName) {
  return CircleAvatar(
    radius: 150,
    backgroundImage: AssetImage(imageName),
    backgroundColor: Colors.transparent,
  );
}