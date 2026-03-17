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

  String _messageFromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return "Pas de connexion internet. Vérifiez votre réseau puis réessayez.";
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return "Email ou mot de passe incorrect.";
      case 'invalid-email':
        return "Adresse email invalide.";
      case 'user-disabled':
        return "Ce compte est désactivé.";
      case 'too-many-requests':
        return "Trop de tentatives. Réessayez plus tard.";
      default:
        return "Erreur de connexion (${e.code}).";
    }
  }

  Future<String?> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase error: ${e.code}");
      return _messageFromAuthException(e);
    } catch (e) {
      debugPrint("Error: $e");
      return "Erreur lors de la connexion.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<String?> signup({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoggedIn = true;
      return null;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        return "Cet email est déjà utilisé.";
      }

      if (e.code == 'weak-password') {
        return "Mot de passe trop faible (minimum 6 caractères).";
      }

      if (e.code == 'invalid-email') {
        return "Adresse email invalide.";
      }

      if (e.code == 'network-request-failed') {
        return "Pas de connexion internet. Vérifiez votre réseau puis réessayez.";
      }

      return "Erreur lors de la création du compte (${e.code}).";

    } finally {
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