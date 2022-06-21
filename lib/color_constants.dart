import 'package:flutter/material.dart';

class ColorConstants {
  static Color color1 = Colors.black;
  static Color color2 = Colors.white;
  static Color color3 = Colors.amber[700];
  static Color text1Dark = Colors.grey[900];
  static Color text2 = Colors.grey[600];
  static Color text3 = Colors.grey[600];

  static Color text4Lighest = Colors.grey[300];

  static List<Color> colors = [
    Color.fromRGBO(255, 160, 0, 1),
    Color.fromRGBO(241, 143, 1, 1),
    Color.fromRGBO(46, 80, 119, 1),
    Color.fromRGBO(68, 13, 15, 1),
    Color.fromRGBO(25, 23, 22, 1),
    Color.fromRGBO(216, 203, 199, 1),
    Color.fromRGBO(168, 8, 116, 1),
    Color.fromRGBO(230, 211, 163, 1),
    Color.fromRGBO(119, 98, 92, 1),
    Color.fromRGBO(50, 55, 59, 1),
    Color.fromRGBO(244, 184, 96, 1),
    Color.fromRGBO(74, 88, 89, 1),
    Color.fromRGBO(18, 53, 91, 1),
    Color.fromRGBO(215, 38, 56, 1),
    Color.fromRGBO(66, 0, 57, 1),
    Color.fromRGBO(78, 205, 196, 1),
    Color.fromRGBO(153, 247, 171, 1),
    Color.fromRGBO(41, 47, 54, 1),
    Color.fromRGBO(46, 192, 249, 1),
    Color.fromRGBO(103, 170, 249, 1),
    Color.fromRGBO(46, 64, 87, 1),
    Color.fromRGBO(153, 194, 77, 1),
    Color.fromRGBO(46, 47, 47, 1),
    Color.fromRGBO(34, 9, 1, 1),
    Color.fromRGBO(148, 27, 12, 1),
    Color.fromRGBO(2, 1, 10, 1),
    Color.fromRGBO(4, 5, 46, 1),
    Color.fromRGBO(99, 212, 113, 1),
    Color.fromRGBO(8, 126, 139, 1),
    Color.fromRGBO(255, 252, 247, 1),
    Color.fromRGBO(34, 0, 124, 1),
    Color.fromRGBO(139, 30, 63, 1),
    Color.fromRGBO(20, 1, 82, 1),
    Color.fromRGBO(102, 78, 76, 1),
    Color.fromRGBO(240, 226, 163, 1),
    Color.fromRGBO(211, 135, 171, 1),
    Color.fromRGBO(232, 153, 220, 1),
    Color.fromRGBO(149, 215, 174, 1),
    Color.fromRGBO(235, 235, 211, 1),
    Color.fromRGBO(10, 135, 84, 1),
    Color.fromRGBO(204, 41, 54, 1),
    Color.fromRGBO(156, 255, 217, 1),
  ];

  static void setTheme(Color color, {bool dark}) {
    if (dark != null) {
      color1 = dark ? Colors.black : Colors.white;
      color2 = dark ? Colors.white : Colors.black;
      text1Dark = dark ? Colors.black : Colors.white;
      text2 = dark ? Colors.grey[900] : Colors.grey[400];
      text3 = dark ? Colors.grey[400] : Colors.grey[900];
      text4Lighest = dark ? Colors.white : Colors.black;
    }

    color3 = color;
  }

  static List<Color> getColors() {
    return colors;
  }
}
