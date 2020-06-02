import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/pages/FindDevicesPage.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';
import 'package:flutterbluetoooth/widgets/BluetoothStatusWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    BluetoothCommunication.instance.onNewDevice.listen((_) => _refresh());
  }

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
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
                    child: const Text('Find devices'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: state != BluetoothState.on
                        ? null
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FindDevicesPage()));
                          },
                  ),
                  RaisedButton(
                    child: const Text('Send data'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: state != BluetoothState.on
                        ? null
                        : () {
//                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendData()))
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
}
