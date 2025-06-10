import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service untuk autentikasi user (login dan get user)
class AuthApi {
  final String baseUrl;

  AuthApi({required this.baseUrl});

  /// Login user dengan email dan password (POST)
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response login: $data'); // Debug: print seluruh response

      // Coba beberapa kemungkinan lokasi token
      String? token;
      if (data['token'] != null) {
        token = data['token'];
      } else if (data['data'] != null && data['data']['token'] != null) {
        token = data['data']['token'];
      } else if (data['access_token'] != null) {
        token = data['access_token'];
      } else if (data['data'] != null && data['data']['access_token'] != null) {
        token = data['data']['access_token'];
      } else if (data['data'] != null && data['data']['user'] != null && data['data']['user']['token'] != null) {
        token = data['data']['user']['token'];
      }
      print('Token yang ditemukan: $token'); // Debug: print token yang ditemukan

      // Simpan token ke SharedPreferences (seperti di tambah jadwal)
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        print('Token berhasil disimpan: $token');
      } else {
        print('Login sukses tapi token tidak ditemukan di response.');
      }
    } else {
      print('Login gagal dengan status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debug: print response error
    }
    return response;
  }

  /// Ambil data user berdasarkan email (GET)
  Future<http.Response> getUser(String email) async {
    final url = Uri.parse('$baseUrl/user?email=$email');
    final response = await http.get(url);
    return response;
  }

  /// Ambil data user berdasarkan username (GET)
  Future<http.Response> getUserByUsername(String username) async {
    final url = Uri.parse('$baseUrl/user?username=$username');
    final response = await http.get(url);
    return response;
  }

  /// Login dan return User model jika sukses
  Future<User> loginWithToken(String email, String password) async {
    final response = await login(email, password);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return User.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Login failed');
    }
    throw Exception('Failed to login');
  }

  /// Get user dengan autentikasi token
  Future<http.Response> getUserWithAuth(String email, String token) async {
    final url = Uri.parse('$baseUrl/user?email=$email');
    return await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
  }
}
