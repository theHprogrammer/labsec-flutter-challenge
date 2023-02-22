// Descrição: Gerenciador de telas do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
// Atualizado: 22/02/2023
//
// Função: Gerencia as rotas do aplicativo e seus providers.
//
// Tela inicial: HomePage "/"
//
// Rotas:
// DevicePage "/ble_device_page"
// RsaPage "/rsa_page"
// SignaturePage "/signature_page"
// VerifyPage "/verify_page"
//

// Importações.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/pages/export_pages.dart';

import '/providers/export_providers.dart';

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BleDeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RsaProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DigitalSignatureProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VerifySignatureProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Desafio Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: <String, WidgetBuilder>{
          '/ble_device_page': (BuildContext context) => const BleDevicePage(),
          '/rsa_page': (BuildContext context) => const RsaPage(),
          '/signature_page': (BuildContext context) => const DigitalSignaturePage(),
          '/verify_page': (BuildContext context) => const VerifySignaturePage(),
        },
      ),
    );
  }
}
