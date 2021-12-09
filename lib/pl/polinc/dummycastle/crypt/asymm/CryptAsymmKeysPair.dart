library pl.polinc.dummycastle.crypt.asymm;

import 'CryptAsymmPrivateKey.dart';
import 'CryptAsymmPublicKey.dart';
import 'dart:core';

class CryptAsymmKeysPair {
  CryptAsymmPublicKey cryptAsymmPublicKey = CryptAsymmPublicKey.createEmpty();
  CryptAsymmPrivateKey cryptAsymmPrivateKey =
      CryptAsymmPrivateKey.createEmpty();

  Type nonNullableTypeOf<T>(T? object) => T;

  CryptAsymmPublicKey getCryptAsymmPublicKey() {
    return cryptAsymmPublicKey;
  }

  CryptAsymmPrivateKey getCryptAsymmPrivateKey() {
    return cryptAsymmPrivateKey;
  }

  CryptAsymmKeysPair(CryptAsymmPublicKey cryptAsymmPublicKey,
      CryptAsymmPrivateKey cryptAsymmPrivateKey) {
    this.cryptAsymmPublicKey = cryptAsymmPublicKey;
    this.cryptAsymmPrivateKey = cryptAsymmPrivateKey;
  }
}
