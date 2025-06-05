import 'dart:convert';
import 'package:http/http.dart' as http;

class JadwalService {
  final String baseUrl;

  JadwalService({required this.baseUrl});

  // Ambil semua jadwal
  Future<http.Response> getJadwalList() async {
    final url = Uri.parse('$baseUrl/jadwal');
    return await http.get(url);
  }

  // Ambil detail jadwal berdasarkan id
  Future<http.Response> getJadwalById(int id) async {
    final url = Uri.parse('$baseUrl/jadwal/$id');
    return await http.get(url);
  }

  // Tambah jadwal baru
  Future<http.Response> addJadwal(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/jadwal');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // Update jadwal
  Future<http.Response> updateJadwal(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/jadwal/$id');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // Hapus jadwal
  Future<http.Response> deleteJadwal(int id) async {
    final url = Uri.parse('$baseUrl/jadwal/$id');
    return await http.delete(url);
  }
}

final jadwalService = JadwalService(baseUrl: 'http://localhost:8000/api');
