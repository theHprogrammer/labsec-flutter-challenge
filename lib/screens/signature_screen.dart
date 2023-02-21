// Descrição: Tela de assinatura digital da lista de dispositivos BLE.
// Autor: Helder Henrique da Silva
// Data: 19/02/2023
//
// Função: Permite assinar a lista de dispositivos BLE gerada na tela ble_device_screen.
//
// Detalhes:
// 1. Integridade: é a qualidade de ser íntegro, de não ter sido adulterado, de não ter sido corrompido.)
// 2. Autenticidade: é a qualidade de ser autêntico, de ser verdadeiro.)
// 3. Hash SHA256: é um algoritmo de hash criptográfico que gera um resumo criptográfico de uma mensagem.
// 4. Base64: é um formato de codificação de dados que representa os dados binários em formato ASCII.
//
// Observações:
// 1. Assinatura digital: é um método de criptografia assimétrica que utiliza uma chave privada para criptografar a mensagem e uma chave pública para descriptografar a mensagem.
//
// Bibliotecas:
// 1. fast_rsa: Biblioteca para gerar chaves RSA.
// 2. shared_preferences: Biblioteca para salvar as chaves RSA no dispositivo.
// 3. provider: Biblioteca para gerenciar o estado da aplicação.
//

// Importações.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desafio_mobile/shared/widgets/rbox/rsa_box.dart';
import 'package:desafio_mobile/shared/providers/rsa_keys_provider.dart';

import 'package:desafio_mobile/shared/providers/device_list_provider.dart';

import 'package:desafio_mobile/shared/providers/digital_signature_provider.dart';

import 'package:desafio_mobile/shared/widgets/export_initial_widgets.dart';

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
              backgroundColor: Colors.red,
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
        prefs.setString('deviceListJsonString', deviceListJsonString);

        // Gerar a assinatura digital com o algoritmo RSA e o hash SHA256.
        if (context.mounted) {
          if (Provider.of<RsaKeysProvider>(context, listen: false).privateKey !=
              null) {
            final String signature = await RSA.signPKCS1v15(
              deviceListJsonString,
              Hash.SHA256,
              Provider.of<RsaKeysProvider>(context, listen: false).privateKey!,
            );
            // Verificar se a assinatura já foi feita.
            if (signature ==
                Provider.of<DigitalSignatureProvider>(context, listen: false)
                    .signature) {
              // Mostrar uma mensagem de erro.
              setState(() {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A assinatura digital já foi gerada.'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            } else {
              // Salvar a assinatura digital no dispositivo.
              prefs.setString('signature', signature);

              // Atualizar a interface da tela.
              setState(() {
                // Atualizar a assinatura digital.
                context
                    .read<DigitalSignatureProvider>()
                    .updateMessage(deviceListJsonString);
                context
                    .read<DigitalSignatureProvider>()
                    .updateSignature(signature);
                // Exibir snackbar com a mensagem de sucesso.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assinatura digital gerada com sucesso.'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            }
          } else {
            // Mostrar uma mensagem de erro.
            setState(() {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('A chave privada RSA não foi gerada.'),
                  backgroundColor: Colors.red,
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
            backgroundColor: Colors.red,
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
    final String? message = prefs.getString('deviceListJsonString');
    if (signature != null) {
      // Atualizar a interface da tela.
      setState(() {
        // Atualizar a assinatura digital.
        // diferença entre read e watch
        context.read<DigitalSignatureProvider>().updateSignature(signature);
        context.read<DigitalSignatureProvider>().updateMessage(message);
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
      body: InitialBody(
        child: Column(
          children: [
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
