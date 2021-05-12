import 'package:flutter/material.dart';

class MinContainer extends StatelessWidget {
  ///creates a widget
  final double? height;
  final AlignmentGeometry? alignment;
  final double? width;
  final Color? color;
  final double radius;
  final List<double>? unevenRadius;
  final double borderWidth;
  final Color borderColor;
  final bool? circular;
  final Widget? child;
  final margin;
  final padding;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  MinContainer({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.radius = 0,
    this.child,
    this.unevenRadius,
    this.circular,
    this.margin,
    this.alignment,
    this.padding,
    this.borderWidth = 0,
    this.boxShadow,
    this.gradient,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius? borderRadius;
    List<double> uneven = unevenRadius ?? [];

    if (unevenRadius == null) {
      borderRadius = circular == null
          ? BorderRadius.circular(radius)
          : BorderRadius.all(Radius.elliptical(radius, radius));
    } else {
      if (uneven.length == 4) {
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(uneven[0]),
          topRight: Radius.circular(uneven[1]),
          bottomLeft: Radius.circular(uneven[2]),
          bottomRight: Radius.circular(uneven[3]),
        );
      }
    }

    return Container(
      margin: margin,
      height: height,
      width: width,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(width: borderWidth, color: borderColor),
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
