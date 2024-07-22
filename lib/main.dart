import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_mini_project/firebase_options.dart';
import 'screens/FriendsList.dart';
import 'screens/Slambook.dart';
import 'providers/slambook_provider.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => FriendsListProvider())),
        ChangeNotifierProvider(create: ((context) => UserAuthProvider()))
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes:{
        '/': (context) => const HomePage(),
        '/friends': (context) =>FriendsList(),
        '/slambook': (context) => Slambook(),
        },
      theme: ThemeData(
      ),
    );
  }
}
