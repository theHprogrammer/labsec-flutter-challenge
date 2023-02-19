// Descrição: Caixa para listagem de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 12/02/2023
//
// Tipo: Widget
//
//  Parametros:
//  dateTime: Data e hora da última atualização da lista de dispositivos BLE. (String)
//  listBle: Lista de dispositivos BLE. (List<BluetoothDevice>)
//
// Detalhes:
// 1. Uso de media query para definir o tamanho da fonte de acordo com o tamanho da tela.
// 2. Uso de list view para exibir a lista de dispositivos BLE.
// 3. Uso de scroll view para permitir que a lista de dispositivos BLE seja rolada.
//

// Importações.
import 'package:flutter/material.dart';

class BleListBox extends StatelessWidget {
  // Construtor constante.
  const BleListBox({
    Key? key,
    required this.dateTime,
    required this.devicesList,
    required this.deviceScan,
  }) : super(key: key);

  // Atributos.
  final String dateTime;
  // name:
  // id:
  final List<Map<String, dynamic>> devicesList;
  final String? deviceScan;

  // Função para o que vai aparecer no device scan.
  // Se o device scan for nulo ou vazio, então exibe Dispositivos: "N/A".
  // Se não for nulo ou vazio, exibe "Dispositivos:" pula uma linha e exibe os dispositivos escaneados."
  String _deviceScan() {
    if (deviceScan == null || deviceScan == '') {
      return 'Dispositivos: N/A';
    } else {
      return deviceScan!;
    }
  }

  // Método build.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Última atualização: $dateTime',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                _deviceScan(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      devicesList[index]['name'],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    subtitle: Text(
                      devicesList[index]['id'],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
