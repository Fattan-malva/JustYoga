import 'dart:convert';
import 'package:http/http.dart' as http;

/*
  Placeholder API service.
  - Implement actual API base URL and endpoints here.
  - Example using Laravel backend: set baseUrl to your Laravel API (e.g. https://api.example.com)
  - Add authentication headers, token handling (storage), error handling, retries, etc.

  Example (pseudo):
  final response = await http.get(Uri.parse('$baseUrl/classes'), headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  Parse response and return typed models.
*/

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl\$path');
    final resp = await http.get(url);
    return jsonDecode(resp.body);
  }

  // TODO: add post, put, delete helpers and token-based auth
}
