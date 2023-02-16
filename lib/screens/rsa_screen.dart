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
import 'package:desafio_mobile/widgets/custom_button.dart';
import 'package:desafio_mobile/widgets/logo.dart';
import 'package:desafio_mobile/widgets/rsa_box.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RsaScreen extends StatefulWidget {
  const RsaScreen({super.key});

  @override
  State<RsaScreen> createState() => _RsaScreenState();
}

class _RsaScreenState extends State<RsaScreen> {
  String? _publicKey;
  String? _privateKey;
  int _rsaSize = 512;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  void _loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _publicKey = prefs.getString('publicKey');
      _privateKey = prefs.getString('privateKey');
    });
  }

  void _generateKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final rsa = await RSA.generate(_rsaSize);
    setState(() {
      _publicKey = rsa.publicKey;
      _privateKey = rsa.privateKey;
    });
    prefs.setString('publicKey', _publicKey!);
    prefs.setString('privateKey', _privateKey!);
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
    return Scaffold(
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
              value: _publicKey?.split('-----')[2].trim(),
            ),
            const SizedBox(height: 20),
            RsaBox(
              title: 'Chave privada:',
              value: _privateKey?.split('-----')[2].trim(),
            ),
            const SizedBox(height: 30),
            CustomButton(
              title: _publicKey == null && _privateKey == null
                  ? 'Gerar chave'
                  : 'Gerar nova chave',
              onPressed: () {
                if (_publicKey == null && _privateKey == null) {
                  _generateKeys();
                } else {
                  _showDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
