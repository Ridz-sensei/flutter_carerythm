import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseKegiatanUrl = 'http://127.0.0.1:8000/api/kegiatan';
  static const baseJadwalUrl = 'http://127.0.0.1:8000/api/jadwal';

  static Future<List<dynamic>> fetchKegiatan() async {
    final response = await http.get(Uri.parse(baseKegiatanUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Gagal mengambil data kegiatan');
    }
  }

  static Future<bool> tambahKegiatan(Map<String, dynamic> kegiatan) async {
    final response = await http.post(
      Uri.parse(baseKegiatanUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kegiatan),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateKegiatan(Map<String, dynamic> kegiatan) async {
    final response = await http.put(
      Uri.parse('$baseKegiatanUrl/${kegiatan['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kegiatan),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteKegiatan(int id) async {
    final response = await http.delete(
      Uri.parse('$baseKegiatanUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }
}
