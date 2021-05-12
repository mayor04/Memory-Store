import 'dart:io';

import 'package:flutter/material.dart';

class PictureDisplayScreen extends StatefulWidget {
  String? imagePath;

  PictureDisplayScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PictureDisplayScreenState createState() => _PictureDisplayScreenState();
}

class _PictureDisplayScreenState extends State<PictureDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: Image.file(File(widget.imagePath ?? '')),
      ),
    );
  }
}
