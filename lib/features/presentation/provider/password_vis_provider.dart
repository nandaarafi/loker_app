import 'package:flutter/material.dart';

class PasswordVisibilityProvider with ChangeNotifier {
  bool _obscureText = false;

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}