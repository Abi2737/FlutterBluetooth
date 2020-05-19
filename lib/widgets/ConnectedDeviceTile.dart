import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDeviceTile extends StatelessWidget {
  final BluetoothDevice device;
  final VoidCallback onTap;

  const ConnectedDeviceTile({Key key, this.device, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id.toString()),
      trailing: StreamBuilder<BluetoothDeviceState>(
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            return RaisedButton(
              child: Text("OPEN"),
              onPressed: onTap,
            );
          }

          return Text(snapshot.data.toString());
        },
      ),
    );
  }
}
