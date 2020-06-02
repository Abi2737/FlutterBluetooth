import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothCommunication {
  BluetoothCommunication._privateConstructor();

  static final BluetoothCommunication _instance =
      BluetoothCommunication._privateConstructor();

  static BluetoothCommunication get instance => _instance;

  BluetoothDevice _device;
  BluetoothDeviceState _state;
  List<BluetoothService> _services;

  StreamController _onNewDeviceController = new StreamController.broadcast();
  Stream get onNewDevice => _onNewDeviceController.stream;

  StreamController _isReadyController = new StreamController.broadcast();
  Stream get isReady => _isReadyController.stream;

  set device(BluetoothDevice device) {
    _device = device;
    _device.state.listen((newState) {
      _isReadyController.add(newState == BluetoothDeviceState.connected);
    });
    _device.discoverServices().then((services) => _services = services);

    _onNewDeviceController.add(_device);
  }

  String getDeviceName() {
    if (_device == null) {
      return null;
    }

    return _device.name;
  }

  Stream<BluetoothDeviceState> getDeviceState() {
    return _device.state;
  }
}
