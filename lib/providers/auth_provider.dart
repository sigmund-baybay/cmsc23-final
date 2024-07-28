import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> userStream;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    userStream = authService.getUserStream();
  }

  User? get user => authService.getUser();
  String get uid => authService.getUserId();

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

   Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(uid) async {
    return await authService.getUserDetails(uid);

  }

  String getUserId() {
    final details = authService.getUserId();
    notifyListeners();
    return details;

  }

  Future<bool> existingName(String username) async {
      bool response = await authService.existingName(username);
      notifyListeners();
      return response;
  }


}