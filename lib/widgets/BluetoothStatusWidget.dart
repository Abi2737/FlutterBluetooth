import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';

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

  String _getBluetoothAdapterStatus() {
    return "Bluetooth Adapter is ${state != null ? state.toString().split(".")[1] : 'not available'}.";
  }

  Widget _getSelectedDeviceStatus(BuildContext context) {
    if (state != BluetoothState.on) {
      return SizedBox.shrink();
    }

    String selectedDeviceName = BluetoothCommunication.instance.getDeviceName();

    if (selectedDeviceName == null) {
      return Text(
        "No device selected.",
        style: Theme.of(context)
            .primaryTextTheme
            .subtitle1
            .copyWith(color: Colors.black),
      );
    }

    return StreamBuilder<BluetoothDeviceState>(
      stream: BluetoothCommunication.instance.getDeviceState(),
      initialData: BluetoothDeviceState.connecting,
      builder: (c, snapshot) => Text(
        "Selected $selectedDeviceName is ${snapshot.data.toString().split('.')[1]}.",
        style: Theme.of(context)
            .primaryTextTheme
            .subtitle1
            .copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _getIcon(),
          Text(
            _getBluetoothAdapterStatus(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(color: Colors.black),
          ),
          _getSelectedDeviceStatus(context)
        ],
      ),
    );
  }
}
