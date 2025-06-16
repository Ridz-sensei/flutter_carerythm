import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pencapaian.dart';

class PencapaianService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/pencapaian';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Pencapaian>> fetchPencapaian() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences.');
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        List data = jsonBody['data'];
        return data.map((e) => Pencapaian.fromJson(e)).toList();
      } else {
        throw Exception('Format data tidak sesuai');
      }
    } else {
      throw Exception('Gagal memuat pencapaian: ${response.statusCode}');
    }
  }

  static Future<bool> tambahPencapaian(Pencapaian pencapaian, String? token) async {
    if (token == null || token.isEmpty) {
      token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }
    }
    print('Token yang dikirim ke backend: $token'); // Debug token
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'nama': pencapaian.nama,
        'jumlah': pencapaian.jumlah,
        'target': pencapaian.target,
        'kategori': pencapaian.kategori,
        'waktu_pencapaian': pencapaian.waktuPencapaian,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody['success'] == true || jsonBody['status'] == true) {
        return true;
      } else {
        throw Exception('Gagal menambahkan pencapaian: ${jsonBody['message'] ?? 'Unknown error'}');
      }
    } else {
      // Debug: print response body jika error
      print('Tambah pencapaian gagal: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        final jsonBody = json.decode(response.body);
        if (jsonBody is Map && jsonBody['message'] != null) {
          throw Exception('Gagal menambahkan pencapaian: ${jsonBody['message']}');
        }
      } catch (_) {}
      throw Exception('Gagal menambahkan pencapaian: ${response.statusCode}');
    }
  }
}
