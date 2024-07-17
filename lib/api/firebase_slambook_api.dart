// API is for backend and database operations

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSlambookAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("friendsList").snapshots();
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

