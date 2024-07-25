// API is for backend and database operations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSlambookAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getAllFriends() {
    String uid = auth.currentUser!.uid;
    return db.collection("friendsList").where("uid", isEqualTo: uid).snapshots();
  }

  Future<String> addFriend(Map<String, dynamic> friend) async {
    try{
      await db.collection("friendsList").add(friend);
      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Failed with error: ${e.code}";
    }
  }

  Future<String> editedFriend(String id, String nickname, int age, String relationshipStatus, double happinessLevel, String superpower, String favoriteMoto) async {
    try{
      await db.collection("friendsList").doc(id).update({"nickname": nickname, "age": age, "relationshipStatus": relationshipStatus, "happinessLevel": happinessLevel, "superpower": superpower, "favoriteMoto": favoriteMoto});
      return "Successfully updated!";
    } on FirebaseException catch (e) {
      return "Failed with error: ${e.code}";
    }
  }

  Future<String> editedProfile(String id, String nickname, int age, String relationshipStatus, double happinessLevel, String superpower, String favoriteMoto) async {
    try{
      await db.collection("users").doc(id).update({"nickname": nickname, "age": age, "relationshipStatus": relationshipStatus, "happinessLevel": happinessLevel, "superpower": superpower, "favoriteMoto": favoriteMoto});
      return "Successfully updated!";
    } on FirebaseException catch (e) {
      return "Failed with error: ${e.code}";
    }
  }

  Future<String> deleteFriend(String id) async {
    try{
      await db.collection("friendsList").doc(id).delete();
      return "Successfully removed!";
    } on FirebaseException catch (e) {
      return "Failed with error: ${e.code}";
    }
  }

  Future<bool> checkExistingName(String name) async {
    try{
      final QuerySnapshot result = await db
        .collection("friendsList")
      .where('name', isEqualTo: name)
      .limit(1)
      .get();
      return result.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      return false;
    }
  }

}

