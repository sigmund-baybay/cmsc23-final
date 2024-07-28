import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friends_model.dart';
import '../providers/slambook_provider.dart';
import 'package:image_picker/image_picker.dart';

class FriendDetailPage extends StatefulWidget {
  final Friend friend;

  FriendDetailPage({required this.friend, super.key});

  @override
  State<FriendDetailPage> createState() => __FriendDetailPageState();
}

class __FriendDetailPageState extends State<FriendDetailPage>{
  File? image;
  String? pfpImage;

  @override
  void initState() {
    super.initState();
    _getProfilePic();
  }

  // Check if profile page is already existing
  Future<void> _getProfilePic() async {
    final storageRef = FirebaseStorage.instance.ref().child("pfp/${widget.friend.id}.jpg");

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

  Future<void> _uploadProfilePic(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child("pfp/${widget.friend.id}.jpg");

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
        backgroundColor: Color.fromARGB(255, 167, 146, 119),
      ),
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
 
          //Center which displays all necessary details
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 209, 187, 158),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name'),
                          Text(widget.friend.name),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nickname'),
                          Text(widget.friend.nickname),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Age'),
                          Text(widget.friend.age.toString()),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Relationship Status'),
                          Text(widget.friend.relationshipStatus),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Happiness Level'),
                          Text(widget.friend.happinessLevel.toString()),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Superpower'),
                          Text(widget.friend.superpower!),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Favorite Motto'),
                          Text(widget.friend.favoriteMotto!),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (!widget.friend.verified)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<FriendsListProvider>().deleteFriend(widget.friend);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 167, 146, 119),
                        ),
                        child: Text(
                          "Delete Entry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendsDetailsEdit(friend: widget.friend),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 167, 146, 119),
                        ),
                        child: Text(
                          "Edit Entry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 167, 146, 119),
                    ),
                    child: Text(
                      "Go back",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



//STF to edit the details of a specific friend in the friendslist
class FriendsDetailsEdit extends StatefulWidget {
  Friend friend;

  FriendsDetailsEdit({required this.friend, super.key});

  @override
  State<FriendsDetailsEdit> createState() => _FriendsDetailsEditState();
}

class _FriendsDetailsEditState extends State<FriendsDetailsEdit> {
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

  @override
  void initState(){
    super.initState();
    _nicknameController.text = widget.friend.nickname;
    _ageController.text = widget.friend.age.toString();
    _relationshipStatus = widget.friend.relationshipStatus == 'Single';
    _happinessLevel = widget.friend.happinessLevel;
    _superpower = widget.friend.superpower ?? _dropdownOptions.first;
    _favoriteMotto = widget.friend.favoriteMotto ?? _motto.first;

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

      Navigator.pop(context);
      Navigator.pushNamed(context, "/friends");

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.name,),backgroundColor: Color.fromARGB(255,167, 146, 119)),
      backgroundColor: Color.fromARGB(255,209, 187, 158),
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
                      if (int.tryParse(value) == null || int.tryParse(value)! < 1) {
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
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 167, 146, 119)),
                    child: Text('Reset', style: TextStyle(color: Colors.black),),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 167, 146, 119)),
                    child: Text('Update', style: TextStyle(color: Colors.black),),
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