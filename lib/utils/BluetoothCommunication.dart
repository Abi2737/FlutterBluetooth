import 'package:flutter_blue/flutter_blue.dart';

class BluetoothCommunication{
  BluetoothCommunication._privateConstructor();

  static final BluetoothCommunication _instance = BluetoothCommunication._privateConstructor();

  static BluetoothCommunication get instance => _instance;

  BluetoothDevice _device;
  List<BluetoothService> _services;

  set device(BluetoothDevice device) {
    _device = device;
    _device.discoverServices().then((services) => _services = services);
  }
}