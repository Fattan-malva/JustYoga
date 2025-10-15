import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/activation.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool get isAuthenticated => _user != null;
  UserModel? get user => _user;

  final ApiService _apiService = ApiService(baseUrl: 'http://localhost:3000');

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      // Assuming the response contains user data and token
      // Adjust based on your API response structure
      if (response.containsKey('user')) {
        _user = UserModel.fromJson(response['user']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiService.register(name, email, password);
      // Assuming the response contains user data and token
      // Adjust based on your API response structure
      if (response.containsKey('user')) {
        _user = UserModel.fromJson(response['user']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> checkActivation(
      String email, String phone, String noIdentity, String birthDate) async {
    try {
      final response = await _apiService.checkActivation(
          email, phone, noIdentity, birthDate);
      return response;
    } catch (e) {
      print('Activation check error: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> createActivation(
      String customerID, String name, String email, String password) async {
    try {
      final response =
          await _apiService.createActivation(customerID, name, email, password);
      return response;
    } catch (e) {
      print('Activation creation error: $e');
      throw e;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
