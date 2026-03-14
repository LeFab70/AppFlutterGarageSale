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

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoggedIn = true;
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase error: ${e.code}");
      return "Email ou mot de passe incorrect.";
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

      return "Erreur lors de la création du compte.";

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