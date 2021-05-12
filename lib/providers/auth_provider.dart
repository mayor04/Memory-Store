import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoadState { idle, loading, failed, success, complete }

class AuthProvider extends ChangeNotifier {
  LoadState loginState = LoadState.idle;
  String baseUrl = "192.168.43.90:3000";
  String authToken = '';

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _logOrReg(
      path: 'login',
      bod: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return _logOrReg(
      path: 'register',
      bod: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
  }

  Future<bool> _logOrReg({
    required String path,
    required var bod,
  }) async {
    bool sucess = true;
    try {
      //send register request
      var url = Uri.http(baseUrl, 'auth/$path');
      const headers = {'Content-Type': 'application/x-www-form-urlencoded'};

      var response = await http.post(url, headers: headers, body: bod);

      Map body = jsonDecode(response.body);
      print(body);

      if (response.statusCode != 200) {
        throw ('An Error Occured');
      }

      authToken = body['token'];
      //receive token from server
    } catch (e) {
      print(e);
      sucess = false;
    }

    return sucess;
  }
}
