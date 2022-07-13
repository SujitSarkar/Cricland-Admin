import 'package:cricland_admin/constants/static_colors.dart';
import 'package:flutter/material.dart';

class StaticVar{
  //App Theme
  static final ThemeData themeData = ThemeData(
      primarySwatch: const MaterialColor(0xff03508B, StaticColor.primaryColorMap),
      scaffoldBackgroundColor: StaticColor.appBg,
      appBarTheme: const AppBarTheme(
          backgroundColor: StaticColor.primaryColor,
          titleTextStyle: TextStyle(
              color: StaticColor.whiteColor, fontWeight: FontWeight.bold),
          elevation: 0.0),
      canvasColor: Colors.transparent,
      bottomSheetTheme: const BottomSheetThemeData(modalBackgroundColor: Colors.transparent),
      fontFamily: 'openSans',
      textTheme: const TextTheme(
          headline1: TextStyle(fontFamily: "openSans"),
          headline2: TextStyle(fontFamily: "openSans"),
          headline3: TextStyle(fontFamily: "openSans"),
          headline4: TextStyle(fontFamily: "openSans"),
          headline5: TextStyle(fontFamily: "openSans"),
          headline6: TextStyle(fontFamily: "openSans"),
          subtitle1: TextStyle(fontFamily: "openSans"),
          subtitle2: TextStyle(fontFamily: "openSans"),
          bodyText1: TextStyle(fontFamily: "openSans"),
          bodyText2: TextStyle(fontFamily: "openSans"),
          caption: TextStyle(fontFamily: "openSans"),
          button: TextStyle(fontFamily: "openSans"),
          overline: TextStyle(fontFamily: "openSans")));
}