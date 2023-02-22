// Descrição: Provider para gerenciar a lista de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 16/02/2023
//

import 'package:flutter/foundation.dart';

import 'package:flutter_blue/flutter_blue.dart';

class DevicesListProvider extends ChangeNotifier {
  // Lista de dispositivos BLE.
  List<BluetoothDevice> _devicesList = [];

  // Lista de nomes dos dispositivos BLE.
  List<String?> _nameDevices = [];

  // Lista de IDs dos dispositivos BLE.
  List<String?> _idDevices = [];

  // Getters.
  List<BluetoothDevice> get devicesList => _devicesList;
  List<String?> get nameDevices => _nameDevices;
  List<String?> get idDevices => _idDevices;

  void updateDevicesList(List<BluetoothDevice> list) {
    _devicesList = list;
    notifyListeners();
  }

  void updateNameDevices(List<String?> list) {
    _nameDevices = list;
    notifyListeners();
  }

  void updateIdDevices(List<String?> list) {
    _idDevices = list;
    notifyListeners();
  }

  // Método toJson.
  // Converte as Lists nameDevices e idDevices para JSON.
  List<Map<String, String>> toJson(
      List<String?> nameDevices, List<String?> idDevices) {
    final List<Map<String, String>> jsonList = [];
    for (int i = 0; i < nameDevices.length; i++) {
      if (nameDevices[i] == null) {
        jsonList.add({'name': 'Unknow device', 'id': idDevices[i]!});
      } else {
        jsonList.add({'name': nameDevices[i]!, 'id': idDevices[i]!});
      }
    }
    return jsonList;
  }


}
