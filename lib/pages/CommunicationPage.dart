import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';

class OutputData {
  String data;
  int numOfAppearances;

  OutputData(String data) {
    this.data = data;
    this.numOfAppearances = 1;
  }

  void increase() {
    numOfAppearances++;
  }
}

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  TextEditingController _writeController = TextEditingController();
  List<OutputData> _deviceOutputs = List();
  ScrollController _scrollController = ScrollController();
  List<StreamSubscription> _streamSubscriptions = List();

  bool _enableAutoScroll = true;

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(
      BluetoothCommunication.instance.onNewValue.listen(
        (newValue) {
          print(
              "NEW bluetooth value: ${newValue.toString()} -> ${String.fromCharCodes(newValue)}");

          var decodedValue = String.fromCharCodes(newValue);

          if (_deviceOutputs.length > 0 &&
              _deviceOutputs.last.data == decodedValue) {
            _deviceOutputs.last.increase();
          } else {
            _deviceOutputs.add(OutputData(decodedValue));
          }

          _refresh();
        },
      ),
    );
  }

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  _scrollToBottom() {
    if (!_enableAutoScroll) {
      return;
    }

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget _buildDeviceOutputWidget(int index) {
    return ListTile(
      title: Text(_deviceOutputs[index].data),
      leading: Text(_deviceOutputs[index].numOfAppearances > 1
          ? _deviceOutputs[index].numOfAppearances.toString()
          : ""),
      trailing: Text(index.toString()),
      dense: true,
    );
  }

  Widget _buildDataOutputWidget() {
    return Container(
      color: Colors.grey,
      height: 300,
      child: ListView.builder(
        itemCount: _deviceOutputs.length,
        itemBuilder: (_, index) => _buildDeviceOutputWidget(index),
        controller: _scrollController,
        shrinkWrap: true,
      ),
    );
  }

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text("Communication Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: <Widget>[
              _buildDataOutputWidget(),
              _buildDataInputWidget(),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: RaisedButton(
                  child: Text(_enableAutoScroll
                      ? "Pause auto scroll"
                      : "Resume auto scroll"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    _enableAutoScroll = !_enableAutoScroll;
                    _refresh();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _streamSubscriptions.forEach((subscription) => subscription.cancel());
  }
}
