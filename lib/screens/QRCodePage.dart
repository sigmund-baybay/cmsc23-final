import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:convert';

import '../providers/auth_provider.dart';

class QRCodePage extends StatefulWidget {
  QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  ScreenshotController screenshotController = ScreenshotController();

  //Capture and save image to gallery
  Future<void> captureAndSaveImage() async {
    final Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      final result = await ImageGallerySaver.saveImage(uint8list);

    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<UserAuthProvider>().user!.uid;
    final details = context.read<UserAuthProvider>().getUserDetails(user);

    //Future builder 
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

        //Get slambook details
        var details = snapshot.data!.data()!;
        String data = generateQRData(details);
        final nickname = details['nickname'] ?? '';
        print(data);

        if(nickname == ""){
          Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("No Slambook details added yet."),
              duration:
                  const Duration(seconds: 1, milliseconds: 100),
            ));

        }

        //Main scaffold for QR code
        return Scaffold(
          appBar: AppBar(
            title: Text("QR Code"),
            backgroundColor: Color.fromARGB(255, 167, 146, 119),
          ),
          backgroundColor: Color.fromARGB(255, 209, 187, 158),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: QrImageView(
                    backgroundColor: Colors.white,
                    data: data,
                    version: QrVersions.auto,
                    size: 320,
                  ),
                ),

                //Buttons to return or save QR code as image
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go back"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 167, 146, 119),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await captureAndSaveImage();
                      },
                      child: Text("Save QR Code"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 167, 146, 119),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Function to generate the QR data using a map
  String generateQRData(Map<String, dynamic> details) {
    String name = details['name'] ?? '';
    String nickname = details['nickname'] ?? '';
    int age = details['age'] ?? 0;
    String relationshipStatus = details['relationshipStatus'] ?? '';
    double happinessLevel = details['happinessLevel'] != null ? details['happinessLevel'].toDouble() : 0.0;
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
