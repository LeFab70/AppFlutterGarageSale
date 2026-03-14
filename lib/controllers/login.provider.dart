import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Simule une connexion
  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simule requête serveur

    //appel API
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}