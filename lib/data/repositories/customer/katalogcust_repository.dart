import 'dart:convert';

import 'package:driveease/data/models/katalog.dart';
import 'package:driveease/data/models/kategori.dart';
import 'package:driveease/data/providers/storage_provider.dart';
import 'package:http/http.dart' as http;

class KatalogcustRepository {
  final String baseUrl = "http://10.43.129.235:3001/api/katalog/customer";
  final StorageProvider storage = StorageProvider();

  // get all
  Future<List<KatalogModel>> getAllKatalogCustomer() async {
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
      throw Exception("Gagal mengambil data katalog customer");
    }
  }

  // get by id
  Future<KatalogModel> getKatalogCustomerById(int id) async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      return KatalogModel.fromJson(body['data']);
    } else {
      throw Exception("Gagal mengambil detail katalog customer");
    }
  }

  // get by search nama
  Future<List<KatalogModel>> searchKatalogCustomer(String nama) async {
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
    throw Exception("Gagal mencari katalog customer");
  }
}

}