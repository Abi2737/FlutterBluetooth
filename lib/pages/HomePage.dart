import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/widgets/BluetoothStatusWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          return _createHomePage(context, snapshot.data);
        },
      ),
    );
  }

  Widget _createHomePage(BuildContext context, BluetoothState state) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          BluetoothStatusWidget(state: state),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: state != BluetoothState.on ? null : () {
                      Navigator.pushNamed(context, "/find_devices");
                    },
                    child: const Text('Find devices'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
