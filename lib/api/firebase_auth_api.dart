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
      final QuerySnapshot result = await db
      .collection("users")
      .where('username', isEqualTo: username)
      .get();

      if (result.docs.isEmpty) {
        return "Username not found";
      }

      var data = result.docs.first.data() as Map;
      var email = data["email"];

      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully signed in!";
    } on FirebaseAuthException catch(e) {
      return "Failed at error: ${e.code}";
    }
  }

  Future<String> signUp(String email, String password, String name, String username, List<String> contactNumbers) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = auth.currentUser!.uid;
      await db.collection("users").doc(uid).set({"email": email, "name": name, "username": username, "contactNumbers": contactNumbers});
      return "Successfully created account!";
    } on FirebaseAuthException catch(e) {
      return "Failed at error: ${e.code}";
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

}