import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? username;
  String? email;
  String? password;
  List<String>? contactNumbers = [''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 209, 187, 158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      heading,
                      nameField,
                      usernameField,
                      emailField,
                      passwordField,
                      ...contactFields(),
                      addContactButton,
                      submitButton,
                      signInButton
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Name"),
              hintText: "Enter a valid name"),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid  name";
            }
            return null;
          },
        ),
      );

  Widget get usernameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Username"),
              hintText: "Enter a valid username"),
          onSaved: (value) => setState(() => username = value),
          validator: (value) {
            final exist = context.read<UserAuthProvider>().authService.existingName(value);
            if (value == null || value.isEmpty) {
              return "Please enter a valid username or username is in use";
            }
            return null;
          },
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "Enter a valid email"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid email format";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "At least 8 characters"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            }
            return null;
          },
        ),
      );

  List<Widget> contactFields() {
    return contactNumbers!.asMap().entries.map((entry) {
      int index = entry.key;
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Contact No."),
                    hintText: "Enter a valid contact number"),
                onSaved: (value) => contactNumbers?[index] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid contact number";
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  contactNumbers!.removeAt(index);
                });
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget get addContactButton => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              contactNumbers!.add('');
            });
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 167, 146, 119)
        ),
          child: const Text("Add Contact Number", style: TextStyle(color: Colors.black),),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!, name!, username!, contactNumbers!);

          // check if the widget hasn't been disposed of after an asynchronous action
          if (mounted) Navigator.pop(context);
        }
        
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 167, 146, 119)
        ),
      child: const Text("Sign Up", style: TextStyle(color: Colors.black),));

  Widget get signInButton => Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Have an accout?"),
            TextButton(
                onPressed: () {
                  Navigator.pop(
                      context);
                },
                child: const Text("Sign In", style: TextStyle(color: Color.fromARGB(255, 167, 146, 119)),))
          ],
        ),
      );
}
