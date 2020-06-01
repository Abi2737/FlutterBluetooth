import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onSelect;
  final VoidCallback onOpen;
  final VoidCallback onDisconnect;

  const ConnectedDeviceTile(
      {Key key, this.device, this.onSelect, this.onOpen, this.onDisconnect})
      : super(key: key);

  @override
  _ConnectedDeviceTileState createState() => _ConnectedDeviceTileState();
}

class _ConnectedDeviceTileState extends State<ConnectedDeviceTile> {
  BluetoothDeviceState _deviceState;

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  String _getDeviceStateString() {
    return _deviceState.toString().split('.')[1];
  }

  @override
  void initState() {
    super.initState();

    _deviceState = BluetoothDeviceState.disconnected;

    widget.device.state.listen((newState) {
      if (_deviceState == newState) {
        return;
      }

      _deviceState = newState;
      _refresh();
    });
  }

  Widget _buildTrailing() {
    if (_deviceState == BluetoothDeviceState.connected) {
      return RaisedButton(
        child: Text("SELECT"),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: widget.onSelect,
      );
    }

    return Text(_getDeviceStateString());
  }

  Widget _buildAdvancedButtons() {
    Widget secondWidget;
    if (_deviceState == BluetoothDeviceState.connected) {
      secondWidget = RaisedButton(
        child: Text("OPEN"),
        textColor: Colors.white,
        color: Colors.green[300],
        onPressed: widget.onOpen,
      );
    } else {
      secondWidget = Text("Device is ${_getDeviceStateString()}");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text("DISCONNECT"),
            color: Colors.red[300],
            textColor: Colors.white,
            onPressed: widget.onDisconnect,
          ),
          secondWidget
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.device.name),
      subtitle: Text(widget.device.id.toString()),
      trailing: _buildTrailing(),
      children: <Widget>[_buildAdvancedButtons()],
    );
  }
}
