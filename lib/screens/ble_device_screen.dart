// Descrição: Tela de listagem de dispositivos BLE (Bluetooth Low Energy).
// Autor: Helder Henrique da Silva
// Data: 11/02/2023
//
// Função: Listar os dispositivos BLE (Bluetooth Low Energy) encontrados.
//
// Detalhes:
// 1. Verificação se o bluetooth está ligado.
// 2. Verificação se o usuário deu permissão para o aplicativo acessar o Bluetooth.
// 3. Verificação se o usuário deu permissão para o aplicativo acessar a localização.
// 4. Verificação se o usuário deu permissão para fazer o scan de dispositivos BLE (Bluetooth Low Energy).
//
// Bibliotecas:
// 1. Uso da biblioteca dart:async serve para trabalhar com assincronismo, ou seja, para trabalhar com funções que demoram para serem executadas.
// 2. Uso da biblioteca package:intl/intl.dart serve para trabalhar com formatação de datas e horas.
// 3. Uso da biblioteca package:provider/provider.dart serve para trabalhar com o padrão de projeto Provider permitindo que os dados sejam compartilhados entre widgets sem a necessidade de passar os dados manualmente.
// 4. Uso da biblioteca package:flutter_blue/flutter_blue.dart serve para trabalhar com o Bluetooth Low Energy (BLE).
// 5. Uso da biblioteca package:permission_handler/permission_handler.dart serve para trabalhar com permissões.
// 6. Uso da biblioteca package:shared_preferences/shared_preferences.dart serve para trabalhar com preferências do usuário.
//

// Importações.
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';

import 'package:desafio_mobile/shared/widgets/blebox/ble_list_box.dart';
import 'package:desafio_mobile/shared/providers/device_list_provider.dart';

