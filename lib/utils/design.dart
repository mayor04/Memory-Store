import 'package:flutter/material.dart';

class Design {
  static Color lightText = Color(0xFFACACAC);
  static Color darkText = Color(0xFF646464);
  static Color kRed = Color(0xFFA24646);
  static Color kYellow = Color(0xFFE1D250);
  static Color textField = Color(0xFFE8E8E8);
  static Color tFBorder = Color(0xFF707070);
}

class FieldBorder {
  static InputBorder border({double? radius, Color? color, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? 4),
      borderSide: BorderSide(
        color: color ?? Design.tFBorder,
        width: width ?? 0.7,
      ),
    );
  }
}
