import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_exr4/models/friends_model.dart';
import 'package:flutter_app_exr4/providers/slambook_provider.dart';
import 'package:flutter_app_exr4/screens/FriendsDetailsPage.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';


class FriendsList extends StatefulWidget {

  FriendsList({super.key});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> slambookStream = context.watch<FriendsListProvider>().slambook;
    return Scaffold(
      appBar: AppBar(title: Text('Friends List',style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255,14,14,66)),
      backgroundColor: Color.fromARGB(255, 195,211,235),
      drawer: drawer(),
      body: StreamBuilder(
        stream: slambookStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people),
                  Text('No friends added yet.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/slambook');
                    },
                    child: Text('Go to Slambook'),
                  ),
                ],
              ),
            );
          }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            Friend friend = Friend.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              friend.id = snapshot.data?.docs[index].id;
           
            return ListTile(
              title: Text(friend.name,textAlign: TextAlign.center,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendDetailPage(friend: friend,),
                  ),
                );
              },
            );
          },
        );
        }
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
