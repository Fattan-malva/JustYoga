import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/dummy_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool get isAuthenticated => _user != null;
  UserModel? get user => _user;

  // For demo: simple login with dummy user
  Future<bool> loginWithDummy(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 600));
    // Dummy credentials
    if (email == demoUser.email && password == 'password123') {
      _user = demoUser;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // TODO: Call API to register and receive created user & token
    await Future.delayed(Duration(milliseconds: 600));
    _user = UserModel(
        id: 'u2',
        name: name,
        email: email,
        avatarUrl: 'https://i.pravatar.cc/150?img=5');
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
