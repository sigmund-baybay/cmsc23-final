import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/models/friends_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/slambook_provider.dart';
import 'FriendsDetailsPage.dart';
import 'QRCodePage.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRCodePage(),
          ),
        );
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
          
          final slamBookDetails = Friend(
            name: name, 
            nickname: details['nickname'] ?? '', 
            age: details['age'] ?? 0, 
            relationshipStatus: details['relationshipStatus'] ?? '', 
            happinessLevel: details['happinessLevel'] ?? 0.0, 
            superpower: details['superpower'] ?? '', 
            favoriteMoto: details['favoriteMoto'] ?? '', 
            uid: details['uid'] ?? '');


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
                Divider(thickness: 3,
              color: Colors.indigoAccent,),

                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name'),
                  Text(slamBookDetails.name)

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Nickname'),
                  Text(slamBookDetails.nickname)

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Age'),
                  Text(slamBookDetails.age.toString())

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Relationship Status'),
                  Text(slamBookDetails.relationshipStatus)

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Happiness Level'),
                  Text(slamBookDetails.happinessLevel.toString())

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Superpower'),
                  Text(slamBookDetails.superpower!)

                ],),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Favorite Motto'),
                  Text(slamBookDetails.favoriteMoto!)

                ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        MaterialPageRoute(
                          builder: (context) => FriendsDetailsEdit(friend: slamBookDetails,),
                        );
                      },
                    child: const Text('Edit Details'),
                    ),
                  ],
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


class ProfilePageEdit extends StatefulWidget {
  Friend friend;

  ProfilePageEdit({super.key, required this.friend});

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  static final List<String> _dropdownOptions = [
    "Makalipad",
    "Maging Invisible",
    "Mapaibig siya",
    "Mapabago ang isip niya",
    "Mapalimot siya",
    "Mabalik ang nakaraan",
    "Mapaghiwalay sila",
    "Makarma siya",
    "Mapasagasaan siya sa pison",
    "Mapaitim ang tuhod ng iniibig niya"
  ];
  static final List<String> _motto = [
    "Haters gonna hate",
    "Bakers gonna Bake",
    "If cannot be, borrow one from three",
    "Less is more, more or less",
    "Better late than sorry",
    "Don't talk to strangers when your mouth is full",
    "Let's burn the bridge when we get there"
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _relationshipStatus = false;
  double _happinessLevel = 0;
  String _superpower = _dropdownOptions.first;
  String _favoriteMotto = _motto.first;


  void initState(){
    super.initState();
    _nicknameController.text = widget.friend.nickname;
    _ageController.text = widget.friend.age.toString();
    _relationshipStatus = widget.friend.relationshipStatus == 'Single';
    _happinessLevel = widget.friend.happinessLevel;
    _superpower = widget.friend.superpower ?? _dropdownOptions.first;
    _favoriteMotto = widget.friend.favoriteMoto ?? _motto.first;

  }
  
  void _resetForm() {
    _formKey.currentState?.reset();
    _nicknameController.clear();
    _ageController.clear();
    setState(() {
      _relationshipStatus = false;
      _happinessLevel = 0;
      _superpower = _dropdownOptions.first;
      _favoriteMotto = _motto.first;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String nickname = _nicknameController.text;
      int age = int.parse(_ageController.text);
      String relationshipStatus = _relationshipStatus ? 'Single' : 'Not Single';

      context.read<FriendsListProvider>().editedFriend(widget.friend, nickname, age, relationshipStatus, _happinessLevel, _superpower, _favoriteMotto);

      print(widget.friend.name);

      Navigator.pop(context);
      Navigator.pushNamed(context, '/');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.name,style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255,14,14,66)),
      backgroundColor: Color.fromARGB(255, 195,211,235),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: Text("Edit Details", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
              ),

              Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nickname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )),
              Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(child: 
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter valid number';
                      }
                      return null;
                    },
                  )),

                  Flexible(child: 
                  SwitchListTile(
                    title: Text('Are you single?'),
                    value: _relationshipStatus,
                    onChanged: (bool value) {
                      setState(() {
                        _relationshipStatus = value;
                      });
                    },
                  )),           
                ],
              )),      

              Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Happiness Level", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("On a scale of 0 (Hopeless) to 10 (Very Happy), how would you rate your current lifestyle?)"),
                  Slider(
                    value: _happinessLevel,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _happinessLevel.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _happinessLevel = value;
                      });
                    },
                  )
                ],
              ) 
              ),

              Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Superpower", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("If you were to have a superpower, what would it be?"),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Superpower'),
                    value: _superpower,
                    items: _dropdownOptions.map((String power) {
                      return DropdownMenuItem<String>(
                        value: power,
                        child: Text(power),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _superpower = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    },  
                  )
                ],
              ),
              ),
 

              Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Text("Motto", style: TextStyle(fontWeight: FontWeight.bold),),
             
                Column(
                  children: _motto.map((motto) {
                    return RadioListTile<String>(
                      title: Text(motto),
                      value: motto,
                      groupValue: _favoriteMotto,
                      onChanged: (String? value) {
                        setState(() {
                          _favoriteMotto = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],)),

              Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Update'),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}