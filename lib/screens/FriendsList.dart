import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/widgets/drawer.dart';
import '../models/friends_model.dart';
import '../providers/slambook_provider.dart';
import '../screens/FriendsDetailsPage.dart';
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
    Stream<QuerySnapshot> slambookStream = context.read<FriendsListProvider>().slambook;
    return Scaffold(
      appBar: AppBar(title: Text('Friends List',),backgroundColor: Color.fromARGB(255,167, 146, 119)),
      backgroundColor: Color.fromARGB(255,209, 187, 158),
      drawer: MyDrawer(),
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
      
      
      
      StreamBuilder(
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
                  Icon(Icons.people, color: Colors.white,),
                  Text('No friends added yet.', style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/slambook');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 167, 146, 119)),
                    child: Text('Go to Slambook', style: TextStyle(color: Colors.black),),
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
           
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255,167, 146, 119),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
              title: Text(friend.name,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendDetailPage(friend: friend,),
                  ),
                );
              },
            ),
            );  
          },
        );
        }
      )
      ]
      )
    );
  }
}
