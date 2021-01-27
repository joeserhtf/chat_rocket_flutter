
import 'package:flutter/material.dart';

import 'chat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatWidget',
      debugShowCheckedModeBanner: false,
      home: WidgetChat(
        url: "",
        urlLogo: "",
        urlSound: "",
        iconsColor: Colors.orange[600],
        baseColor: Colors.orange[600],
        audioColor: Colors.orange,
        textColor: Colors.black,
        options: [
          ChatOption(name: "Test", function: (a) {}),
        ],
        onTransfer: (a) {
          print('as');
        },
      ),
    );
  }
}
