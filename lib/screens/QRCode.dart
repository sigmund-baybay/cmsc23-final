import 'package:flutter/material.dart';
import 'package:flutter_app_mini_project/models/friends_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  final Friend friend;
  QRCodePage({super.key, required this.friend});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  

  @override
  Widget build(BuildContext context) {
    String data = generateQRData();

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
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
                ],) 
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String generateQRData() {
    return '''
      ${widget.friend.name}
      ${widget.friend.nickname}
      ${widget.friend.age}
      ${widget.friend.relationshipStatus}
      ${widget.friend.happinessLevel}
      ${widget.friend.superpower}
      ${widget.friend.favoriteMoto}
    ''';

  }
} 