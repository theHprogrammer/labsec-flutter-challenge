// Descrição: Tela inicial do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Botões:
// 1. Dispositivos BLE
// 2. Gerar chave RSA
// 3. Assinar lista
// 4. Verificar lista".
//

// Importações.
import 'package:desafio_mobile/shared/widgets/export_initial_widgets.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: InitialBody(
        child: Column(
          children: [
            CustomButton(
              title: 'Dispositivos BLE',
              onPressed: () {
                Navigator.pushNamed(context, '/ble_device_screen');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Gerar chave RSA',
              onPressed: () {
                Navigator.pushNamed(context, '/rsa_screen');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Assinar lista',
              onPressed: () {
                Navigator.pushNamed(context, '/signature_screen');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Verificar lista',
              onPressed: () {
                Navigator.pushNamed(context, '/verify_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
