//background_screen.dart
import 'package:flutter/material.dart';

class WhiteBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Change the background color to white
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('White Background Screen')),
      body: Center(
        child: Text(
          'This screen has a white background!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
