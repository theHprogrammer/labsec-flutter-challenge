// Descrição: Tela de assinatura digital da lista de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 19/02/2023
//
// Função: Permite assinar a lista de dispositivos BLE gerada na tela ble_device_screen.
// Para assinar, deve-se utilizar os algoritmos SHA256 e RSA.
// Após realizada a assinatura, a tela deve ser atualizada mostrando a assinatura digital codificada em formato Base64.
//
// Detalhes:
// 1. Uma assinatura digital serve para garantir a integridade de um documento. (Integridade: é a qualidade de ser íntegro, de não ter sido adulterado, de não ter sido corrompido.)
// 2. Além de garantir a integridade, a assinatura digital também garante a autenticidade do documento. (Autenticidade: é a qualidade de ser autêntico, de ser verdadeiro.)
// 3. Usar a biblioteca pointycastle ou fast_rsa para gerar a assinatura digital.
// 4. Usar a biblioteca crypto para gerar o hash SHA256.
// 5. Usar a biblioteca shared_preferences para salvar a assinatura digital.
// 6. Usar a biblioteca intl para formatar a data e hora.
// 7. Usar a biblioteca permission_handler para verificar se o aplicativo tem permissão para acessar o armazenamento interno.
// 8. A tela começa com o appbar com título "Assinar lista".
// 9. Em baixo do appbar, há a logo do aplicativo.
// 10. Em baixo da logo, há a caixa (pode ser a mesma usada da rsa_box.dart) com o título "Assinatura digital".
// 11. Em baixo da caixa, há um botão com o texto "Assinar". Ao clicar no botão, deve-se assinar a lista de dispositivos BLE.
// 11.1 Se a lista de dispositivos BLE estiver vazia, deve-se mostrar uma mensagem de erro.
// 11.2 Se a lista de dispositivos BLE não estiver vazia, deve-se assinar a lista de dispositivos BLE.
// 11.3 Se a lista de dispositivos BLE não estiver vazia, deve-se salvar a assinatura digital no armazenamento interno.
// 11.4 Se a lista já tiver sido assinada, deve-se mostrar no bot]ao "Assinar novamente".
// 12. Ao assinar a lista de dispositivos BLE, deve-se mostrar a assinatura digital codificada em formato Base64 na caixa.

// Importações.
import 'dart:async';
import 'dart:convert';

import 'package:desafio_mobile/shared/device_list_provider.dart';
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:desafio_mobile/widgets/rsa_box.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Classe SignatureScreen
class SignatureScreen extends StatefulWidget {
  // Construtor.
  const SignatureScreen({Key? key}) : super(key: key);

  // Método de criação do estado.
  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

// Classe _SignatureScreenState.
class _SignatureScreenState extends State<SignatureScreen> {
  // Atributos privados.
  String? _signature;

  // Método para calcular a assinatura digital.
  Future<void> _calculateSignature() async {
    // Verificar se a lista de dispositivos BLE está vazia.
    if (Provider.of<DevicesListProvider>(context, listen: false)
        .devices
        .isEmpty) {
      // Mostrar uma mensagem de erro.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A lista de dispositivos BLE está vazia.'),
        ),
      );
    } else {
      // Gerar a lista de dispositivos BLE em formato JSON.
      final List<Map<String, dynamic>> deviceListJson = context
          .read<DevicesListProvider>()
          .toJson(context.read<DevicesListProvider>().devices);

      // Converter List<Map<String, dynamic>> para String.
      final String deviceListJsonString = jsonEncode(deviceListJson);

      // Gerar a assinatura digital com o algoritmo RSA e o hash SHA256.
      final String signature = await RSA.signPSS(
        deviceListJsonString,
        Hash.SHA256,
        SaltLength.AUTO,
        Provider.of<RsaKeysProvider>(context, listen: false).privateKey!,
      );

      // Atualizar a interface da tela.
      setState(() {
        _signature = signature;
      });
    }
  }

  String _encodeSignature() {
    // Verificar se _signature é nulo.
    if (_signature == null) {
      return '';
    }
    // Codificar a assinatura digital em formato base64.
    try {
      return base64.encode(utf8.encode(_signature!));
    } catch (e) {
      return '';
    }
  }

  String _getButtonText() {
    // Verificar se a assinatura já foi feita.
    if (_signature == null || _signature == '') {
      // Retornar o texto do botão.
      return 'Assinar';
    } else {
      // Retornar o texto do botão.
      return 'Assinar novamente';
    }
  }

  String _verifySignature() {
    // Verificar se a assinatura já foi feita.
    if (_signature == null || _signature == '') {
      // Retornar a mensagem de erro.
      return 'A lista não foi assinada.';
    } else {
      // Retornar a assinatura digital codificada em formato Base64.
      return _encodeSignature();
    }
  }

  // Métodos públicos.
  @override
  Widget build(BuildContext context) {
    // Retornar a interface da tela.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assinar lista'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const Logo(),
            const SizedBox(height: 20),
            RsaBox(
              title: 'Assinatura digital',
              // se não tiver assinado, mostrar uma mensagem de erro.
              value: _verifySignature(),
            ),
            const SizedBox(height: 30),
            CustomButton(
              title: _getButtonText(),
              onPressed: _calculateSignature,
            ),
          ],
        ),
      ),
    );
  }
}
