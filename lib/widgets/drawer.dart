import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/screens/home_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255,209, 187, 158),
      child: ListView(
        children: [
          DrawerHeader(child: Text("Exercise 5: Menu, Routes, and Navigation",),
          decoration: BoxDecoration(color:Color.fromARGB(255,167, 146, 119)),),
          ListTile(
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, "/profile", ModalRoute.withName('/profile'));
            },
          ),
          ListTile(
            title: Text("Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, "/friends", ModalRoute.withName('/friends'));
            },
          ),
          ListTile( 
            title: Text("Slambook"),
            onTap: () async {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, "/slambook", ModalRoute.withName('/slambook'));
            },
          ),
          ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/",
                  (Route<dynamic> route) => false, 
            );
          },
        ),
        ],
      ),
    )
    );
  }
}