import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

   //Verifier si user deja connecté
  LoginProvider(){
    _isLoggedIn=_auth.currentUser!=null;
    debugPrint("User online ${_auth.currentUser?.email ?? "Aucun"}");
  }

  Future<String?> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // requête serveur
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    }
  }
  Future<String?> signup({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    }
   finally {
  _isLoading = false;
  notifyListeners();
  }

  }
  Future<void> logout() async {
    await _auth.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}