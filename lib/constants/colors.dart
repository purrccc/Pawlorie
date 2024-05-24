import 'package:flutter/widgets.dart';

class AppColor {
  AppColor._();
  static const Color darkBlue =Color.fromARGB(255, 22, 21, 86);
  static const Color yellowGold = Color.fromARGB(255, 255, 175, 37);
  static const Color blue = Color.fromARGB(255, 31, 104, 239);
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
     ],
   );
}