// Descrição: Caixa para listagem de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 12/02/2023
//
// Tipo: Widget
//

// Importações.
import 'package:flutter/material.dart';

// Classe Box.
// Responsável por retornar o widget da caixa.
class BleListBox extends StatelessWidget {
  final String title;
  final String content;

  // Construtor da classe.
  // Define os parâmetros da classe como obrigatórios.
  const BleListBox({Key? key, required this.title, required this.content})
      : super(key: key);

  // O widget é um SingleChildScrollView.
  // O widget tem um Container.
  // O Container é um retângulo com bordas arredondadas.
  // O Container tem um tamanho definido em relação ao tamanho da tela.
  // A largura do Container é 80% da largura da tela.
  // A altura do Container é 30% da altura da tela.
  // O Container tem um padding (espaço interno) de 20.
  // O Container tem uma cor de fundo cinza.
  // O Container tem uma coluna com dois textos.
  // O primeiro texto é o título.
  // O segundo texto é o conteúdo.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.045;
    String text = 'Última atualização:';

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: textSize,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
        // criar outra coluna para separar o content?
      ),
    );
  }
}
