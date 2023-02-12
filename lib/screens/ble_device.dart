// Descrição: Tela de listagem de dispositivos BLE (Bluetooth Low Energy).
// Autor: Helder Henrique da Silva
// Data: 11/02/2023
//
// Detalhes:
// 1. Appbar com o título "Dispositivos BLE" e seta para voltar.
// 2. Logo acima da lista.
// 3. Caixa para listagem de dispositivos BLE.
// 4. Botão para atualizar a lista de dispositivos BLE.
//

// Importações.
import 'package:desafio_mobile/widgets/ble_list_box.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe DeviceScreen.
// Responsável por retornar o widget da tela de listagem de dispositivos BLE.
class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  // Método que retorna o widget da tela de listagem de dispositivos BLE.
  // Será chamado toda vez que o estado da tela for alterado.
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

// Classe _DeviceScreenState.
// Responsável por gerenciar o estado da tela de listagem de dispositivos BLE.
class _DeviceScreenState extends State<DeviceScreen> {
  String _lastUpdate = 'N/A';

  // Método que será chamado quando a tela for inicializada.
  // Será chamado apenas uma vez.
  @override
  void initState() {
    super.initState();
    _loadLastUpdate();
  }

  // Método que carrega a última data e hora em que a lista de dispositivos BLE foi atualizada.
  // A data e hora serão exibidas no formato "Última atualização: DD/MM/AAAA HH:MM:SS".
  // Caso não exista nenhuma data e hora salva, será exibido "Última atualização: N/A".
  Future<void> _loadLastUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lastUpdate = prefs.getString('lastUpdate') ?? 'N/A';
    setState(() {
      _lastUpdate = lastUpdate;
    });
  }

  // Método que retorna o widget da tela de listagem de dispositivos BLE.
  // Será chamado toda vez que o estado da tela for alterado.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos BLE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Logo(),
            const SizedBox(height: 10),
            // A caixa tera o título "Última atualização: N/A" e o conteúdo "Dispositivos: N/A".
            // A data e a hora e a lista de dispositivos BLE serão exibidos quando o botão "Atualizar lista" for pressionado.
            // A data e a hora serão exibidas no formato "Última atualização: DD/MM/AAAA HH:MM:SS".
            // Já no conteúdo da caixa, a lista de dispositivos BLE será exibida no formato "Dispositivos:" e embaixo, cada dispositivo BLE será exibido em uma linha.
            // Exemplo:
            // Dispositivos:
            // 1. Dispositivo 1
            // 2. Dispositivo 2
            // N. Dispositivo N
            BleListBox(
              title: _lastUpdate,
              content: 'Dispositivos: N/A',
            ),
            const SizedBox(height: 20),
            // Botão para atualizar a lista de dispositivos BLE.
            // Quando pressionado, a data e a hora serão atualizadas e a lista de dispositivos BLE será atualizada em tempo real.
            CustomButton(
              title: 'Atualizar lista',
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String lastUpdate =
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
                prefs.setString('lastUpdate', lastUpdate);
                setState(() {
                  _lastUpdate = lastUpdate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
