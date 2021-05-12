import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cloud_server/models/ImageModel.dart';
import 'package:image_cloud_server/providers/auth_provider.dart';

class MediaProvider extends ChangeNotifier {
  String baseUrl = "192.168.43.90:3000";
  String authToken = '';
  Map<String, String> headers = {};

  Map<String, List<ImageModel>> imageMap = {};

  LoadState imageMapLoadState = LoadState.idle;
  // LoadState immageUploadState = LoadState.idle;

  setToken(String token) {
    authToken = 'Bearer ' + token;
    headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': authToken
    };
  }

  ///Get all previous images uploaded and order it respectively
  Future<bool> getAllImages() async {
    //return immediatly if already loading
    //NB for reload the state would need to be set to idle
    if (imageMapLoadState != LoadState.idle) {
      return false;
    }

    bool sucess = true;
    imageMapLoadState = LoadState.loading;

    try {
      var url = Uri.http(baseUrl, '/get-all-images');
      print(url.toString());

      var response = await http.get(url, headers: headers);
      Map body = jsonDecode(response.body);
      print(body);

      if (response.statusCode != 200) {
        throw ('An Error Occured');
      }

      //receive data from the body of request
      List imagesData = body['imagesData'];
      for (int i = 0; i < imagesData.length; i++) {
        //convert array to an object for easy refernce
        ImageModel im = ImageModel.fromMap(imagesData[i]);

        //order images by date posted
        imageMap[im.date] ??= [];
        imageMap[im.date]?.add(im);
      }

      imageMapLoadState = LoadState.success;
      notifyListeners();
    } catch (e) {
      print(e);

      imageMapLoadState = LoadState.failed;
      notifyListeners();
      sucess = false;
    }

    return sucess;
  }

  Future<bool> uploadImages(String pathName) async {
    bool sucess = true;
    try {
      var url = Uri.http(baseUrl, '/upload');
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll(headers);
      var multFile = await http.MultipartFile.fromPath('image', pathName,
          filename: pathName.split('/').last);
      request.files.add(multFile);

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 200) {
        throw ('An Error Occured');
      }

      Map body = jsonDecode(response.body);
      Map data = body['data'];

      ImageModel im = ImageModel.fromMap(data);
      imageMap[im.date] ??= [];
      imageMap[im.date]?.add(im);

      notifyListeners();
    } catch (e) {
      print(e);
      sucess = false;
    }

    return sucess;
  }

  List<String> getDates() {
    return imageMap.keys.toList();
  }

  List<ImageModel>? getImagesFromDate(String date) {
    return imageMap[date];
  }
}
