import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateUserService {
  final String baseUrl = "http://localhost:8082";

  Future<String> createUser({
    required String username,
    required String email,
    required String password,
    required String role, // Accepts either ROLE_SELLER or ROLE_BUYER
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/addNewUser"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "email": email,
        "password": password,
        "roles": [role],
        "resetToken": "string",
        "tokenExpirationTime":
            DateTime.now().add(Duration(days: 7)).toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return "User created successfully!";
    } else {
      throw Exception("User creation failed: ${response.body}");
    }
  }

  Future<String> generateToken({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/generateToken"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Token
    } else {
      throw Exception("Token generation failed: ${response.body}");
    }
  }

  Future<String> createSeller({
    required String token,
    required String companyName,
    required String phoneNumber,
    required Map<String, String> sellerAddress,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/seller/create-seller-account"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "companyName": companyName,
        "phoneNumber": phoneNumber,
        "sellerAddress": sellerAddress,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      return "Seller account created successfully!";
    } else {
      throw Exception("Seller account creation failed: ${response.body}");
    }
  }

  Future<String> createBuyer({
    required String token,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/buyer/create-buyer-account"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "id": 0,
        "name": name,
      }),
    );

    if (response.statusCode == 200) {
      return "Buyer account created successfully!";
    } else {
      throw Exception("Buyer account creation failed: ${response.body}");
    }
  }
}
