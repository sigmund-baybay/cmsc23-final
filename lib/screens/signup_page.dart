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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [heading, nameField, usernameField, emailField, passwordField, ...contactFields(), addContactButton, submitButton],
              ),
            )),
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
            if (value == null || value.isEmpty) {
              return "Please enter a valid username";
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
          child: const Text("Add Contact Number"),
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
      child: const Text("Sign Up"));
}
