// Descrição: Tela de listagem de dispositivos BLE (Bluetooth Low Energy).
// Autor: Helder Henrique da Silva
// Data: 11/02/2023
//
// Função: Listar os dispositivos BLE (Bluetooth Low Energy) encontrados.
//
// Detalhes:
// 1. Verificação se o Bluetooth está ligado.
// 2. Verificação se o usuário deu permissão para o aplicativo acessar o Bluetooth.
// 3. Scan dos dispositivos BLE (Bluetooth Low Energy). Reurn List<BluetoothDevice>.
// 4. Uso da biblioteca shared_preferences para salvar a data e hora da última atualização da lista de dispositivos BLE.
// 5. Uso da biblioteca intl para formatar a data e hora.
// 6. Uso da biblioteca permission_handler para verificar se o usuário deu permissão para o aplicativo acessar o Bluetooth.
// 7. Uso da biblioteca flutter_blue para scan dos dispositivos BLE (Bluetooth Low Energy).
//

// Importações.
import 'dart:async';

import 'package:desafio_mobile/widgets/ble_list_box.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe DeviceScreen.
class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

// Classe _DeviceScreenState.
class _DeviceScreenState extends State<DeviceScreen> {
  String dateTime = 'N/A';
  List<BluetoothDevice> listBle = [];
  String? deviceScan = '';

  // Método _checkBluetooth.
  Future<void> _checkBluetooth() async {
    // Verifica se o dispositivo está ligado.
    if (!await FlutterBlue.instance.isOn) {
      // Se o Bluetooth não estiver ligado, apresenta uma mensagem de erro.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O Bluetooth não está ligado.'),
          ),
        );
      });
    } else {
      // Se o Bluetooth estiver ligado, verifica se o usuário deu permissão para o aplicativo acessar o Bluetooth.
      if (await Permission.bluetooth.request().isGranted) {
        // Verifica a oermissão de localização.
        if (await Permission.locationWhenInUse.request().isGranted) {
          // Verifica se _scanBle() está sendo executado. Se não estiver, executa _scanBle(). (isScanning retorna um Stream<bool>).
          if (!await FlutterBlue.instance.isScanning.first) {
            // Se o scan não estiver sendo executado, executa o scan de dispositivos BLE.
            await _scanBle();
          } else {
            // Se o scan estiver sendo executado, apresenta uma mensagem de erro.
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'O scan de dispositivos BLE já está sendo executado.'),
                ),
              );
            });
          }
        }
      } else {
        // Se o usuário não deu permissão para o aplicativo acessar o Bluetooth, apresenta uma mensagem de erro.4
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissão de acesso Bluetooth não concedida.'),
            ),
          );
        });
      }
    }
  }

  // Método _scanBle.
  Future<void> _scanBle() async {
    // Inicia o scan de dispositivos BLE.
    Stream<ScanResult> results =
        FlutterBlue.instance.scan(timeout: const Duration(seconds: 20));

    // Aguarda o scan de dispositivos BLE.
    await for (ScanResult scanResult in results) {
      // Se o scan de dispositivos BLE for bem sucedido, atualiza a lista de dispositivos BLE.
      setState(() {
        listBle = scanResult.device as List<BluetoothDevice>;
      });
    }

    // Para o scan de dispositivos BLE.
    FlutterBlue.instance.stopScan();

    // Se a lista de dispositivos BLE estiver vazia, apresenta uma mensagem de nenhum dispositivo encontrado.
    if (listBle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum dispositivo encontrado.'),
        ),
      );
      setState(() {
        deviceScan = 'Nenhum dispositivo encontrado.';
      });
    } else {
      setState(() {
        deviceScan = 'Dispositivos:';
      });
    }

    // Atualiza a data e hora da última atualização da lista de dispositivos BLE.
    setState(() {
      dateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    });

    // Usa o SharedPreferences para salvar a data e hora da última atualização da lista de dispositivos BLE e a lista de dispositivos BLE.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dateTime', dateTime);
    prefs.setStringList('listBle', listBle.cast<String>());
    prefs.setString('deviceScan', deviceScan!);
  }

  // Método _loadDateTime.
  Future<void> _loadDateTime() async {
    // Usa o SharedPreferences para carregar a data e hora da última atualização da lista de dispositivos BLE.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dateTime = prefs.getString('dateTime') ?? 'N/A';
    });
  }

  // Método _loadListBle.
  Future<void> _loadListBle() async {
    // Usa o SharedPreferences para carregar a lista de dispositivos BLE.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      listBle = prefs.getStringList('listBle')?.cast<BluetoothDevice>() ?? [];
      deviceScan = prefs.getString('deviceScan') ?? '';
    });
  }

  // Método initState.
  @override
  void initState() {
    super.initState();
    _loadDateTime();
    _loadListBle();
  }

  // Método build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos BLE'),
      ),
      body: Center(
        child: Column(
          // centralizar no topo ()
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Logo(),
            const SizedBox(height: 5),
            BleListBox(
              dateTime: dateTime,
              listBle: listBle,
              deviceScan: deviceScan,
            ),
            const SizedBox(height: 30),
            CustomButton(title: 'Atualizar lista', onPressed: _checkBluetooth),
          ],
        ),
      ),
    );
  }
}
