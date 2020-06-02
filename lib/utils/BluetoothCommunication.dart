import 'dart:async';
import 'dart:convert';

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

  StreamController _onNewValueController = new StreamController.broadcast();

  Stream get onNewValue => _onNewValueController.stream;

  set device(BluetoothDevice device) {
    _device = device;
    _device.state.listen((newState) {
      _isReadyController.add(newState == BluetoothDeviceState.connected);
    });
    _device.discoverServices().then((services) {
      _services = services;

      _findNotifyingCharacteristics();
    });

    _onNewDeviceController.add(_device);
  }

  void _findNotifyingCharacteristics() {
    _services.forEach((service) {
      service.characteristics.forEach((c) async {
        if (c.properties.notify) {
          c.value.listen((newValue) {
            _onNewValueController.add(newValue);
          });

          await c.setNotifyValue(true);
        }
      });
    });
  }

  String getDeviceName() {
    if (_device == null) {
      return null;
    }

    return _device.name;
  }

  Stream<BluetoothDeviceState> getDeviceState() {
    if (_device == null) {
      return null;
    }

    return _device.state;
  }

  void sendData(String data) {
    var encodedData = utf8.encode(data);

    // write encodedData to all the characteristics that have write option
    // not sure if it's a good approach
    _services.forEach((service) {
      service.characteristics.forEach((c) {
        if (c.properties.write) {
          try {
            c
                .write(encodedData, withoutResponse: true)
                .catchError((error) => print("Write Error: $error"));
          } catch (e) {
            print(e);
          }
        }
      });
    });
  }
}
