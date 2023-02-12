// Descrição: Arquivo principal do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Função: Inicializar o aplicativo e definir a tela inicial.
// Tela inicial: HomeScreen
//

// Importações.
import 'package:desafio_mobile/screens/blank_page.dart';
import 'package:desafio_mobile/screens/ble_device.dart';
import 'package:desafio_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Função principal.
void main() => runApp(const MyApp());

// Classe principal.
// Responsável por inicializar o aplicativo e definir a tela inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método que retorna o widget principal.
  // Tela inicial: HomeScreen
  // Rotas: /blank, /ble_device
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/blank': (BuildContext context) => const BlankPage(),
        '/ble_device': (BuildContext context) => const DeviceScreen(),
      },
    );
  }
}
