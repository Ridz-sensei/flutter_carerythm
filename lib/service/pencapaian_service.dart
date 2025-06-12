import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pencapaian.dart';

class PencapaianService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/pencapaian'; // GANTI sesuai lingkungan Anda

  static Future<List<Pencapaian>> fetchPencapaian() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
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
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server: $e\n'
          'Pastikan:\n'
          '- API berjalan dan dapat diakses dari device/emulator/web\n'
          '- URL sudah benar\n'
          '- Backend mengizinkan CORS (untuk Flutter web)');
    }
  }

  static Future<bool> tambahPencapaian(Pencapaian pencapaian, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tambah'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(pencapaian.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
