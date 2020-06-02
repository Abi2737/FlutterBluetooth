import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/utils/BluetoothCommunication.dart';

class BluetoothCommunicationStatusWidget extends StatefulWidget {
  final BluetoothState bluetoothState;

  const BluetoothCommunicationStatusWidget({Key key, this.bluetoothState})
      : super(key: key);

  @override
  _BluetoothCommunicationStatusWidgetState createState() =>
      _BluetoothCommunicationStatusWidgetState();
}

class _BluetoothCommunicationStatusWidgetState
    extends State<BluetoothCommunicationStatusWidget> {
  var _deviceState = BluetoothDeviceState.connecting;

  @override
  void initState() {
    super.initState();

    BluetoothCommunication.instance.onNewDevice
        .listen((_) => _listenDeviceState());

    _listenDeviceState();
  }

  void _listenDeviceState() {
    var deviceState = BluetoothCommunication.instance.getDeviceState();

    if (deviceState != null) {
      deviceState.listen((newState) {
        if (newState != _deviceState) {
          _deviceState = newState;
          _refresh();
        }
      });
    }
  }

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  String _getSelectedDeviceStatus() {
    var deviceName = BluetoothCommunication.instance.getDeviceName();

    if (deviceName == null) {
      return "No device selected.";
    }

    return "Selected $deviceName is ${_deviceState.toString().split('.')[1]}.";
  }

  Widget _getSelectedDeviceStatusWidget(BuildContext context) {
    if (widget.bluetoothState != BluetoothState.on) {
      return SizedBox.shrink();
    }

    return Text(
      _getSelectedDeviceStatus(),
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getSelectedDeviceStatusWidget(context);
  }
}
