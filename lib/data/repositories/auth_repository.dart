import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:driveease/data/models/auth_request.dart';
import 'package:driveease/data/models/users.dart';
import 'package:driveease/data/providers/storage_provider.dart';

class AuthRepository {
  final String baseUrl = "http://192.168.51.219:3001/api/auth";
  final StorageProvider _storage = StorageProvider();

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _storage.saveToken(data['token']);

      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? "Login gagal");
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null;
  }

  Future<void> register(AuthRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? "Registrasi gagal");
    }
  }
}
