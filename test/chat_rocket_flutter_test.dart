import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_rocket_flutter/chat_rocket_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatWidget',
      debugShowCheckedModeBanner: false,
      home: WidgetChat(
        url: "https://carajas.rocket.chat",
        urlLogo: "assets/new_logo.png",
        urlSound: "https://carjas-s3-travel.s3.amazonaws.com/sac"
            "/assets/new_mensage.mp3",
        iconsColor: Colors.orange[600],
        baseColor: Colors.orange[600],
        audioColor: Colors.orange,
        textColor: Colors.black,
        onClose: (CallbackData data) async {
          //return await _dialogClosing(data);
        },
      ),
    );
  }
}
