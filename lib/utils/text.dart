import 'package:flutter/material.dart';
import 'package:image_cloud_server/utils/design.dart';

class TextDesign {
  static TextStyle normal({
    double size = 14,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color ?? Design.lightText,
    );
  }

  static TextStyle textField({
    double size = 15,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Design.lightText,
    );
  }

  static TextStyle bigBold({
    double size = 35,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Design.darkText,
    );
  }
}
