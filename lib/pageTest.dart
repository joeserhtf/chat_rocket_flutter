import 'package:flutter/material.dart';

import 'chat.dart';

class PageTest extends StatefulWidget {
  @override
  _PageTestState createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: RaisedButton(
          child: Text("Enviaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PageTest(),
              ),
            );
          },
        ),
      ),
      floatingActionButton: WidgetChat(
        url: "https://carajas.rocket.chat",
        urlLogo: "https://carajas.rocket.chat/images/logo/logo.svg",
        urlSound: "https://carjas-s3-travel.s3.amazonaws.com/sac"
            "/assets/new_mensage.mp3",
        iconsColor: Colors.orange[600],
        baseColor: Colors.orange[600],
        audioColor: Colors.orange,
        textColor: Colors.black,
        options: [
          ChatOption(
              name: "Test",
              function: (a) {
                print(a);
              }),
        ],
        onTransfer: (a){
          print('as');
        },
      ),
    );
  }
}
