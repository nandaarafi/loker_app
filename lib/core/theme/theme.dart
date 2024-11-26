import 'package:flutter/material.dart';
import 'package:lokerapps/core/theme/text_theme.dart';

import '../constants/colors.dart';

class LTheme {
  LTheme._();
  static ThemeData lightTheme = ThemeData(
    primaryColor: LColors.white,
    canvasColor: Color(0xffccf2f6),
    scaffoldBackgroundColor: Colors.white,
    dialogTheme: DialogTheme(backgroundColor: Colors.white),
    useMaterial3: true,
    fontFamily: 'Poppins',
    dialogBackgroundColor: LColors.white,
    brightness: Brightness.light,
    textTheme: LTextTheme.lightTextTheme,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent,

    // colorScheme: ColorScheme.fromSeed(seedColor: LColors.secondaryBackground,
      // primary: Colors.blue
    ),
  );
  // static ThemeData lightTheme = ThemeData(
  //   dialogTheme: DialogTheme(backgroundColor: Colors.white),
  //   useMaterial3: true,
  //   fontFamily: 'Poppins',
  //   brightness: Brightness.light,
  //   primaryColor: Colors.white,
  //   scaffoldBackgroundColor: Colors.white,
  //   textTheme: LTextTheme.lightTextTheme,
  //   colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff32a88f),
  //     // primary: Colors.blue
  //   ),
  //
  // );
}