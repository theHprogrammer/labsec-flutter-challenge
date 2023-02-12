// Descrição: Logo que será usada em todas as telas do aplicativo
// Autor: Helder Henrique da Silva
// Data: 11/02/2023
//
// Tipo: Widget
//

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Image.asset('assets/images/labsecLogo.png'),
    );
  }
}
