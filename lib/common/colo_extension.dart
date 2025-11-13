import 'package:flutter/material.dart';



class TColor{
  static Color get primaryColor1 => const Color (0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondaryColor1 => const Color(0xffc58bf2);
  static Color get secondaryColor2 => const Color (0xffeea4ce);

  static Color get white => const Color(0xffffffff);
  static Color get black => const Color(0xff1d1617);
  static Color get grey => const Color(0xff786f72);

  static List<Color> get primaryGrad =>[primaryColor1,primaryColor2];
  static List<Color> get secondaryGrad => [secondaryColor1,secondaryColor2];

}