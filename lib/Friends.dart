import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  final Map<String, dynamic> friendList;

  Friends({required this.friendList});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  late Map<String, dynamic> _friends;

  @override
  void initState() {
    super.initState();
    _friends = widget.friendList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friends List'),backgroundColor: Colors.indigo,),
      drawer: drawer(),
      body: _friends.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people),
                  Text('No friends added yet.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newFriend = await Navigator.pushNamed(context, '/slambook');
                      if (newFriend != null && newFriend is Map<String, dynamic>) {
                        setState(() {
                          _friends[newFriend['Name']] = newFriend;
                        });
                      }
                    },
                    child: Text('Go to Slambook'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                String friendName = _friends.keys.elementAt(index);
                return ListTile(
                  title: Text('${friendName}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendDetailPage(friend: _friends[friendName]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("Exercise 5: Menu, Routes, and Navigation")),
          ListTile(
            title: Text("Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/friends", arguments: widget.friendList);
            },
          ),
          ListTile(
            title: Text("Slambook"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/slambook", arguments: widget.friendList);
            },
          ),
        ],
      ),
    );
  }
}

class FriendDetailPage extends StatelessWidget {
  final Map<String, dynamic> friend;

  FriendDetailPage({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${friend['Name']}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Text("Summary", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Name'),
              Text('${friend["Name"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Nickname'),
              Text('${friend["Nickname"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Age'),
              Text('${friend["Age"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Relationship Status'),
              Text('${friend["Relationship Status"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Happiness Level'),
              Text('${friend["Happiness Level"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Superpower'),
              Text('${friend["Superpower"]}')

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Favorite Motto'),
              Text('${friend["Favorite Motto"]}')

            ],),

            Center(
              child: ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Go back"),
            ),
            ),
            
          ],
        ),
      ),
    );
  }
}
