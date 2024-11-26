import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothControlStateProvider with ChangeNotifier {
  bool _isBluetooth = false;
  BluetoothDevice? _selectedDevice;


  bool get isBluetooth => _isBluetooth;
  BluetoothDevice? get selectedDevice => _selectedDevice;

  void setIsBluetooth(bool newValue) {
    _isBluetooth = newValue;
    notifyListeners();
  }

  void setSelectedDevice(BluetoothDevice device) {
    _selectedDevice = device;
    notifyListeners();
  }

}