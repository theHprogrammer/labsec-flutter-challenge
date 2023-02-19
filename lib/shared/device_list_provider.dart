// Descrição: Provider para gerenciar a lista de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 16/02/2023
//

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesListProvider extends ChangeNotifier {
  final List<BluetoothDevice> _devicesList = <BluetoothDevice>[];

  List<BluetoothDevice> get devices => _devicesList;

  void updateDevicesList(List<BluetoothDevice> list) {
    _devicesList.addAll(list);
    notifyListeners();
  }

  // Converter a List<BluetoothDevice> para JSON.
  List<Map<String, dynamic>> toJson(final List<BluetoothDevice> devices) {
    return devices
        .map((device) => {
              // Se o nome do dispositivo BLE for vazio, apresenta "Unknown device (Dispositivo desconhecido)", caso contrário, apresenta o nome do dispositivo BLE.
              'name': device.name.isEmpty ? 'Unknown device' : device.name,
              'id': device.id.toString(),
            })
        .toList();
  }
}
