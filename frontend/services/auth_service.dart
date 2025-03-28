import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'storage_service.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8082';
  final StorageService _storageService = StorageService();

  Future<String?> login(String username, String password) async {
    final String url = '$baseUrl/auth/generateToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final String token = response.body.trim();
        await _storageService.saveToken(token);
        return token;
      } else {
        return 'Login failed: ${response.statusCode}';
      }
    } catch (error) {
      return 'An error occurred: $error';
    }
  }

  List<dynamic> getUserRoles(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['roles'] ?? [];
  }

  Future<String> requestResetPassword(String email) async {
    final Uri url =
        Uri.parse("$baseUrl/auth/requestResetPassword?email=$email");

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        return response.body; // Success message
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  Future<String> resetPassword(String token, String newPassword) async {
    final Uri url = Uri.parse(
        "$baseUrl/auth/resetPassword?token=$token&newPassword=$newPassword");

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        return response.body; // Success message
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
