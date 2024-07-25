import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/screens/QRCodePage.dart';
import 'package:provider/provider.dart';
import '../models/friends_model.dart';
import '../providers/slambook_provider.dart';
import 'package:image_picker/image_picker.dart';

class FriendDetailPage extends StatelessWidget {
  Friend friend;

  FriendDetailPage({required this.friend, super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(friend.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Text("Summary", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Name'),
              Text(friend.name)

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Nickname'),
              Text(friend.nickname)

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Age'),
              Text(friend.age.toString())

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Relationship Status'),
              Text(friend.relationshipStatus)

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Happiness Level'),
              Text(friend.happinessLevel.toString())

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Superpower'),
              Text(friend.superpower!)

            ],),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Favorite Motto'),
              Text(friend.favoriteMoto!)

            ],),
            SizedBox(height: 20),
            Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  context.read<FriendsListProvider>().deleteFriend(friend);
                  Navigator.pop(context);
                }, child: Text("Delete Entry"),
                ),

                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendsDetailsEdit(friend: friend,),
                    ),
                  );
                }, child: Text("Edit Entry"),
                ),

              ],),
            
            ),
            SizedBox(height: 8),
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

      context.read<FriendsListProvider>().editedProfile(widget.friend, nickname, age, relationshipStatus, _happinessLevel, _superpower, _favoriteMotto);

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