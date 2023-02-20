// Descrição: Tela para gerar chaves RSA.
// Autor: Helder Henrique da Silva
// Data: 14/02/2023
//
// Função: Escolher o tamanho da chave e gerar a chave pública e privada.
// Chave RSA: É um algoritmo de criptografia assimétrica, ou seja, utiliza duas chaves para criptografar e descriptografar uma mensagem.
// A chave pública é utilizada para criptografar a mensagem e a chave privada é utilizada para descriptografar a mensagem.
//
// Detalhes:
// 1. DropdownButton para escolher o tamanho da chave.
// 2. Duas caixas para exibir a chave pública e privada.
// 3. Botão para gerar as chaves.
// 4. Usar o SharedPreferences para salvar as chaves.
// 5. Usar o FastRsa para gerar as chaves.
//

// Importações.
import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:desafio_mobile/widgets/rsa_box.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          print('O contexto não está montado.');
        }
      }
    }
  }

  void _generateKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keyPair = await RSA.generate(_rsaSize);
    final publicKey = keyPair.publicKey;
    final privateKey = keyPair.privateKey;
    prefs.setString('publicKey', publicKey);
    prefs.setString('privateKey', privateKey);
    if (context.mounted) {
      context.read<RsaKeysProvider>().updatePublicKey(publicKey);
      context.read<RsaKeysProvider>().updatePrivateKey(privateKey);
    } else {
      if (kDebugMode) {
        print('O contexto não está montado.');
      }
    }
  }

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
        body: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Logo(),
              const SizedBox(height: 5),
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
              // Se as chaves forem nulas, exibe o botão gerar chave. Caso contrário, exibe o botão para "gerar nova chave".
              // Se for para gerar nova chave, mostra o dialogo de confirmação.
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
