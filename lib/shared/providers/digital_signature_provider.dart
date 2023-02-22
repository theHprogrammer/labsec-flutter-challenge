// Descrição: Provider para gerenciar a assinatura digital.
// Autor: Helder Henrique da Silva
// Data: 19/02/2023
//

import 'dart:convert';

import 'package:flutter/foundation.dart';

class DigitalSignatureProvider extends ChangeNotifier {
  String? _signature;
  String? _message;

  String? get signature => _signature;
  String? get message => _message;

  void updateSignature(String? signature) {
    _signature = signature;
    notifyListeners();
  }

  void updateMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  String encodeSignature() {
    try {
      if (signature != null) {
        return base64Encode(utf8.encode(signature!));
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
