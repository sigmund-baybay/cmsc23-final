import 'dart:convert';

class Friend {
  String? id;
  String name;
  String nickname;
  int age;
  String relationshipStatus;
  double happinessLevel;
  String? superpower;
  String? favoriteMotto;
  bool verified;
  String? uid;

  Friend({
    this.id,
    required this.name,
    required this.nickname,
    required this.age,
    required this.relationshipStatus,
    required this.happinessLevel,
    required this.superpower,
    required this.favoriteMotto,
    required this.verified,
    required this.uid
  });

  // Factory constructor to instantiate object from json format
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      age: json['age'],
      relationshipStatus: json['relationshipStatus'],
      happinessLevel: json['happinessLevel'].toDouble(),
      superpower: json['superpower'],
      favoriteMotto: json['favoriteMoto'],
      verified: json['verified'],
      uid: json['uid']
    );
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Friend friend) {
    return {
      'name': friend.name,
      'nickname': friend.nickname,
      'age': friend.age,
      'relationshipStatus': friend.relationshipStatus,
      'happinessLevel': friend.happinessLevel,
      'superpower': friend.superpower,
      'favoriteMoto': friend.favoriteMotto,
      'verified': friend.verified,
      'uid': friend.uid
    };
  }
}
