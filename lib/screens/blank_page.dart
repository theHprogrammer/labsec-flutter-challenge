// Descrição: Página em branco para testes
// Autor: Helder Henrique da Silva
// Data: 10/02/2023
//
// Detalhes:
// 1. Página em branco com o texto "Página em branco".
//

import 'package:desafio_mobile/shared/rsa_keys_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RsaKeysScreen extends StatelessWidget {
  const RsaKeysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final publicKey = Provider.of<RsaKeysProvider>(context, listen: true)
        .publicKey
        ?.split('-----')[2]
        .trim();
    final privateKey = Provider.of<RsaKeysProvider>(context, listen: true)
        .privateKey
        ?.split('-----')[2]
        .trim();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chaves RSA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chave pública:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              publicKey ?? 'Nenhuma chave pública gerada',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chave privada:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              privateKey ?? 'Nenhuma chave privada gerada',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
