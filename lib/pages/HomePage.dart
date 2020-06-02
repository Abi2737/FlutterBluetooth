import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/pages/CommunicationPage.dart';
import 'package:flutterbluetoooth/pages/FindDevicesPage.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';
import 'package:flutterbluetoooth/widgets/BluetoothCommunicationStatusWidget.dart';
import 'package:flutterbluetoooth/widgets/BluetoothStatusWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCommunicationReady = false;
  BluetoothState _bluetootState = BluetoothState.unknown;

  @override
  void initState() {
    super.initState();

    FlutterBlue.instance.state.listen((newState) {
      if (newState != _bluetootState) {
        _bluetootState = newState;
        _refresh();
      }
    });

    BluetoothCommunication.instance.onNewDevice.listen((_) => _refresh());

    BluetoothCommunication.instance.isReady.listen((isReady) {
      if (isReady != _isCommunicationReady) {
        _isCommunicationReady = isReady;
        _refresh();
      }
    });
  }

  void _refresh() {
    if (this.mounted) {
      print("REFRESHHHHHHH");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          BluetoothStatusWidget(state: _bluetootState),
          BluetoothCommunicationStatusWidget(bluetoothState: _bluetootState),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Find devices'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _bluetootState != BluetoothState.on
                        ? null
                        : () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FindDevicesPage()));
                    },
                  ),
                  RaisedButton(
                    child: const Text('Communication Page'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: !_isCommunicationReady
                        ? null
                        : () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CommunicationPage()));
                    },
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
