import 'dart:convert';

import 'package:driveease/data/models/kategori.dart';
import 'package:driveease/data/providers/storage_provider.dart';
import 'package:http/http.dart' as http;

class KategoriRepository {
  final String baseUrl = "http://192.168.51.219:3001/api/kategori";
  final StorageProvider storage = StorageProvider();

  // get all
  Future<List<KategoriModel>> getAllKategori() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KategoriModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data kategori");
    }
  }

  // create
  Future<void> createKategori(Map<String, dynamic> kategoriData) async {
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kategoriData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan kategori';
    }
  }

  // delete
  Future<void> deleteKategori(int id) async {
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus data kategori';
    }
  }
}