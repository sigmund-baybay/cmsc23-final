import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

import '../providers/auth_provider.dart';

class QRCodePage extends StatefulWidget {
  QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    var user = context.read<UserAuthProvider>().user!.uid;
    final details = context.read<UserAuthProvider>().getUserDetails(user);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: details,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(child: Text("No details available")),
          );
        }

        var details = snapshot.data!.data()!;
        String data = generateQRData(details);

        return Material(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 280,
                        child: QrImageView(
                          data: data,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                        .copyWith(bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(data),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go back"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String generateQRData(Map<String, dynamic> details) {
    String name = details['name'] ?? '';
    String nickname = details['nickname'] ?? '';
    int age = details['age'] ?? 0;
    String relationshipStatus = details['relationshipStatus'] ?? '';
    double happinessLevel = details[''] ?? 0.0;
    String superpower = details['superpower'] ?? '';
    String favoriteMoto = details['favoriteMoto'] ?? '';

    return jsonEncode({
      'name': name,
      'nickname': nickname,
      'age': age,
      'relationshipStatus': relationshipStatus,
      'happinessLevel': happinessLevel,
      'superpower': superpower,
      'favoriteMoto': favoriteMoto,
    });
  }
}
