import 'package:flutter/material.dart';

void main() {
  runApp(TabiApp());
}

class TabiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabi',
      home: Scaffold(
        appBar: AppBar(title: Text('Tabi')),
        body: Center(child: Text('Welcome to Tabi')),
      ),
    );
  }
}
