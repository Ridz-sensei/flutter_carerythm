import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jadwal.dart';

class JadwalService {
  static const baseJadwalUrl = 'http://127.0.0.1:8000/api/jadwal';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Jadwal>> fetchJadwalList() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences.');
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.get(
      Uri.parse(baseJadwalUrl),
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
        return data.map((json) => Jadwal.fromJson(json)).toList();
      } else {
        print('Response tidak memiliki key "data" atau bukan List!');
        print('Isi response: $decoded');
        throw Exception('Format data jadwal tidak sesuai. Response: $decoded');
      }
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Gagal mengambil data jadwal. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<bool> addJadwal(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    // Kirim hari sebagai array, sesuai validasi backend
    final dataToSend = {
      ...data,
      'hari': data['hari'] is List ? data['hari'] : [data['hari']],
    };
    final response = await http.post(
      Uri.parse(baseJadwalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dataToSend),
    );
    print('Tambah jadwal status: ${response.statusCode}');
    print('Tambah jadwal body: ${response.body}');
    final decoded = json.decode(response.body);
    // Anggap sukses jika response mengandung success: true
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        (decoded['status'] == true || decoded['success'] == true)) {
      return true;
    } else {
      String msg = 'Gagal menambah jadwal. Status: ${response.statusCode}, Body: ${response.body}';
      if (decoded is Map && decoded['message'] != null) {
        msg = decoded['message'].toString();
      } else if (decoded is Map && decoded['errors'] != null) {
        msg = decoded['errors'].toString();
      }
      print('Tambah jadwal gagal, response: $decoded');
      throw Exception(msg);
    }
  }

  static Future<bool> updateJadwal(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    final response = await http.put(
      Uri.parse('$baseJadwalUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    print('Update jadwal status: ${response.statusCode}');
    print('Update jadwal body: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal update jadwal. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<bool> deleteJadwal(int id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token tidak ditemukan');
    final url = Uri.parse('$baseJadwalUrl/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Delete jadwal status: ${response.statusCode}');
    print('Delete jadwal body: ${response.body}');
    // Anggap sukses jika response mengandung success: true
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && (decoded['success'] == true)) {
        return true;
      }
    }
    return false;
  }
}
