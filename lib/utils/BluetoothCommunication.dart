import 'package:flutter_blue/flutter_blue.dart';

class BluetoothCommunication{
  BluetoothCommunication._privateConstructor();

  static final BluetoothCommunication _instance = BluetoothCommunication._privateConstructor();

  static BluetoothCommunication get instance => _instance;

  BluetoothDevice _device;

  set device(BluetoothDevice device) {
    _device = device;
  }
}