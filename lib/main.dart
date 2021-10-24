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
        url: "https://carajas.rocket.chat",
        urlLogo: "https://carajas.rocket.chat/images/logo/logo.svg",
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
