import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterbluetoooth/widgets/ConnectedDeviceTile.dart';
import 'package:flutterbluetoooth/widgets/ScanResultTile.dart';

class FindDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find devices"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((event) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data
                      .map((device) => ConnectedDeviceTile(
                            device: device,
                            onTap: () {
                              print("aaaaaaa");
                            },
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data
                      .map((result) => ScanResultTile(
                            result: result,
                            onTap: () {
                              print("bbbbbbbb");
                            },
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          }

          return FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () =>
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
          );
        },
      ),
    );
  }
}
