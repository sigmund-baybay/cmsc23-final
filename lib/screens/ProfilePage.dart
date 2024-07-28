import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/models/friends_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/drawer.dart';
import 'ProfilePageEdit.dart';
import 'QRCodePage.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  String? pfpImage;

  @override
  void initState() {
    super.initState();
    _getProfilePic();
  }

  // Check if profile page is already existing
  Future<void> _getProfilePic() async {
    final uid = context.read<UserAuthProvider>().user!.uid;
    final storageRef = FirebaseStorage.instance.ref().child("pfp/$uid.jpg");

    try {
      final url = await storageRef.getDownloadURL();
      setState(() {
        pfpImage = url;
      });
    } catch (e) {
      print("Failed to retrieve profile picture: $e");
      setState(() {
        pfpImage = null;
      });
    }
  }

  // Upload current profile picture to Firebase Storage
  Future<void> _uploadProfilePic(File imageFile) async {
    final uid = context.read<UserAuthProvider>().user!.uid;
    final storageRef = FirebaseStorage.instance.ref().child("pfp/$uid.jpg");

    try {
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      setState(() {
        pfpImage = url;
      });
    } catch (e) {
      print("Failed to upload profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserAuthProvider>().user!.uid;
    var details = context.read<UserAuthProvider>().getUserDetails(user);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCodePage(),
            ),
          );
        },
        child: Icon(Icons.qr_code),
        backgroundColor: Color.fromARGB(255, 167, 146, 119),
      ),
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color.fromARGB(255, 167, 146, 119),
      ),
      backgroundColor: Color.fromARGB(255, 209, 187, 158),
      drawer: MyDrawer(),
      // Contains all profile page details
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          // Future builder 
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
              final uid = user;

              final happinessLevel = details['happinessLevel'] != null ? details['happinessLevel'].toDouble() : 0.0;

              // Initializes slambook details of the user
              final slamBookDetails = Friend(
                  name: name,
                  nickname: details['nickname'] ?? '',
                  age: details['age'] ?? 0,
                  relationshipStatus: details['relationshipStatus'] ?? 'Not Single',
                  happinessLevel: happinessLevel,
                  superpower: details['superpower'] ?? 'Makalipad',
                  favoriteMotto: details['favoriteMoto'] ?? 'Haters gonna hate',
                  verified: false,
                  uid: uid);

              // Contains all details 
              return Padding( 
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 50), child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: pfpImage == null
                                  ?  AssetImage("assets/temp_pfp.jpg")
                                  : NetworkImage(pfpImage!),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final takenImage = await ImagePicker().pickImage(source: ImageSource.camera);
                                  if (takenImage != null) {
                                    setState(() {
                                      image = File(takenImage.path);
                                    });
                                    await _uploadProfilePic(image!);
                                  }
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        //User details based on input in signup
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 209, 187, 158),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Name'),
                                  Expanded(child: Text(name, textAlign: TextAlign.right)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('Username'),
                                  Expanded(child: Text(username, textAlign: TextAlign.right)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('Email'),
                                  Expanded(child: Text(email, textAlign: TextAlign.right)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //User's slambook details input
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          slamBookDetails.nickname == ""
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("No Slambook Details Yet.", style: TextStyle(color: Colors.white)),
                                ],
                              )
                            : 
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 209, 187, 158),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Slambook Details",
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Nickname'),
                                      Expanded(child: Text(slamBookDetails.nickname, textAlign: TextAlign.right)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Age'),
                                      Expanded(child: Text(slamBookDetails.age.toString(), textAlign: TextAlign.right)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Relationship Status'),
                                      Expanded(child: Text(slamBookDetails.relationshipStatus, textAlign: TextAlign.right)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Happiness Level'),
                                      Expanded(child: Text(slamBookDetails.happinessLevel.toString(), textAlign: TextAlign.right)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Superpower'),
                                      Expanded(child: Text(slamBookDetails.superpower!, textAlign: TextAlign.right)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Favorite Motto'),
                                      Expanded(
                                        child: Text(
                                          slamBookDetails.favoriteMotto!,
                                          maxLines: 2,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 10),
                          ElevatedButton( 
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePageEdit(profile: slamBookDetails),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 167, 146, 119)),
                            child: Text("Edit Entry", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
