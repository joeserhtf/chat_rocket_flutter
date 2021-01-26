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
        url: "",
        urlLogo: "",
        urlSound: "",
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
      ),
    );
  }
}
