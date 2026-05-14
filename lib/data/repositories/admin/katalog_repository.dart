import 'dart:convert';

import 'package:driveease/data/models/katalog.dart';
import 'package:driveease/data/providers/storage_provider.dart';
import 'package:http/http.dart' as http;

class KatalogRepository {
  final String baseUrl = "http://192.168.51.219:3001/api/katalog";
  final StorageProvider storage = StorageProvider();

  // get all
  Future<List<KatalogModel>> getAllKatalog() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data katalog");
    }
  }

  // get by id
  Future<KatalogModel> getKatalogById(int id) async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      return KatalogModel.fromJson(body['data']);
    } else {
      throw Exception("Gagal mengambil detail katalog");
    }
  }

  // get by search nama
  Future<List<KatalogModel>> searchKatalog(String nama) async {
  final token = await storage.getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/search?nama=$nama'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = jsonDecode(response.body);

    final List<dynamic> data = body['data'];

    return data.map((item) => KatalogModel.fromJson(item)).toList();
  } else {
    throw Exception("Gagal mencari katalog");
  }
}

  // create katalog
  Future<void> createKatalog(Map<String, dynamic> katalogData) async {
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(katalogData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan katalog';
    }
  }

  // update
  Future<void> updateKatalog(int id, Map<String, dynamic> katalogData) async {
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(katalogData),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal memperbarui data katalog';
    }
  }

  // delete
  Future<void> deleteKatalog(int id) async {
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus data katalog';
    }
  }
}
