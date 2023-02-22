// Descrição: Tela para gerar chaves RSA.
// Autor: Helder Henrique da Silva
// Data: 14/02/2023
//
// Função: Escolher o tamanho da chave e gerar a chave pública e privada.
//
// Observações:
// Chave RSA: É um algoritmo de criptografia assimétrica, ou seja, utiliza duas chaves para criptografar e descriptografar uma mensagem.
// A chave privada é utilizada para criptografar a mensagem e a chave publica é utilizada para descriptografar a mensagem.
//
// Detalhes:
// 1. Gerar chave RSA.
// 2. Tamanho da chave RSA: 512, 1024, 2048.
//
// Bibliotecas:
// 1. fast_rsa: Biblioteca para gerar chaves RSA.
// 2. shared_preferences: Biblioteca para salvar as chaves RSA no dispositivo.
// 3. provider: Biblioteca para gerenciar o estado da aplicação.
//

// Importações.
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:fast_rsa/fast_rsa.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desafio_mobile/shared/widgets/rbox/rsa_box.dart';
import 'package:desafio_mobile/shared/providers/rsa_keys_provider.dart';

import 'package:desafio_mobile/shared/widgets/export_initial_widgets.dart';

class RsaScreen extends StatefulWidget {
  const RsaScreen({Key? key}) : super(key: key);

  @override
  State<RsaScreen> createState() => _RsaScreenState();
}

class _RsaScreenState extends State<RsaScreen> {
  int _rsaSize = 512;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRsaKeys();
    });
  }

  // Método _loadRsaKeys().
  // Carrega as chaves RSA do dispositivo.
  void _loadRsaKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final publicKey = prefs.getString('publicKey');
    final privateKey = prefs.getString('privateKey');
    if (publicKey != null && privateKey != null) {
      if (context.mounted) {
        context.read<RsaKeysProvider>().updatePublicKey(publicKey);
        context.read<RsaKeysProvider>().updatePrivateKey(privateKey);
      } else {
        if (kDebugMode) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('O contexto não está montado.'),
                backgroundColor: Colors.orange,
              ),
            );
          });
        }
      }
    }
  }

  // Método _generateKeys().
  // Gera as chaves RSA.
  void _generateKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyPair = await RSA.generate(_rsaSize);
      final publicKey = keyPair.publicKey;
      final privateKey = keyPair.privateKey;
      prefs.setString('publicKey', publicKey);
      prefs.setString('privateKey', privateKey);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chaves geradas com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
      });
      if (context.mounted) {
        context.read<RsaKeysProvider>().updatePublicKey(publicKey);
        context.read<RsaKeysProvider>().updatePrivateKey(privateKey);
      } else {
        if (kDebugMode) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('O contexto não está montado.'),
                backgroundColor: Colors.orange,
              ),
            );
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao gerar as chaves.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }

  // Método _showDialog().
  // Mostra um dialog para confirmar a geração de uma nova chave.
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Gerar nova chave?'),
          content: const Text('Deseja realmente gerar uma nova chave?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _generateKeys();
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RsaKeysProvider>(
      create: (context) => RsaKeysProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerar chave RSA'),
        ),
        body: InitialBody(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tamanho da chave:'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _rsaSize,
                    items: const [
                      DropdownMenuItem(
                        value: 512,
                        child: Text('512'),
                      ),
                      DropdownMenuItem(
                        value: 1024,
                        child: Text('1024'),
                      ),
                      DropdownMenuItem(
                        value: 2048,
                        child: Text('2048'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _rsaSize = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RsaBox(
                title: 'Chave pública:',
                value: context
                    .watch<RsaKeysProvider>()
                    .publicKey
                    ?.split('-----')[2]
                    .trim(),
              ),
              const SizedBox(height: 20),
              RsaBox(
                title: 'Chave privada:',
                value: context
                    .watch<RsaKeysProvider>()
                    .privateKey
                    ?.split('-----')[2]
                    .trim(),
              ),
              const SizedBox(height: 30),
              context.watch<RsaKeysProvider>().publicKey == null &&
                      context.watch<RsaKeysProvider>().privateKey == null
                  ? CustomButton(
                      title: 'Gerar chave',
                      onPressed: () {
                        _generateKeys();
                      },
                    )
                  : CustomButton(
                      title: 'Gerar nova chave',
                      onPressed: () {
                        _showDialog();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
