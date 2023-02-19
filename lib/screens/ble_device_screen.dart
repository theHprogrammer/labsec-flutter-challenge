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
// 8. Uso da biblioteca provider para poder compartilhar a lista de dispositivos BLE (Bluetooth Low Energy) com outras telas.
//

// Importações.
import 'dart:async';

import 'package:desafio_mobile/shared/device_list_provider.dart';
import 'package:desafio_mobile/widgets/ble_list_box.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
  String? deviceScan = '';

  // Instancia o FlutterBlue.
  final FlutterBlue flutterBlue = FlutterBlue.instance;

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
          // Verifica a permisão de acesso ao armazenamento.
          // Verifica a permissão de acesso ao scan de dispositivos BLE do bluetooth.
          if (await Permission.bluetoothScan.request().isGranted) {
            // Se o usuário deu permissão para o aplicativo acessar o Bluetooth, verifica se o scan de dispositivos BLE está sendo executado.
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
          } else {
            // Se o usuário não deu permissão para o aplicativo acessar o scan de dispositivos BLE do bluetooth, apresenta uma mensagem de erro.
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Permissão de acesso ao scan de dispositivos BLE do bluetooth não concedida.'),
                ),
              );
            });
          }
        } else {
          // Se o usuário não deu permissão para o aplicativo acessar a localização, apresenta uma mensagem de erro.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Permissão de acesso a localização não concedida.'),
              ),
            );
          });
        }
      }
    }
  }

  // Método _addDeviceTolist, para adicionar o dispositivo BLE na lista de dispositivos BLE.
  Future<void> _addDeviceTolist(final BluetoothDevice device) async {
    // Verifica se o dispositivo BLE já está na lista de dispositivos BLE.
    if (!context.read<DevicesListProvider>().devices.contains(device)) {
      // Se o dispositivo BLE não estiver na lista de dispositivos BLE, adiciona o dispositivo BLE na lista de dispositivos BLE.
      setState(() {
        context.read<DevicesListProvider>().devices.add(device);
      });
    }
  }

  // Método _scanBle.
  Future<void> _scanBle() async {
    try {
      // Limpa a lista de dispositivos BLE e muda o deviceScan para "Escaneando...".
      setState(() {
        context.read<DevicesListProvider>().devices.clear();
        deviceScan = 'Escaneando...';
      });

      // Inicia o scan de dispositivos BLE e equanto estiver sendo executado, muda o deviceScan para "Escaneando..." em tempo real.
      await flutterBlue.startScan(timeout: const Duration(seconds: 4));

      // Adiciona o dispositivo BLE na lista de dispositivos BLE.
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult r in results) {
          _addDeviceTolist(r.device);
        }
      });

      // Aguarda o scan ser executado.
      await flutterBlue.stopScan();

      // Atualiza a data e hora do scan.
      setState(() {
        dateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
      });

      // Se o scan tiver sido executado e retornou a lista de dispositivos BLE, apresenta uma mensagem de sucesso.
      if (context.read<DevicesListProvider>().devices.isNotEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Scan de dispositivos BLE executado com sucesso.'),
            ),
          );
        });
        setState(() {
          deviceScan = 'Dispositivos: ';
        });
      } else {
        // Se o scan não retornou nenhum dispositivo BLE, apresenta uma mensagem de erro.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum dispositivo BLE encontrado.'),
            ),
          );
        });
        setState(() {
          deviceScan = 'Nenhum dispositivo encontrado.';
        });
      }

      // Usa o SharedPreferences para salvar a data e hora da última atualização da lista de dispositivos BLE e a lista de dispositivos BLE e o estado do deviceScan.
      final prefs = await SharedPreferences.getInstance();
      final List<BluetoothDevice> devices =
          context.read<DevicesListProvider>().devices;
      prefs.setString('dateTime', dateTime);
      prefs.setString('deviceScan', deviceScan!);
      prefs.setStringList(
          'listBle', devices.map((e) => e.id.toString()).toList());
      context.read<DevicesListProvider>().updateDevicesList(devices);

      // Se ocorrer algum erro, apresenta uma mensagem de erro.
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Método _loadDateTime, para carregar a data e hora do scan.
  Future<void> _loadDateTime() async {
    // Usa o SharedPreferences para carregar a data e hora da última atualização da lista de dispositivos BLE.
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dateTime = prefs.getString('dateTime') ?? 'N/A';
    });
  }

  // Método _loadListBle, para carregar a lista de dispositivos BLE.
  Future<void> _loadDeviceText() async {
    // Usa o SharedPreferences para carregar o estado do deviceScan.
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deviceScan = prefs.getString('deviceScan') ?? 'Dispositivos: N/A';
    });
  }

  // Método initState.
  @override
  void initState() {
    super.initState();
    _loadDateTime();
    _loadDeviceText();
  }

  // Método build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos BLE'),
      ),
      body: ChangeNotifierProvider<DevicesListProvider>(
        create: (_) => DevicesListProvider(),
        child: Consumer<DevicesListProvider>(
          builder: (_, deviceListProvider, __) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Logo(),
                  const SizedBox(height: 5),
                  BleListBox(
                    dateTime: dateTime,
                    devicesList: context
                        .read<DevicesListProvider>()
                        .toJson(context.watch<DevicesListProvider>().devices),
                    deviceScan: deviceScan,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                      title: 'Atualizar lista', onPressed: _checkBluetooth),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
