import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

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
import '../models/booking_list_item.dart';
import '../models/justme_item.dart';
import '../models/activation.dart';
import '../models/plan_history.dart';
import '../models/just_me_history.dart';
import '../models/active_plan.dart';

class ApiService {
  final String baseUrl;
  final SecureStorageService _secureStorage = SecureStorageService();

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl\$path');
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
    return jsonDecode(resp.body);
  }

  // GET STUDIOS
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

  // GET ROOM TYPES
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

  // GET SCHEDULES
  Future<List<ScheduleItem>> fetchSchedulesByDate(String date) async {
    final url = Uri.parse('$baseUrl/api/schedules/by-date?date=$date');
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
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
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
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
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
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
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
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

  // GET BOOKINGS
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

  // GET BOOKINGS BY CUSTOMER ID
  Future<List<BookingListItem>> fetchBookingsByCustomerId(
      String customerId) async {
    final url = Uri.parse(
        '$baseUrl/api/bookings/find-by-customer-id?customerID=$customerId');
    final token = await _secureStorage.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => BookingListItem.fromJson(item)).toList();
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

  // CREATE BOOKING
  Future<Map<String, dynamic>> createBooking(BookingItem booking) async {
    final url = Uri.parse('$baseUrl/api/bookings');
    final token = await _secureStorage.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final resp = await http.post(
      url,
      headers: headers,
      body: jsonEncode(booking.toJson()),
    );

    // Coba parse semua response ke Map
    final Map<String, dynamic> data = jsonDecode(resp.body);

    // Balikkan langsung message dari server, baik sukses maupun gagal
    return data;
  }

  // GET JUSTME
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

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      // Save token to secure storage
      if (data.containsKey('token')) {
        await _secureStorage.saveToken(data['token']);
      }
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

  // REGISTER
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

  // ACTIVATION
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
      String customerID,
      String name,
      String toStudioID,
      String lastContractID,
      String noIdentity,
      String birthDate,
      String phone,
      String email,
      String password) async {
    final url = Uri.parse('$baseUrl/api/activation/create');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerID': customerID,
        'name': name,
        'toStudioID': toStudioID,
        'lastContractID': lastContractID,
        'noIdentity': noIdentity,
        'birthDate': birthDate,
        'phone': phone,
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

  Future<ActivationModel> fetchActivation(String customerID) async {
    final url = Uri.parse('$baseUrl/api/activation/$customerID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return ActivationModel.fromJson(data);
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load activation');
    }
  }

  Future<Map<String, dynamic>> fetchCustomer(String customerID) async {
    final url = Uri.parse('$baseUrl/api/customers?customerID=$customerID');
    final token = await _secureStorage.getToken(); // ambil token yang disimpan

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Tambahkan Authorization jika token tersedia
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final resp = await http.get(url, headers: headers);

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
      throw Exception('Failed to load customer');
    }
  }

  // LOGOUT
  Future<Map<String, dynamic>> logout(String customerID) async {
    final url = Uri.parse('$baseUrl/api/auth/logout');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'customerID': customerID}),
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      // Delete token from secure storage
      await _secureStorage.deleteToken();
      return data;
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Logout failed');
    }
  }

  // GET PLAN HISTORY
  Future<List<PlanHistory>> fetchPlanHistory(String customerID) async {
    final url =
        Uri.parse('$baseUrl/api/product/plan-history?customerID=$customerID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => PlanHistory.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load plan history');
    }
  }

  // GET JUST ME HISTORY
  Future<List<JustMeHistory>> fetchJustMeHistory(String customerID) async {
    final url = Uri.parse(
        '$baseUrl/api/product/just-me-history?customerID=$customerID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => JustMeHistory.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load just me history');
    }
  }

  // GET ACTIVE PLAN
  Future<List<ActivePlan>> fetchActivePlan(String lastContractID) async {
    final url = Uri.parse(
        '$baseUrl/api/product/active-plan?lastContractID=$lastContractID');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((item) => ActivePlan.fromJson(item)).toList();
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(resp.body);
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to load active plan');
    }
  }
}
