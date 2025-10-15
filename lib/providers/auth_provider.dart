import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool get isAuthenticated => _user != null;
  UserModel? get user => _user;

  final ApiService _apiService =
      ApiService(baseUrl: 'http://192.168.234.182:3000');

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

  void logout() {
    _user = null;
    notifyListeners();
  }
}
