import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_mini_project/widgets/drawer.dart';
import 'QRCodeScanner.dart';
import '../models/friends_model.dart';

import 'package:provider/provider.dart';
import '../providers/slambook_provider.dart';
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
      _happinessLevel = 0.0;
      _superpower = _dropdownOptions.first;
      _favoriteMotto = _motto.first;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String uid = context.read<UserAuthProvider>().uid;
      print(uid);

      String name = _nameController.text;
      Friend newFriend = 
      Friend(name: name, 
      nickname: _nicknameController.text, 
      age: int.parse(_ageController.text), 
      relationshipStatus: _relationshipStatus ? "Single" : "Not Single", 
      happinessLevel: _happinessLevel, 
      superpower: _superpower, 
      favoriteMotto: _favoriteMotto,
      verified: false,
      uid: uid);

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
      //Floatting button to scan qr code
      floatingActionButton: FloatingActionButton(onPressed: (){
        _scanQRCode(context);
      }, child: Icon(Icons.qr_code),
      backgroundColor: Color.fromARGB(255, 167, 146, 119),),
      appBar: AppBar(title: Text('Slambook',style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255,167, 146, 119)),
      backgroundColor: Color.fromARGB(255,209, 187, 158),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //Form for friend details
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
                      if (int.tryParse(value) == null || int.tryParse(value)! < 0) {
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
                    child: Text('Submit', style: TextStyle(color: Colors.black),),
                  ),
                ],
              )),

              //Checks if theres a submitted user, prints the summary
              _submittedFriend != null ?
              summary(_submittedFriend!)
              : Container(),
            ],
          ),
        ),
      ),
    );
  }

  //summary of details presented once submitted to the friendsList
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
          Text('${newFriend.favoriteMotto}')

        ],),
      ],
      ),
    );
    
  }

}

void _scanQRCode(context) {
  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRCodeScanner(),
          ),
        );
}