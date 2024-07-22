import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUserStream() {
    return auth.authStateChanges(); // Returns a stream of user changes
  }

  User? getUser() {
    return auth.currentUser; // Returns who is logged in
  }

  Future<String> signIn(String username, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: username, password: password);
      return "Successfully signed in!";
    } on FirebaseAuthException catch(e) {
      return "Failed at error: ${e.code}";
    }
  }

  Future<String> signUp(String email, String password, String name, String username, List<String> contactNumbers) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      await db.collection("users").add({"email": email, "name": name, "username": username, "contactNumbers": contactNumbers});
      return "Successfully created account!";
    } on FirebaseAuthException catch(e) {
      return "Failed at error: ${e.code}";
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<String> getEmail(String username) async {
    return "";

  }

}