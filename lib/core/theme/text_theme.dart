import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LTextTheme {
  LTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle().copyWith(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle().copyWith(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black),
    titleLarge: TextStyle().copyWith(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
    titleMedium: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
    titleSmall: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge: TextStyle().copyWith(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
    bodyMedium: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
    bodySmall: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: LColors.black),
    labelLarge: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black),
    labelMedium: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: LColors.black),
    labelSmall: TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w400, color: Color(0xFFA7B296)),
  );
}
