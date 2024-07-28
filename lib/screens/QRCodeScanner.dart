import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import '../models/friends_model.dart';
import '../providers/slambook_provider.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner"),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  //qr code when viewed
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _qrAddFriend(result!.code);
      });
    });
  }

  //add friend once qr code is scanned
  void _qrAddFriend(String? result) {
    if (result != null){
      try{
        final Map<String,dynamic> friendData = jsonDecode(result);
        friendData['verified'] = true;
        
        final newFriend = Friend.fromJson(friendData);

        context.read<FriendsListProvider>().addFriend(newFriend); 

        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, "/slambook", ModalRoute.withName('/slambook'));
        
      } on FirebaseException catch (e){
        "Failed with error: ${e.code}";
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  
}