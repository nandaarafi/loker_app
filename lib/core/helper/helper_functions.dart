import 'package:flutter/material.dart';

class LHelperFunctions {
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double keyboardVisibility(BuildContext context) {
    return MediaQuery
        .of(context)
        .viewInsets.bottom;
  }
  static dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

}