// Descrição: Organiza o corpo da tela inicial do aplicativo
// Autor: Helder Henrique da Silva
// Data: 21/02/2023
//
// Tipo: Widget
//
// Detalhes:
// 1. SizedBox de height 80 para deixar um espaço entre o topo da tela e o logo.
// 2. Logo do aplicativo.
// 3. SizedBox de height 5 para deixar um espaço entre o logo e o que vem abaixo.
//

// Importações.
import '/widgets/logo/lab_logo.dart';

import 'package:flutter/material.dart';

class InitialBody extends StatelessWidget {
  const InitialBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const LabLogo(),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}