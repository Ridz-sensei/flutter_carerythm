import 'dart:convert'; // Digunakan untuk mengkonversi JSON dari dan ke Map
import 'package:http/http.dart' as http; // Paket untuk melakukan HTTP request
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan dan mengambil data lokal, seperti token
import '../models/kegiatan.dart'; // Model kegiatan yang merepresentasikan data

class ApiService {
  // URL dasar
  static const baseKegiatanUrl = 'http://127.0.0.1:8000/api/kegiatan';

  // Mengambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Mengambil nilai token yang tersimpan
  }

  // Mengambil daftar kegiatan dari server
  static Future<List<Kegiatan>> fetchKegiatan() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences.');
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    // Mengirim request GET ke endpoint
    final response = await http.get(
      Uri.parse(baseKegiatanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Menyisipkan token pada header
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Jika response sukses
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // Mengecek apakah response mengandung key 'data' dan bertipe List
      if (decoded is Map && decoded.containsKey('data') && decoded['data'] is List) {
        final List data = decoded['data'];
        print('Jumlah data kegiatan diambil: ${data.length}');
        return data.map((json) => Kegiatan.fromJson(json)).toList(); // Mapping JSON ke model
      } else {
        print('Response tidak memiliki key "data" atau bukan List!');
        throw Exception('Format data kegiatan tidak sesuai. Response: $decoded');
      }
    } else {
      // Jika response bukan 200, lempar error
      throw Exception('Gagal mengambil data kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Menambahkan kegiatan baru ke server
  static Future<bool> tambahKegiatan(Map<String, dynamic> kegiatan) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    // Mengirim request POST ke server
    final response = await http.post(
      Uri.parse(baseKegiatanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kegiatan), // Encode data kegiatan ke JSON
    );

    print('Tambah kegiatan status: ${response.statusCode}');
    print('Tambah kegiatan body: ${response.body}');

    final decoded = json.decode(response.body);

    // Jika berhasil ditambah dan response 'status' true
    if ((response.statusCode == 200 || response.statusCode == 201) && decoded['status'] == true) {
      return true;
    } else {
      // Jika gagal, lempar exception
      print('Tambah kegiatan gagal, response: $decoded');
      throw Exception('Gagal menambah kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Mengupdate data kegiatan yang sudah ada
  static Future<bool> updateKegiatan(Map<String, dynamic> kegiatan) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    // Mengirim request PUT dengan ID kegiatan
    final response = await http.put(
      Uri.parse('$baseKegiatanUrl/${kegiatan['id']}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kegiatan), // Encode data ke JSON
    );

    print('Update kegiatan status: ${response.statusCode}');
    print('Update kegiatan body: ${response.body}');

    // Jika berhasil (status 200)
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal update kegiatan. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Menghapus kegiatan berdasarkan ID
  static Future<bool> deleteKegiatan(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    // Mengirim request DELETE ke server
    final response = await http.delete(
      Uri.parse('$baseKegiatanUrl/$id'), // Endpoint lengkap dengan ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Mengembalikan true jika status code 200 (berhasil)
    return response.statusCode == 200;
  }
}
