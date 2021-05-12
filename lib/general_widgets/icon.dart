import 'package:flutter/material.dart';

enum AppIconSize {
  big,
  small,
}

class AppIcon extends StatelessWidget {
  final AppIconSize iconSize;

  const AppIcon({Key? key, required this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconName = 'image_cloud_icon';
    if (iconSize == AppIconSize.small) {
      iconName = 'image_cloud_small';
    }

    return Container(
      child: Image.asset('assets/icon/$iconName.png'),
    );
  }
}
