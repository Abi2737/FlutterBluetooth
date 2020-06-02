import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Communication Page"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Comms"),
        )
    );
  }
}
