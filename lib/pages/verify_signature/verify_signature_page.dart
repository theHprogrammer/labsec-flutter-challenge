// Descrição: Tela de verificação da assintura digital.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
// Atualizado: 22/03/2023
//
// Função: Verifica a assinatura digital realizada na tela de assinatura.
//
// Detlhes:
// 1. A verificação de uma assinatura digital garante que o documento não foi alterado.
// 2. A verificação de uma assinatura digital garante que o documento foi assinado pelo proprietário da chave privada.
//
// Bibliotecas:
// 1. fast_rsa: Biblioteca para verificar a assinatura digital.
// 2. shared_preferences: Biblioteca para salvar a assinatura digital no dispositivo.
// 3. provider: Biblioteca para gerenciar o estado da aplicação.
// 

// Importações.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/export_initial_widgets.dart';
import '/widgets/box/custom_box/export_custom_box.dart';

import '/providers/rsa/export_rsa_provider.dart';
import '/providers/digital_signature/export_dsignature_provider.dart';

class VerifySignaturePage extends StatefulWidget {
  const VerifySignaturePage({super.key});

  @override
  State<VerifySignaturePage> createState() => _VerifySignaturePageState();
}

class _VerifySignaturePageState extends State<VerifySignaturePage> {
// Variáveis.
  String? _infoText = 'Aguardando a verificação da assinatura digital...';

  @override
  void initState() {
    super.initState();
// Verifica se a assinatura digital é válida.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verifySignature();
    });
  }

// Verifica se a assinatura digital é válida.
  Future<bool> verifySignature() async {
    try {
// Obtém a assinatura digital.
      final DigitalSignatureProvider digitalSignatureProvider =
          Provider.of<DigitalSignatureProvider>(context, listen: false);
      final String? digitalSignature = digitalSignatureProvider.signature;

// Obtém a chave pública.
      final RsaProvider rsaProvider =
          Provider.of<RsaProvider>(context, listen: false);
      final String? publicKey = rsaProvider.publicKey;

      // Obtém a mensagem.
      final String? message = digitalSignatureProvider.message;
      if (message != null) {
        if (publicKey != null) {
          if (digitalSignature != null) {
            // Verifica a assinatura digital.
            final bool isVerify = await RSA.verifyPKCS1v15(
                digitalSignature, message, Hash.SHA256, publicKey);
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isVerify', isVerify);
            if (isVerify) {
              setState(() {
                // Mensagem de sucesso.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assinatura digital válida!'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            } else {
              setState(() {
                // Mensagem de erro.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assinatura digital inválida!'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }
            _infoText = isVerify
                ? 'Assinatura digital válida!'
                : 'Assinatura digital inválida!';
            return isVerify;
          } else {
            setState(() {
              // Mensagem de erro.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assinatura digital não encontrada!'),
                  backgroundColor: Colors.red,
                ),
              );
            });
            _infoText = 'Assinatura digital não encontrada!';
            return false;
          }
        } else {
          setState(() {
            // Mensagem de erro.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Chave pública não encontrada!'),
                backgroundColor: Colors.red,
              ),
            );
          });
          _infoText = 'Chave pública não encontrada!';
          return false;
        }
      } else {
        setState(() {
          // Mensagem de erro.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lista de dispositivos BLE não encontrada!'),
              backgroundColor: Colors.red,
            ),
          );
        });
        _infoText = 'Mensagem não encontrada!';
        return false;
      }
    } catch (e) {
      setState(() {
        // Mensagem de erro.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assinatura digital inválida!'),
            backgroundColor: Colors.red,
          ),
        );
      });
      _infoText = 'Assinatura digital inválida!';
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retornar a interface da tela.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar assinatura'),
      ),
      body: InitialBody(
        child: Column(
          children: [
            CustomBox(
              title: 'Verificação da assinatura digital',
              // se não tiver assinado, mostrar uma mensagem de erro.
              value: _infoText,
            ),
            const SizedBox(height: 30),
            CustomButton(
              title: 'Verificar novamente',
              onPressed: () {
                verifySignature();
              },
            ),
          ],
        ),
      ),
    );
  }
}
