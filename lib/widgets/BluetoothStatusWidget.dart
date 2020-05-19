import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothStatusWidget extends StatelessWidget {
  final BluetoothState state;

  const BluetoothStatusWidget({Key key, this.state}) : super(key: key);

  Widget _getIcon() {
    if (state == BluetoothState.on) {
      return Icon(
        Icons.bluetooth_connected,
        size: 50.0,
        color: Colors.green,
      );
    }

    return Icon(
      Icons.bluetooth_disabled,
      size: 50.0,
      color: Colors.red,
    );
  }

  String _getText() {
    if (state == BluetoothState.on) {
      return "Bluetooth Adapter is on.";
    }

    return "Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _getIcon(),
          Text(
            _getText(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
