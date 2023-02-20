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
    try {
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
    } catch (e) {
      // Se ocorrer algum erro, apresenta uma mensagem de erro.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao verificar o Bluetooth.'),
          ),
        );
      });
    }
  }

  // Método _addDeviceTolist, para adicionar o dispositivo BLE na lista de dispositivos BLE.
  Future<void> _addDeviceTolist(final BluetoothDevice device) async {
    try {
      // Verifica se o dispositivo BLE já está na lista de dispositivos BLE.
      if (!context.read<DevicesListProvider>().devicesList.contains(device)) {
        // Se o dispositivo BLE não estiver na lista de dispositivos BLE, adiciona o dispositivo BLE na lista de dispositivos BLE.
        // Se o nome do dispositivo BLE for null ou vazio, adiciona o nome do dispositivo BLE como "Unknow Device".
        if (device.name == null || device.name == '') {
          context.read<DevicesListProvider>().devicesList.add(device);
          context.read<DevicesListProvider>().nameDevices.add('Unknow Device');
          context.read<DevicesListProvider>().idDevices.add(device.id.id);
        } else {
          context.read<DevicesListProvider>().devicesList.add(device);
          context.read<DevicesListProvider>().nameDevices.add(device.name);
          context.read<DevicesListProvider>().idDevices.add(device.id.id);
        }
      }
    } catch (e) {
      // Se ocorrer algum erro, apresenta uma mensagem de erro.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao adicionar o dispositivo BLE na lista.'),
          ),
        );
      });
    }
  }

  // Método _scanBle.
  Future<void> _scanBle() async {
    try {
      // Verifica se não é null.
      if (context.read<DevicesListProvider>().devicesList != null) {
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Logo(),
                  const SizedBox(height: 5),
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
