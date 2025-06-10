import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kegiatan.dart';

class ApiService {
  // Ganti URL jika endpoint GET berbeda
  static const baseKegiatanUrl = 'http://127.0.0.1:8000/api/kegiatan'; // misal: .../kegiatan/list

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Kegiatan>> fetchKegiatan() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences.');
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.get(
      // Jika endpoint GET berbeda, ganti di sini:
      // Uri.parse('http://127.0.0.1:8000/api/kegiatan/list'),
      Uri.parse(baseKegiatanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded.containsKey('data') && decoded['data'] is List) {
        final List data = decoded['data'];
        print('Jumlah data kegiatan diambil: ${data.length}');
        return data.map((json) => Kegiatan.fromJson(json)).toList();
      } else {
        print('Response tidak memiliki key "data" atau bukan List!');
        print('Isi response: $decoded');
        throw Exception('Format data kegiatan tidak sesuai. Response: $decoded');
      }
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Gagal mengambil data kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<bool> tambahKegiatan(Map<String, dynamic> kegiatan) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.post(
      Uri.parse(baseKegiatanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kegiatan),
    );
    print('Tambah kegiatan status: ${response.statusCode}');
    print('Tambah kegiatan body: ${response.body}');
    // Cek jika backend mengembalikan pesan error di dalam body meskipun status 200
    final decoded = json.decode(response.body);
    if ((response.statusCode == 200 || response.statusCode == 201) && decoded['status'] == true) {
      return true;
    } else {
      print('Tambah kegiatan gagal, response: $decoded');
      throw Exception('Gagal menambah kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<bool> updateKegiatan(Map<String, dynamic> kegiatan) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.put(
      Uri.parse('$baseKegiatanUrl/${kegiatan['id']}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kegiatan),
    );
    print('Update kegiatan status: ${response.statusCode}');
    print('Update kegiatan body: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal update kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<bool> deleteKegiatan(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.delete(
      Uri.parse('$baseKegiatanUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}
