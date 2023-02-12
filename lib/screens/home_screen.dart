// Descrição: Tela inicial do aplicativo.
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Detalhes:
// 1. 4 botões padronizados no meio da tela.
// 2. Cada botão possui um título e leva para uma nova tela.
// 3. Logo acima dos botões.
// 4. Abaixo da logo, o nome da tela. Neste caso, "Home".
//
// Botões:
// 1. Dispositivos BLE
// 2. Gerar chave RSA
// 3. Assinar lista
// 4. Verificar lista".
//

import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Logo(),
            const SizedBox(height: 50),
            CustomButton(
              title: 'Dispositivos BLE',
              onPressed: () {
                Navigator.pushNamed(context, '/blank');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Gerar chave RSA',
              onPressed: () {
                Navigator.pushNamed(context, '/blank');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Assinar lista',
              onPressed: () {
                Navigator.pushNamed(context, '/blank');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Verificar lista',
              onPressed: () {
                Navigator.pushNamed(context, '/blank');
              },
            ),
          ],
        ),
      ),
    );
  }
}
