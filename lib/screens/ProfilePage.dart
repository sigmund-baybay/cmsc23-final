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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        }, child: Icon(Icons.qr_code),),
      appBar: AppBar(title: Text('Profile',style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255,14,14,66)),
      backgroundColor: Color.fromARGB(255, 195,211,235),
      drawer: drawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(onPressed: ()async{
            final image = await ImagePicker()
              .pickImage(source: ImageSource.camera);
            
            setState(() {
              imageFile = image == null ? null : File(image.path);
            });
            
            }, 
            child: Padding(padding: 
            EdgeInsets.all(10), child: Icon(Icons.camera_alt_outlined,),),),

            imageFile == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(30),
                    child: ClipRect(
                      child:  Image.file(imageFile!, fit: BoxFit.cover, width: 50, height: 50,),
                    ),
                  ),

            ],),
      
          ],
      
        ),
      )
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text("Exercise 5: Menu, Routes, and Navigation", style: TextStyle(color: Colors.white),),
          decoration: BoxDecoration(color:Color.fromARGB(255,14,14,66)),),
          ListTile(
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            title: Text("Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            title: Text("Slambook"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/slambook",);
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