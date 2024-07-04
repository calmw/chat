import 'package:flutter/material.dart';

class CheckLogin {
  check(int code, BuildContext context) {
    if (code == 1001) {
      Navigator.pushNamed(context, '/login');
    }
  }
}