// Descrição: Gerenciador de telas do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
//
// Função: Gerencia as rotas do aplicativo e seus providers.
//
// Tela inicial: HomeScreen "/"
//
// Rotas:
// DeviceScreen "/ble_device_screen"
// RsaScreen "/rsa_screen"
// SignatureScreen "/signature_screen"
// VerifyScreen "/verify_screen"
//

// Importações.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desafio_mobile/screens/home_screen.dart';

import 'package:desafio_mobile/screens/ble_device_screen.dart';
import 'package:desafio_mobile/shared/device_list_provider.dart';

import 'package:desafio_mobile/screens/rsa_screen.dart';
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';

import 'package:desafio_mobile/screens/signature_screen.dart';
import 'package:desafio_mobile/shared/digital_signature_provider.dart';

import 'package:desafio_mobile/screens/verify_screen.dart';
import 'package:desafio_mobile/shared/verify_signature_provider.dart';


class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DevicesListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RsaKeysProvider(),
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
        home: const HomeScreen(),
        routes: <String, WidgetBuilder>{
          '/ble_device_screen': (BuildContext context) => const DeviceScreen(),
          '/rsa_screen': (BuildContext context) => const RsaScreen(),
          '/signature_screen': (BuildContext context) => const SignatureScreen(),
          '/verify_screen': (BuildContext context) => const VerifyScreen(),
        },
      ),
    );
  }
}
