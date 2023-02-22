// Descrição: Tela de verificação da assintura digital.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
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

import 'package:desafio_mobile/shared/widgets/rbox/rsa_box.dart';
import 'package:desafio_mobile/shared/providers/rsa_keys_provider.dart';

import 'package:desafio_mobile/shared/providers/digital_signature_provider.dart';

import 'package:desafio_mobile/shared/widgets/export_initial_widgets.dart';

// Classe VerifyScreen.
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

// Classe _VerifyScreenState.
class _VerifyScreenState extends State<VerifyScreen> {
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
      final RsaKeysProvider rsaKeysProvider =
          Provider.of<RsaKeysProvider>(context, listen: false);
      final String? publicKey = rsaKeysProvider.publicKey;

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
            RsaBox(
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
