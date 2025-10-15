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
import '../models/room_type.dart';
import '../models/booking_item.dart';
import '../models/justme_item.dart';
import '../models/user.dart';
import '../models/activation.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl\$path');
    final resp = await http.get(url);
    return jsonDecode(resp.body);
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

  Future<List<RoomType>> fetchRoomTypes() async {
    final url = Uri.parse('$baseUrl/api/room-types');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => RoomType.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load room types');
    }
  }

  Future<List<ScheduleItem>> fetchSchedulesByDate(String date) async {
    final url = Uri.parse('$baseUrl/api/schedules/by-date?date=$date');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('No schedule found');
    }
  }

  Future<List<ScheduleItem>> fetchSchedulesByDateAndStudio(
      String date, int studioID) async {
    final url = Uri.parse(
        '$baseUrl/api/schedules/by-date-studio?date=$date&studioID=$studioID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('No schedule found for this date and studio');
    }
  }

  Future<List<ScheduleItem>> fetchSchedulesByDateAndRoomType(
      String date, int roomType) async {
    final url = Uri.parse(
        '$baseUrl/api/schedules/by-date-roomType?date=$date&roomType=$roomType');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('No schedule found for this date and room type');
    }
  }

  Future<List<ScheduleItem>> fetchSchedules(String date,
      {int? studioID, int? roomType}) async {
    final queryParams = <String>['date=$date'];
    if (studioID != null) queryParams.add('studioID=$studioID');
    if (roomType != null) queryParams.add('roomType=$roomType');
    final url = Uri.parse('$baseUrl/api/schedules?${queryParams.join('&')}');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load schedules');
    }
  }

  Future<List<BookingItem>> fetchBookingsByUniqCode(String uniqCode) async {
    final url =
        Uri.parse('$baseUrl/api/bookings/find-by-uniq-code?UniqCode=$uniqCode');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => BookingItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load bookings');
    }
  }

  Future<BookingItem> createBooking(BookingItem booking) async {
    final url = Uri.parse('$baseUrl/api/bookings');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(booking.toJson()),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return BookingItem.fromJson(data);
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to create booking');
    }
  }

  Future<List<JustMeItem>> fetchJustMeByDate(String date) async {
    final url = Uri.parse('$baseUrl/api/justme/by-date?date=$date');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => JustMeItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('No justme found');
    }
  }

  Future<List<JustMeItem>> fetchJustMeByDateAndStudio(
      String date, String studioID) async {
    final url = Uri.parse(
        '$baseUrl/api/justme/by-date-studio?date=$date&studioID=$studioID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => JustMeItem.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('No justme found for this date and studio');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return data;
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Login failed');
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return data;
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Registration failed');
    }
  }

  Future<Map<String, dynamic>> checkActivation(
      String email, String phone, String noIdentity, String birthDate) async {
    final url = Uri.parse(
        '$baseUrl/api/activation/check?email=$email&phone=$phone&noIdentity=$noIdentity&birthDate=$birthDate');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        return data;
      } catch (e) {
        // If not JSON, return as message
        return {'message': resp.body};
      }
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {
        // If not JSON, throw the body as exception
        throw Exception(resp.body);
      }
      throw Exception('Activation check failed');
    }
  }

  Future<Map<String, dynamic>> createActivation(
      String customerID, String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/activation/create');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerID': customerID,
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        return data;
      } catch (e) {
        return {'message': resp.body};
      }
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {
        throw Exception(resp.body);
      }
      throw Exception('Activation creation failed');
    }
  }

  // TODO: add post, put, delete helpers and token-based auth
}
