// Descrição: Tela de verificação da assintura digital.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
//
// Função: Verifica a assinatura digital realizada na tela de assinatura.
//
// Detlhes:
// 1. A verificação de uma assinatura digital garante que o documento não foi alterado.
// 2. A verificação de uma assinatura digital garante que o documento foi assinado pelo proprietário da chave privada.
// 3. Utilizaremos a biblioteca fast_rsa para realizar a verificação da assinatura digital.
// 3.1 Será usado o método verifyPKCS1v15(String signature, String message, Hash hash, String publicKey) → Future<bool> para realizar a verificação.
// 3.2 O resultado é mostrado dentro da caixa do (rsa_box.dart).
// 4. Será usado o provider (device_list_provider.dart) para obter a lista de dispositivos BLE.
// 5. Será usado o provider (digital_signature_provider.dart) para obter a assinatura digital.
// 6. Será usado o provider (rsa_keys_provider.dart) para obter a chave pública.
// 7. Se a verificação for bem sucedida, será exibida uma mensagem de sucesso.
// 7.1. Se a verificação não for bem sucedida, será exibida uma mensagem de erro.
// 8. O botão a baixo da tela começará com "Verificar assinatura", depois ele muda para "Verificar novamente", mas se a verificação não for bem sucedida, ele volta para "Verificar assinatura".
//

import 'dart:async';

// Importações.
import 'package:desafio_mobile/shared/digital_signature_provider.dart';
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:desafio_mobile/widgets/rsa_box.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            content: Text('Erro ao verificar a assinatura digital!'),
            backgroundColor: Colors.red,
          ),
        );
      });
      _infoText = 'Erro ao verificar a assinatura digital!';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const Logo(),
            const SizedBox(height: 20),
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
