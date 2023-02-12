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

// Importações.
import 'package:flutter/material.dart';

// Classe CustomButton.
// Responsável por retornar o widget do botão.
// # Parâmetros (uma vez definidos, não podem ser alterados)):
// - title: Título do botão.
// - onPressed: Ação a ser executada quando o botão é pressionado.
class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  // Construtor da classe.
  // Define os parâmetros da classe como obrigatórios.
  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  // O botão é um ElevatedButton.
  // O tamanho do botão é definido em relação ao tamanho da tela.
  // A largura do botão é 80% da largura da tela.
  // A altura do botão é 50.
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
