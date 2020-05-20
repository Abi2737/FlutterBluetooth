import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterbluetoooth/pages/DevicePage.dart';
import 'package:flutterbluetoooth/widgets/ConnectedDeviceTile.dart';
import 'package:flutterbluetoooth/widgets/ScanResultTile.dart';

const int SCAN_TIME = 4;

class FindDevicesPage extends StatefulWidget {
  @override
  _FindDevicesPageState createState() => _FindDevicesPageState();
}

class _FindDevicesPageState extends State<FindDevicesPage> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  final Set<BluetoothDevice> _connectedDevices = Set();
  final Set<ScanResult> _scanResults = Set();

  bool _isScanning = false;

  void _refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  void _addConnectedDevices(List<BluetoothDevice> devices) {
    print("SIZE: ${devices.length} -> $devices");
    bool shouldRefresh = false;

    for (BluetoothDevice device in devices) {
      shouldRefresh = shouldRefresh || _connectedDevices.add(device);
    }

    if (shouldRefresh) {
      _refresh();
    }
  }

  void _addConnectedDevice(BluetoothDevice device) {
    bool shouldRefresh = _connectedDevices.add(device);

    if (shouldRefresh) {
      _refresh();
    }
  }

  void _addScanResults(List<ScanResult> results) {
    bool shouldRefresh = false;

    for (ScanResult result in results) {
      shouldRefresh = shouldRefresh || _scanResults.add(result);
    }

    if (shouldRefresh) {
      _refresh();
    }
  }

  void _onScanningEvent(bool isScanning) {
    if (_isScanning == isScanning) {
      return;
    }

    _isScanning = isScanning;
    _refresh();
  }

  void _startScan() {
    _isScanning = true;
    _scanResults.clear();
    _flutterBlue.startScan(timeout: Duration(seconds: SCAN_TIME));
  }

  @override
  void initState() {
    super.initState();

    // add connected devices
    _flutterBlue.connectedDevices.asStream().listen(_addConnectedDevices);

    // add scanning results
    _flutterBlue.scanResults.listen(_addScanResults);

    // listen for scanning event
    _flutterBlue.isScanning.listen(_onScanningEvent);

    // start scanning
    _startScan();
  }

  List<Widget> _buildListViewOfConnectedDevices() {
    List<ConnectedDeviceTile> result = List();

    for (BluetoothDevice device in _connectedDevices) {
      result.add(ConnectedDeviceTile(
          device: device,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DevicePage(device: device)));
          }));
    }

    return result;
  }

  List<Widget> _buildListViewOfScannedDevices() {
    List<ScanResultTile> result = List();

    for (ScanResult scanResult in _scanResults) {
      result.add(ScanResultTile(
        result: scanResult,
        onTap: () {
          scanResult.device
              .connect()
              .then((_) => _addConnectedDevice(scanResult.device));
        },
      ));
    }

    return result;
  }

  FloatingActionButton _buildFloatingActionButton() {
    if (_isScanning) {
      return FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: () => _flutterBlue.stopScan(),
        backgroundColor: Colors.red,
      );
    }

    return FloatingActionButton(
      child: Icon(Icons.search),
      onPressed: () => _startScan(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find devices"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Column(children: _buildListViewOfConnectedDevices()),
                Column(children: _buildListViewOfScannedDevices()),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: _isScanning,
              child: SpinKitPulse(
                color: Colors.blue,
                size: 300,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
