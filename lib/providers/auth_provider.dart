import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> userStream;
  User? user;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    userStream = authService.getUserStream();
  }

  Future<User?> getUser () async {
    return authService.getUser();

  }

  Future<String> signIn(String username, String password) async {
    String response = await authService.signIn(username, password);
    notifyListeners();
    return response;
  }

  Future<String> signUp(String email, String password, String name, String username, List<String> contactNumbers) async {
    String response = await authService.signUp(email, password, name, username, contactNumbers);
    notifyListeners();
    return response;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}