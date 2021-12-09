library pl.polinc.dummycastle.crypt.asymm;

import 'CryptAsymmKey.dart';

import 'dart:core';

class CryptAsymmPrivateKey implements CryptAsymmKey {
  BigInt d = BigInt.zero;
  BigInt n = BigInt.zero;
  static String KEY_SEPARATOR = "=@=";
  int keySize = 0;

  CryptAsymmPrivateKey(BigInt d, BigInt n) {
    this.d = d;
    this.n = n;
    this.keySize = d.bitLength;
  }

  static CryptAsymmPrivateKey createFromNums(BigInt d, BigInt n) {
    return new CryptAsymmPrivateKey(d, n);
  }

  static CryptAsymmPrivateKey createFromString(String privateKeyNumberData) {
    List<String> data = privateKeyNumberData.split(KEY_SEPARATOR);
    BigInt d = BigInt.parse(data[0]);
    BigInt n = BigInt.parse(data[1]);
    return new CryptAsymmPrivateKey(d, n);
  }

  static CryptAsymmPrivateKey createEmpty() {
    return new CryptAsymmPrivateKey(BigInt.zero, BigInt.zero);
  }

  String toString() {
    return (d.toString() + KEY_SEPARATOR) + n.toString();
  }

  BigInt getExponent() {
    return d;
  }

  BigInt getProduct() {
    return n;
  }

  int getKeySize() {
    return keySize;
  }
}
