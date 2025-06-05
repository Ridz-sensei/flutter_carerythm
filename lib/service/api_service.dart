import 'dart:convert';
import 'package:http/http.dart' as http;

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
}
