// Descrição: Caixa para listagagem da chave RSA. Chave pública ou privada.
// Autor: Helder Henrique da Silva
// Data: 14/02/2023
//
// Tipo: Widget
//
// Detalhes:
// 1. Essa caisa será chamada duas vezes, uma para a chave pública e outra para a chave privada.
// 2. A chave pode ser inicialmente nula.
// 3. A caixa é um container com bordas arredondadas, uma sombra, um título superiot e o valor da chave.
// 4. O título superior é um container com bordas arredondadas, uma cor de fundo e um texto.
// 5. Usar o SingleChildScrollView para que a caixa possa ser rolada.
// 6. Usar o MediaQuery para adaptar o tamanho da fonte.
// 7. O tamanho da caixa é 80% da largura e altura fixa.
// 8. A cor de fundo é branca.
//

// Importações.
import 'package:flutter/material.dart';

class RsaBox extends StatelessWidget {
  const RsaBox({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 35,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(10),
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