import 'package:desafio_mobile/shared/widgets/export_initial_widgets.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // dataTime, para armazenar a data e hora do scan de dispositivos BLE.
  String dateTime = 'N/A';

  // deviceScan, para armazernar o estado do scan de dispositivos BLE.
  String? deviceScan = '';

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  // Método _checkBluetooth.
  // Realiza todas as verificações necessárias para o scan de dispositivos BLE.
  Future<void> _checkBluetooth() async {
    try {
      // Verifica se o dispositivo está ligado.
      if (!await FlutterBlue.instance.isOn) {
        // Se o Bluetooth não estiver ligado, apresenta uma mensagem de erro.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('O Bluetooth não está ligado.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        // Se o Bluetooth estiver ligado, verifica se o usuário deu permissão para o aplicativo acessar o Bluetooth.
        if (await Permission.bluetooth.request().isGranted) {
          // Verifica a permissão de localização.
          if (await Permission.locationWhenInUse.request().isGranted) {
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
                      backgroundColor: Colors.orange,
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
                    backgroundColor: Colors.red,
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
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      // Se ocorrer algum erro, apresenta uma mensagem de erro.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao verificar o Bluetooth.'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  // Método _addDeviceTolist
  // Adiciona o dispositivo BLE na lista de dispositivos BLE.
  Future<void> _addDeviceTolist(final BluetoothDevice device) async {
    try {
      // Verifica se o dispositivo BLE já está na lista de dispositivos BLE.
      if (!context.read<DevicesListProvider>().idDevices.contains(device.id.id)) {
        // Se o nome do dispositivo BLE for nulo ou vazio, adiciona o dispositivo BLE na lista de dispositivos BLE trocando o nome do dispositivo BLE por 'Unknow Device'.
        if (device.name == null || device.name == '') {
          context.read<DevicesListProvider>().nameDevices.add('Unknow Device');
        } else {
          context.read<DevicesListProvider>().nameDevices.add(device.name);
        }
        context.read<DevicesListProvider>().devicesList.add(device);
        context.read<DevicesListProvider>().idDevices.add(device.id.id);
      }
    } catch (e) {
      // Se ocorrer algum erro, apresenta uma mensagem de erro.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao adicionar o dispositivo BLE na lista.'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  // Método _scanBle.
  Future<void> _scanBle() async {
    try {
      // Verifica se não é null.
      if (context.read<DevicesListProvider>().devicesList != null ||
          context.read<DevicesListProvider>().devicesList.isNotEmpty) {
        // Limpa a lista de dispositivos BLE e muda o deviceScan para "Escaneando...".
        setState(() {
          context.read<DevicesListProvider>().devicesList.clear();
          context.read<DevicesListProvider>().nameDevices.clear();
          context.read<DevicesListProvider>().idDevices.clear();
          deviceScan = 'Escaneando...';
        });

        // Inicia o scan de dispositivos BLE e equanto estiver sendo executado, muda o deviceScan para "Escaneando..." em tempo real.
        await flutterBlue.startScan(timeout: const Duration(seconds: 5));

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
        // Verifica se é diferente de null.
        if (context.mounted) {
          // Verifica se a lista de dispositivos BLE não está vazia.
          if (context.read<DevicesListProvider>().devicesList.isNotEmpty) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Scan de dispositivos BLE executado com sucesso.'),
                  backgroundColor: Colors.green,
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
                  backgroundColor: Colors.red,
                ),
              );
            });
            setState(() {
              deviceScan = 'Nenhum dispositivo encontrado.';
            });
          }

          // Usa o SharedPreferences para salvar a data e hora da última atualização da lista de dispositivos BLE.
          // Usa o SharedPreferences para salvar o estado do deviceScan.
          // Usa o SharedPreferences para salvar a lista de dispositivos BLE.
          // Usa o SharedPreferences para salvar a lista de nomes dos dispositivos BLE.
          // Usa o SharedPreferences para salvar a lista de IDs dos dispositivos BLE.
          final prefs = await SharedPreferences.getInstance();
          if (context.mounted) {
            prefs.setString('dateTime', dateTime);
            prefs.setString('deviceScan', deviceScan!);
            prefs.setStringList(
                'idDevices',
                context
                    .read<DevicesListProvider>()
                    .idDevices
                    .map((e) => e.toString())
                    .toList());
            prefs.setStringList(
                'nameDevices',
                context
                    .read<DevicesListProvider>()
                    .nameDevices
                    .map((e) => e.toString())
                    .toList());
            prefs.setStringList(
                'devicesList',
                context
                    .read<DevicesListProvider>()
                    .devicesList
                    .map((e) => e.toString())
                    .toList());
            context
                .read<DevicesListProvider>()
                .updateIdDevices(context.read<DevicesListProvider>().idDevices);
            context.read<DevicesListProvider>().updateNameDevices(
                context.read<DevicesListProvider>().nameDevices);
            context.read<DevicesListProvider>().updateDevicesList(
                context.read<DevicesListProvider>().devicesList);
          }
        }
      }
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

  // Método _loadDeviceText, para carregar o deviceScan.
  Future<void> _loadDeviceText() async {
    // Usa o SharedPreferences para carregar o estado do deviceScan.
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deviceScan = prefs.getString('deviceScan') ?? 'Dispositivos: N/A';
    });
  }

  // Método _loadListBle, para carregar a lista de dispositivos BLE usando as Lists<String> nameDevices e idDevices.
  Future<void> _loadListBle() async {
    // Usa o SharedPreferences para carregar a lista de dispositivos BLE.
    // Usa o SharedPreferences para carregar a lista de nomes dos dispositivos BLE.
    // Usa o SharedPreferences para carregar a lista de IDs dos dispositivos BLE.
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      context.read<DevicesListProvider>().updateIdDevices(
          prefs.getStringList('idDevices')?.map((e) => e.toString()).toList() ??
              <String>[]);
      context.read<DevicesListProvider>().updateNameDevices(prefs
              .getStringList('nameDevices')
              ?.map((e) => e.toString())
              .toList() ??
          <String>[]);
    });
  }

  // Método initState.
  @override
  void initState() {
    super.initState();
    _loadDateTime();
    _loadDeviceText();
    _loadListBle();
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
            return InitialBody(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BleListBox(
                    dateTime: dateTime,
                    devicesList: context.read<DevicesListProvider>().toJson(
                        context.watch<DevicesListProvider>().nameDevices,
                        context.watch<DevicesListProvider>().idDevices),
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
