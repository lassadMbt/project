// lib/repository/auth_repo.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client client = http.Client();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var res = await client.post(
        Uri.parse("http://localhost:8080/auth/login"),
        headers: {},
        body: {"email": email, "password": password},
      ).timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

final data = json.decode(res.body);
    if (data['message'] == "User logged in" ||
        data['message'] == "Agency logged in") {
      // Store token for later use
      await storeToken(data['token']);
      return data;
    } else {
      return {"error": "Authentication problem"};
    }
  } catch (e) {
    if (e is SocketException) {
      return {"error": "Connection error: Unable to connect to the server"};
    } else {
      return {"error": "An error occurred: $e"};
    }
  }
}

  Future<Map<String, dynamic>> signUp(
      String name,
      String agencyName,
      String email,
      String password,
      String type,
      String language,
      String country,
      String location,
      String description) async {
    try {
      var res = await client.post(
        Uri.parse("http://localhost:8080/auth/signup"),
        headers: {},
        body: {
          "name": name,
          "agencyName": agencyName,
          "email": email,
          "password": password,
          "type": type,
          "language": language,
          "country": country,
          "location": location,
          "description": description,
        },
      ).timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

      final data = json.decode(res.body);
      if (data['message'] == "User created successfully" ||
          data['message'] == "Agency created successfully") {
        // Store token for later use
        await storeToken(data['token']);
        return data;
      } else {
        return {"error": "Authentication problem"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<String?> retrieveToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
