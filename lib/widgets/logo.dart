// Descrição: Logo que será usada em todas as telas do aplicativo
// Autor: Helder Henrique da Silva
// Data: 11/02/2023
//
// Tipo: Widget
//

// Importações.
import 'package:flutter/material.dart';

// Classe Logo.
// Responsável por retornar o widget da logo.
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  // Método que retorna o widget da logo.
  // A logo é um arquivo .png que está na pasta assets/images.
  // O tamanho da logo é definido em relação ao tamanho da tela.
  // A largura da logo é 80% da largura da tela.
  // A altura da logo é 20% da altura da tela.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Image.asset('assets/images/labsecLogo.png'),
    );
  }
}
