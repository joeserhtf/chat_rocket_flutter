import 'package:chat_rocket_flutter/chat.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatWidget',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        floatingActionButton: WidgetChat(
          url: "https://carajas.rocket.chat",
        ),
      ),
    );
  }
}
