// Descrição: Provider para gerenciar as chaves RSA.
// Autor: Helder Henrique da Silva
// Data: 16/02/2023
// Atualizado: 22/02/2023
//

import 'package:flutter/foundation.dart';

class RsaProvider with ChangeNotifier {
  String? _publicKey;
  String? _privateKey;

  String? get publicKey => _publicKey;
  String? get privateKey => _privateKey;

  void updatePublicKey(String value) {
    _publicKey = value;
    notifyListeners();
  }

  void updatePrivateKey(String value) {
    _privateKey = value;
    notifyListeners();
  }
}
