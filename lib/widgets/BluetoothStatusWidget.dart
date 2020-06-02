import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothStatusWidget extends StatefulWidget {
  final BluetoothState state;
  final String deviceName;
  final Stream<BluetoothDeviceState> deviceState;

  const BluetoothStatusWidget(
      {Key key, this.state, this.deviceName, this.deviceState})
      : super(key: key);

  @override
  _BluetoothStatusWidgetState createState() => _BluetoothStatusWidgetState();
}

class _BluetoothStatusWidgetState extends State<BluetoothStatusWidget> {
  BluetoothDeviceState _deviceState = BluetoothDeviceState.connecting;

  @override
  void initState() {
    super.initState();

    widget.deviceState.listen((newState) {
      if (newState != _deviceState) {
        _deviceState = newState;
        _refresh();
      }
    });
  }

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  Widget _getIcon() {
    if (widget.state == BluetoothState.on) {
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
    return "Bluetooth Adapter is ${widget.state != null ? widget.state.toString().split(".")[1] : 'not available'}.";
  }

  String _getSelectedDeviceStatus() {
    if (widget.deviceName == null) {
      return "No device selected.";
    }

    return "Selected ${widget.deviceName} is ${_deviceState.toString().split('.')[1]}.";
  }

  Widget _getSelectedDeviceStatusWidget(BuildContext context) {
    if (widget.state != BluetoothState.on) {
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
          _getSelectedDeviceStatusWidget(context)
        ],
      ),
    );
  }
}
