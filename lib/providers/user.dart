import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_app_fixed/models/http_exception.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User extends ChangeNotifier {
  String id = '';
  String name = '';
  String imageUrl = '';
  String token = '';
  FlutterSecureStorage storage = const FlutterSecureStorage();

  setName(String name) {
    this.name = name;
  }

  setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  verifyToken(String idToken) async {
    final url = Uri.http(
      'localhost:3000',
      '/auth/google/mobile',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idToken': idToken,
      }),
    );

    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final user = json.decode(response.body);

    id = user['userId'];
    name = user['name'];
    imageUrl = user['imageUrl'];
    token = user['token'];

    storage.write(key: 'jwt', value: token);

    notifyListeners();
  }
}
