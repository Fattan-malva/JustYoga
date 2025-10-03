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

import '../models/schedule_item.dart';
import '../models/studio.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl\$path');
    final resp = await http.get(url);
    return jsonDecode(resp.body);
  }

  Future<List<ScheduleItem>> fetchSchedulesByDate(String date) async {
    final url = Uri.parse('$baseUrl/api/schedules/by-date?date=$date');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<List<Studio>> fetchStudios() async {
    final url = Uri.parse('$baseUrl/api/studios');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => Studio.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load studios');
    }
  }

  Future<List<ScheduleItem>> fetchSchedulesByDateAndStudio(String date, int studioID) async {
    final url = Uri.parse('$baseUrl/api/schedules/by-date-studio?date=$date&studioID=$studioID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load schedules by date and studio');
    }
  }

  // TODO: add post, put, delete helpers and token-based auth
}
