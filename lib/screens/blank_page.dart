// Descrição: Página em branco para testes
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Detalhes:
// 1. Página em branco com o texto "Página em branco".
//

// Importações.
import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página em branco'),
      ),
      body: const Center(
        child: Text('Página em branco'),
      ),
    );
  }
}
