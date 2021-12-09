library pl.polinc.dummycastle.crypt.asymm;


import 'dart:core';

abstract class CryptAsymmKey {
  String toString();

  BigInt getExponent();

  BigInt getProduct();

  int getKeySize();
}
