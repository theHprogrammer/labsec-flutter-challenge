// Descrição: Arquivo principal do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Função: Inicializar o aplicativo e definir a tela inicial.
//
// Tela inicial: HomeScreen
//
// Rotas:
// /blank: Tela em branco.
// /ble_device: Tela de detalhes do dispositivo BLE.
//

// Importações.
import 'package:desafio_mobile/screens/blank_page.dart';
import 'package:desafio_mobile/screens/ble_device_screen.dart';
import 'package:desafio_mobile/screens/home_screen.dart';
import 'package:desafio_mobile/screens/rsa_screen.dart';
import 'package:desafio_mobile/screens/signature_screen.dart';
import 'package:desafio_mobile/shared/device_list_provider.dart';
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      // Varios providers
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DevicesListProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => RsaKeysProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/blank': (BuildContext context) => const RsaKeysScreen(),
        '/ble_device': (BuildContext context) => const DeviceScreen(),
        '/rsa': (BuildContext context) => const RsaScreen(),
        '/signature': (BuildContext context) => const SignatureScreen(),
      },
    );
  }
}
