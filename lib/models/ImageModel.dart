import 'package:flutter/material.dart';

class ImageModel {
  String url;
  String date;

  ImageModel({
    required this.url,
    required this.date,
  });

  @override
  String toString() {
    return '$url=$date';
  }

  static ImageModel fromMap(Map images) {
    var url = Uri.http('192.168.43.90:3000', images['url']);
    var stamp = images['date'];

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(stamp);
    String date = '${dateTime.day} - ${dateTime.month} - ${dateTime.year}';

    return ImageModel(url: url.toString(), date: date);
  }
}
