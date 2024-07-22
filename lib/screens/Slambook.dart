import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_exr4/models/friends_model.dart';
import 'package:flutter_app_exr4/providers/slambook_provider.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class Slambook extends StatefulWidget {

  Slambook({super.key});

  @override
  _SlambookState createState() => _SlambookState();
}

class _SlambookState extends State<Slambook> {
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _relationshipStatus = false;
  double _happinessLevel = 0;
  String _superpower = _dropdownOptions.first;
  String _favoriteMotto = _motto.first;

  Friend?_submittedFriend;

  
  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
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
      String name = _nameController.text;

      // bool exists = context.read<FriendsListProvider>().checkExistingName(name);

      // if(exists){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Name already exists')));
      //     _resetForm();
      //     return;
      // }

      Friend newFriend = 
      Friend(name: name, 
      nickname: _nicknameController.text, 
      age: int.parse(_ageController.text), 
      relationshipStatus: _relationshipStatus ? "Single" : "Not Single", 
      happinessLevel: _happinessLevel, 
      superpower: _superpower, 
      favoriteMoto: _favoriteMotto);

      setState(() {
        context.read<FriendsListProvider>().addFriend(newFriend);
        _submittedFriend = newFriend;
      });
      

      print(newFriend.name);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slambook',style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255,14,14,66)),
      backgroundColor: Color.fromARGB(255, 195,211,235),
      drawer: drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: Text("My Friends' Slambook", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
              ),

              Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )),

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
                    child: Text('Submit'),
                  ),
                ],
              )),

              _submittedFriend != null ?
              summary(_submittedFriend!)
              : Container(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget drawer() {
    return Drawer(
      child: ListView(
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
            onTap: () async {
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

  Widget summary(Friend newFriend) {
    return Container(
    
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Divider(
              thickness: 3,
              color: Colors.indigoAccent,
            ),

        Center(child: Text("Summary", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Name'),
          Text('${newFriend.name}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Nickname'),
          Text('${newFriend.nickname}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Age'),
          Text('${newFriend.age}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Relationship Status'),
          Text('${newFriend.relationshipStatus}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Happiness Level'),
          Text('${newFriend.happinessLevel}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Superpower'),
          Text('${newFriend.superpower}')

        ],),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Favorite Motto'),
          Text('${newFriend.favoriteMoto}')

        ],),
      ],
      ),
    );
    
  }

}