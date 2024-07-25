import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image == null ? null : File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<UserAuthProvider>().user!.uid;
    var details =  context.read<UserAuthProvider>().getUserDetails(user);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(child: const Text('No user is logged in')),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
      }, child: Icon(Icons.qr_code),),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color.fromARGB(255, 14, 14, 66),
      ),
      backgroundColor: Color.fromARGB(255, 195, 211, 235),
      drawer: _drawer(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          }

          final details = snapshot.data!.data()!;
          final name = details['name'] ?? 'No Name';
          final username = details['username'] ?? 'No Username';
          final email = details['email'] ?? context.read<UserAuthProvider>().user!.email;
          final contactNumbers = List<String>.from(details['contactNumbers'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                    imageFile == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(30),
                            child: ClipRect(
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Name:'),
                    Text(name),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Username:'),
                    Text(username),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Email:'),
                    Text(email),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact Numbers:'),
                    ...contactNumbers.map((number) => Text(number)).toList(),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Edit details functionality here
                  },
                  child: const Text('Edit Details'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: const Text(
              "Exercise 5: Menu, Routes, and Navigation",
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(color: Color.fromARGB(255, 14, 14, 66)),
          ),
          ListTile(
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            title: const Text("Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, "/friends");
            },
          ),
          ListTile(
            title: const Text("Slambook"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/slambook");
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              context.read<UserAuthProvider>().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
