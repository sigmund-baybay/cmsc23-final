import 'package:flutter/material.dart';
import 'Friends.dart';
import 'Slambook.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/friends",
      onGenerateRoute: (settings) {
        final friendList = settings.arguments as Map<String,dynamic>?;
        if (settings.name == "/friends") {      
          return MaterialPageRoute(builder: (context) => Friends(friendList: friendList ?? {}));
        }
        if (settings.name == "/slambook") {
          return MaterialPageRoute(builder: (context) => Slambook(friendList: friendList ?? {}));
        }
        return null;
      },
    );
  }
}
