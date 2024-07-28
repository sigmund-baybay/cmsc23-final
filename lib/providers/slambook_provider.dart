import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_slambook_api.dart';
import '../models/friends_model.dart';

class FriendsListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _slambookStream;
  var firebaseService = FirebaseSlambookAPI();

  FriendsListProvider() {
    fetchFriends();
  }

  // Getter
  Stream<QuerySnapshot> get slambook => _slambookStream;

  void fetchFriends() {
    _slambookStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void addFriend(Friend friend) {
    firebaseService.addFriend(friend.toJson(friend)).then((message){
      print(message);
    });
    notifyListeners();
  }

  //Provider in order to edit a friend in the friendsList
  void editedFriend(Friend friend, String newNickname, int newAge, String newRelationshipStatus, double newHappinessLevel, String newSuperpower, String newFavoriteMoto) {
    friend.nickname = newNickname;
    friend.age = newAge;
    friend.relationshipStatus = newRelationshipStatus;
    friend.happinessLevel = newHappinessLevel;
    friend.superpower = newSuperpower;
    friend.favoriteMotto = newFavoriteMoto;
    firebaseService.editedFriend(friend.id!, newNickname, newAge, newRelationshipStatus, newHappinessLevel, newSuperpower, newFavoriteMoto).then((message){
      print(message);
    });
    notifyListeners();
  }

  //Provider to edit the user's profile
  void editedProfile(Friend profile, String newNickname, int newAge, String newRelationshipStatus, double newHappinessLevel, String newSuperpower, String newFavoriteMoto) {
    profile.nickname = newNickname;
    profile.age = newAge;
    profile.relationshipStatus = newRelationshipStatus;
    profile.happinessLevel = newHappinessLevel;
    profile.superpower = newSuperpower;
    profile.favoriteMotto = newFavoriteMoto;
    firebaseService.editedProfile(profile.id!, newNickname, newAge, newRelationshipStatus, newHappinessLevel, newSuperpower, newFavoriteMoto).then((message){
      print(message);
    });
    notifyListeners();
  }

  //Provider to delete a friend from the friendsList
  void deleteFriend(Friend friend) {
    firebaseService.deleteFriend(friend.id!).then((message){
      print(message);
    });
    notifyListeners();
  }

  //Provider to check if name already exists in the database
  void checkExistingName(String name) {
    firebaseService.checkExistingName(name).then((exists){
      print(exists);
      return exists;
    });
    notifyListeners();
  }

}
