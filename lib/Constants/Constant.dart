// ignore: file_names
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const Kwhite = Colors.white;

const kgrey = Color(0XFF3B3B3B);
// ignore: constant_identifier_names
const KPrimaryColor = Color(0xFFE9A74e);
const kbtnColor = Color(0XFFFFCB74);
double kraduis = 40;
const kBlack = Colors.black;
const kFormColor = Color(0XFFFFD38A);
const kBoxColor = Color(0XFF92A7BCCC);
const sizebox10 = SizedBox(height: 10);
const sizebox20 = SizedBox(height: 20);
const sizebox30 = SizedBox(height: 30);
Size calculateScreenSize(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Size(screenWidth, screenHeight);
}
