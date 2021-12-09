library pl.polinc.dummycastle.crypt.asymm;

import 'CryptAsymmKey.dart';

import 'dart:core';

class CryptAsymmPublicKey implements CryptAsymmKey {
  BigInt e = BigInt.zero;
  BigInt n = BigInt.zero;
  int keySize = 0;
  static String KEY_SEPARATOR = "=@=";

  CryptAsymmPublicKey(BigInt e, BigInt n) {
    this.e = e;
    this.n = n;
    this.keySize = e.bitLength;
  }

  static CryptAsymmPublicKey createEmpty() {
    return new CryptAsymmPublicKey(BigInt.zero, BigInt.zero);
  }

  static CryptAsymmPublicKey createFromNums(BigInt e, BigInt n) {
    return new CryptAsymmPublicKey(e, n);
  }

  static CryptAsymmPublicKey createFromString(String publicKeyNumberData) {
    List<String> data = publicKeyNumberData.split(KEY_SEPARATOR);
    BigInt e = BigInt.parse(data[0]);
    BigInt n = BigInt.parse(data[1]);
    return new CryptAsymmPublicKey(e, n);
  }

  String toString() {
    return (e.toString() + KEY_SEPARATOR) + n.toString();
  }

  BigInt getExponent() {
    return e;
  }

  BigInt getProduct() {
    return n;
  }

  int getKeySize() {
    return keySize;
  }
}
