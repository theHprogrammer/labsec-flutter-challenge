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
//

// Importações.
import 'dart:async';
import 'dart:convert';

import 'package:desafio_mobile/shared/device_list_provider.dart';
import 'package:desafio_mobile/shared/digital_signature_provider.dart';
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:desafio_mobile/widgets/rsa_box.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSignature();
    });
  }

  // Método para calcular a assinatura digital.
  Future<void> _calculateSignature() async {
    try {
      // Verificar se a lista de dispositivos BLE está vazia.
      if (Provider.of<DevicesListProvider>(context, listen: false)
          .idDevices
          .isEmpty) {
        // Mostrar uma mensagem de erro.
        setState(() {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('A lista de dispositivos BLE está vazia.'),
            ),
          );
        });
      } else {
        // Gerar a lista de dispositivos BLE em formato JSON.
        final List<Map<String, dynamic>> deviceListJson = context
            .read<DevicesListProvider>()
            .toJson(context.read<DevicesListProvider>().nameDevices,
                context.read<DevicesListProvider>().idDevices);

        // Converter List<Map<String, dynamic>> para String.
        final String deviceListJsonString = jsonEncode(deviceListJson);

        final prefs = await SharedPreferences.getInstance();

        // Gerar a assinatura digital com o algoritmo RSA e o hash SHA256.
        if (context.mounted) {
          if (Provider.of<RsaKeysProvider>(context, listen: false).privateKey !=
              null) {
            final String signature = await RSA.signPKCS1v15(
              deviceListJsonString,
              Hash.SHA256,
              Provider.of<RsaKeysProvider>(context, listen: false).privateKey!,
            );
            prefs.setString('signature', signature);

            // Atualizar a interface da tela.
            setState(() {
              // Atualizar a assinatura digital.
              context
                  .read<DigitalSignatureProvider>()
                  .updateSignature(signature);
              // Exibir snackbar com a mensagem de sucesso.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assinatura digital gerada com sucesso.'),
                ),
              );
            });
          } else {
            // Mostrar uma mensagem de erro.
            setState(() {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('A chave privada RSA não foi gerada.'),
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      // Mostrar uma mensagem de erro.
      setState(() {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao calcular a assinatura digital.'),
          ),
        );
      });
    }
  }

  String _getButtonText() {
    // Verificar se a assinatura já foi feita.
    if (context.read<DigitalSignatureProvider>().signature == null ||
        context.read<DigitalSignatureProvider>().signature == '') {
      // Retornar o texto do botão.
      return 'Assinar lista';
    } else {
      // Retornar o texto do botão.
      return 'Assinar novamente';
    }
  }

  String _verifySignature() {
    // Verificar se a assinatura já foi feita.
    if (context.read<DigitalSignatureProvider>().signature == null ||
        context.read<DigitalSignatureProvider>().signature == '') {
      // Retornar uma mensagem de erro.
      return 'A lista de dispositivos BLE ainda não foi assinada.';
    } else {
      // Retornar a assinatura digital.
      return context.read<DigitalSignatureProvider>().encodeSignature();
    }
  }

  // Método para carregar a assinatura digital.
  Future<void> _loadSignature() async {
    final prefs = await SharedPreferences.getInstance();
    final String? signature = prefs.getString('signature');
    if (signature != null) {
      // Atualizar a interface da tela.
      setState(() {
        // Atualizar a assinatura digital.
        // diferença entre read e watch
        context.read<DigitalSignatureProvider>().updateSignature(signature);
      });
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
