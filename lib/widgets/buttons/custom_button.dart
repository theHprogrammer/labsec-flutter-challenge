// Descrição: Botão padrão do aplicativo
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Tipo: Widget
//
// Parâmetros:
// - title: Título do botão
// - onPressed: Ação a ser executada quando o botão é pressionado
//
// Detalhes:
// 1. Uso de media query para definir o tamanho do botão de acordo com o tamanho da tela.
//

// Importações.
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}