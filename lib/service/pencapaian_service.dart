import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pencapaian.dart';

class PencapaianService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/pencapaian';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Token dari SharedPreferences: $token");
    return token;
  }

  // Method untuk debug token
  static Future<void> debugToken() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print("Semua keys di SharedPreferences: $keys");
    
    for (String key in keys) {
      final value = prefs.getString(key);
      print("$key: $value");
    }
  }

  static Future<List<Pencapaian>> fetchPencapaian() async {
    await debugToken(); // Debug token sebelum fetch
    
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
      print("Error fetch pencapaian: ${response.statusCode}");
      print("Response: ${response.body}");
      throw Exception('Gagal memuat pencapaian: ${response.statusCode}');
    }
  }

  static Future<bool> tambahPencapaian(Pencapaian pencapaian, String? passedToken) async {
    try {
      await debugToken(); // Debug token di awal
      
      // Prioritas: gunakan token dari SharedPreferences, bukan parameter
      String? token = await _getToken();
      
      // Jika tidak ada di SharedPreferences, gunakan token yang dikirim
      if (token == null || token.isEmpty) {
        token = passedToken;
        print("Menggunakan token dari parameter: $token");
      } else {
        print("Menggunakan token dari SharedPreferences: $token");
      }
      
      if (token == null || token.isEmpty) {
        print("Tidak ada token yang tersedia");
        return false;
      }

      print("Mengirim data pencapaian:");
      print("Nama: ${pencapaian.nama}");
      print("Target: ${pencapaian.target}");
      print("Jumlah: ${pencapaian.jumlah}");
      print("Kategori: ${pencapaian.kategori}");
      print("Waktu: ${pencapaian.waktuPencapaian}");
      print("Token: $token");

      final response = await http.post(
        Uri.parse('$baseUrl/tambah'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': pencapaian.nama,
          'target': pencapaian.target,
          'jumlah': pencapaian.jumlah,
          'kategori': pencapaian.kategori,
          'waktu_pencapaian': pencapaian.waktuPencapaian,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print("Berhasil menambahkan pencapaian");
          return true;
        } else {
          print("API mengembalikan success: false");
          print("Message: ${responseData['message']}");
          return false;
        }
      } else if (response.statusCode == 401) {
        print("Token tidak valid atau expired. Silakan login ulang.");
        // Hapus token yang tidak valid
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return false;
      } else {
        print("Gagal menambahkan pencapaian. Status: ${response.statusCode}");
        try {
          final errorBody = json.decode(response.body);
          print("Error message: ${errorBody['message']}");
        } catch (e) {
          print("Gagal parse error response: $e");
        }
        return false;
      }
    } catch (e) {
      print("Error saat menambahkan pencapaian: $e");
      return false;
    }
  }

  // Method untuk update pencapaian
  static Future<bool> updatePencapaian(Pencapaian pencapaian, String? passedToken) async {
    try {
      await debugToken(); // Debug token di awal
      
      // Prioritas: gunakan token dari SharedPreferences, bukan parameter
      String? token = await _getToken();
      
      // Jika tidak ada di SharedPreferences, gunakan token yang dikirim
      if (token == null || token.isEmpty) {
        token = passedToken;
        print("Menggunakan token dari parameter: $token");
      } else {
        print("Menggunakan token dari SharedPreferences: $token");
      }
      
      if (token == null || token.isEmpty) {
        print("Tidak ada token yang tersedia");
        return false;
      }

      if (pencapaian.id == null) {
        print("ID pencapaian tidak ditemukan");
        return false;
      }

      print("Mengirim data update pencapaian:");
      print("ID: ${pencapaian.id}");
      print("Nama: ${pencapaian.nama}");
      print("Target: ${pencapaian.target}");
      print("Jumlah: ${pencapaian.jumlah}");
      print("Kategori: ${pencapaian.kategori}");
      print("Waktu: ${pencapaian.waktuPencapaian}");
      print("Token: $token");

      final response = await http.put(
        Uri.parse('$baseUrl/${pencapaian.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': pencapaian.nama,
          'target': pencapaian.target,
          'jumlah': pencapaian.jumlah,
          'kategori': pencapaian.kategori,
          'waktu_pencapaian': pencapaian.waktuPencapaian,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print("Berhasil mengupdate pencapaian");
          return true;
        } else {
          print("API mengembalikan success: false");
          print("Message: ${responseData['message']}");
          return false;
        }
      } else if (response.statusCode == 401) {
        print("Token tidak valid atau expired. Silakan login ulang.");
        // Hapus token yang tidak valid
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return false;
      } else {
        print("Gagal mengupdate pencapaian. Status: ${response.statusCode}");
        try {
          final errorBody = json.decode(response.body);
          print("Error message: ${errorBody['message']}");
        } catch (e) {
          print("Gagal parse error response: $e");
        }
        return false;
      }
    } catch (e) {
      print("Error saat mengupdate pencapaian: $e");
      return false;
    }
  }

  // Method untuk delete pencapaian
  static Future<bool> deletePencapaian(int id, String? passedToken) async {
    try {
      await debugToken(); // Debug token di awal
      
      // Prioritas: gunakan token dari SharedPreferences, bukan parameter
      String? token = await _getToken();
      
      // Jika tidak ada di SharedPreferences, gunakan token yang dikirim
      if (token == null || token.isEmpty) {
        token = passedToken;
        print("Menggunakan token dari parameter: $token");
      } else {
        print("Menggunakan token dari SharedPreferences: $token");
      }
      
      if (token == null || token.isEmpty) {
        print("Tidak ada token yang tersedia");
        return false;
      }

      print("Menghapus pencapaian dengan ID: $id");
      print("Token: $token");

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print("Berhasil menghapus pencapaian");
          return true;
        } else {
          print("API mengembalikan success: false");
          print("Message: ${responseData['message']}");
          return false;
        }
      } else if (response.statusCode == 401) {
        print("Token tidak valid atau expired. Silakan login ulang.");
        // Hapus token yang tidak valid
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return false;
      } else {
        print("Gagal menghapus pencapaian. Status: ${response.statusCode}");
        try {
          final errorBody = json.decode(response.body);
          print("Error message: ${errorBody['message']}");
        } catch (e) {
          print("Gagal parse error response: $e");
        }
        return false;
      }
    } catch (e) {
      print("Error saat menghapus pencapaian: $e");
      return false;
    }
  }

  // Method untuk test token validity
  static Future<bool> testToken() async {
    final token = await _getToken();
    if (token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      print("Test token - Status: ${response.statusCode}");
      print("Test token - Response: ${response.body}");
      
      return response.statusCode == 200;
    } catch (e) {
      print("Error test token: $e");
      return false;
    }
  }
}