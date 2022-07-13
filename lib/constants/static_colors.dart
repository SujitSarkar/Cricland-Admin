import 'package:flutter/material.dart';

class StaticColor {

  static const Color primaryColor = Color(0xff03508B);
  static final Color textColor = Colors.grey.shade900;
  static const Color appBg = Color(0xffF3F6F3);
  static const Color cardHeaderBg = Color(0xffE5ECEA);
  static const Color goldenColor = Color(0xffA77A12);
  static const Color whiteColor = Colors.white;
  static final Color hintColor = Colors.grey.shade600;
  static final Color sideBarColor = Colors.blueGrey.shade50;
  static final Color hoverColor = Colors.blueGrey.shade100;

  static const Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(3, 80, 139, .1),
    100: Color.fromRGBO(3, 80, 139, .2),
    200: Color.fromRGBO(3, 80, 139, .3),
    300: Color.fromRGBO(3, 80, 139, .4),
    400: Color.fromRGBO(3, 80, 139, .5),
    500: Color.fromRGBO(3, 80, 139, .6),
    600: Color.fromRGBO(3, 80, 139, .7),
    700: Color.fromRGBO(3, 80, 139, .8),
    800: Color.fromRGBO(3, 80, 139, .9),
    900: Color.fromRGBO(3, 80, 139, 1),
  };
}
