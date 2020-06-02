import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  TextEditingController _writeController = TextEditingController();

  Widget _buildDataInputWidget() {
    return Container(
      color: Colors.blueGrey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: TextField(
                controller: _writeController,
                style: TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "Data to send",
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => _writeController.clear(),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.white,
            onPressed: () => BluetoothCommunication.instance
                .sendData(_writeController.text.toString()),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Communication Page"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text("Commsasd"), _buildDataInputWidget()],
        ));
  }
}
