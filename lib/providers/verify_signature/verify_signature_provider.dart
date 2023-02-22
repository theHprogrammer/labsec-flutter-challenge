// Descrição: Provider para gerenciar a verificação da assinatura digital.
// Autor: Helder Henrique da Silva
// Data: 20/02/2023
// Atualizado: 22/02/2023
//

import 'package:flutter/foundation.dart';

class VerifySignatureProvider extends ChangeNotifier {
  bool? _isVerify;

  bool? get isVerify => _isVerify;

  void updateIsVerify(bool? isVerify) {
    _isVerify = isVerify;
    notifyListeners();
  }
}
