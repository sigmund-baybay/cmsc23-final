import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/friends_model.dart';
import '../providers/auth_provider.dart';
import '../providers/slambook_provider.dart';

class ProfilePageEdit extends StatefulWidget {
    Friend profile;

    ProfilePageEdit({super.key, required this.profile});

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  File? imageFile;
  String? pfpImage;

  Future<void> _uploadFile() async {
    var user = context.read<UserAuthProvider>().user!.uid;

    final ref = FirebaseStorage.instance.ref().child('pfp/$user.jpg');

    try{
      final pfpImage = await ref.getDownloadURL();

    }catch (e){
      setState(() {
        pfpImage = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image == null ? null : File(image.path);
    });
  }
  
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
    _nicknameController.text = widget.profile.nickname;
    _ageController.text = widget.profile.age.toString();
    _relationshipStatus = widget.profile.relationshipStatus == 'Single';
    _happinessLevel = widget.profile.happinessLevel;
    _superpower = widget.profile.superpower ?? _dropdownOptions.first;
    _favoriteMotto = widget.profile.favoriteMotto ?? _motto.first;

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
      
      widget.profile.id = context.read<UserAuthProvider>().user!.uid;

      context.read<FriendsListProvider>().editedProfile(widget.profile, nickname, age, relationshipStatus, _happinessLevel, _superpower, _favoriteMotto);

      print(widget.profile.name);

      Navigator.pop(context);
      Navigator.pushNamed(context, "/profile");

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.profile.name,),
      backgroundColor: Color.fromARGB(255,167, 146, 119)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                
                  pfpImage == null
                        ? ClipOval(child: Image.asset("assets/temp_pfp.jpg", width: 75, height: 75, fit: BoxFit.cover,))
                        : ClipOval(child: Image.network(pfpImage!, width: 75, height: 75, fit: BoxFit.cover,)
                        ,),
                ],
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
                      if (int.tryParse(value) == null || int .tryParse(value)! < 1) {
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