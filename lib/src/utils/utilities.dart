import 'package:flutter/material.dart';

class Utilities {
  static widthScreen(context) {
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    return width;
  }
}