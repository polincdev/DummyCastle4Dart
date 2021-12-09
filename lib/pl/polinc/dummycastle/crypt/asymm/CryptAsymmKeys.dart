library pl.polinc.dummycastle.crypt.asymm;

import 'dart:math';
import 'CryptAsymmPrivateKey.dart';
import 'CryptAsymmPublicKey.dart';
import 'dart:core';
import 'CryptAsymmKeysPair.dart';
import '../../random/RandomClient.dart';
import 'BigInteger.dart';

enum ASYMM_KEY_SIZE_TYPE {
  KEY_SIZE_128,
  KEY_SIZE_256,
  KEY_SIZE_512,
  KEY_SIZE_1024,
  KEY_SIZE_2048,
  KEY_SIZE_4096
}

class CryptAsymmKeys {
  int keySize = 512;

  CryptAsymmKeys() {
    keySize = 128;
  }

  CryptAsymmKeys.withKeySize(ASYMM_KEY_SIZE_TYPE keySizeType) {
    if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_128) {
      keySize = 128;
    } else {
      if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_256) {
        keySize = 256;
      } else {
        if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_512) {
          keySize = 512;
        } else {
          if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_1024) {
            keySize = 1024;
          } else {
            if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_2048) {
              keySize = 2048;
            } else {
              if (keySizeType == ASYMM_KEY_SIZE_TYPE.KEY_SIZE_4096) {
                keySize = 4096;
              }
            }
          }
        }
      }
    }
  }

  CryptAsymmKeysPair generateKeys() {
    Random rand = new Random();
    BigInteger bigInteger = BigInteger();

    BigInt p = bigInteger.probablePrime((keySize ~/ 2), rand);
    BigInt q = bigInteger.probablePrime((keySize ~/ 2), rand);
    BigInt n = p * (q);
    BigInt phi = (p - (BigInt.one)) * (q - (BigInt.one));

    BigInt e;
    do {
      String symmKey = RandomClient.generateRandomString(
          (phi.bitLength ~/ 8), RandomClientMode.NUMERIC, false);
      e = BigInt.parse(symmKey);
    } while (((e.compareTo(BigInt.one) <= 0) || (e.compareTo(phi) >= 0)) ||
        (!(e.gcd(phi) == BigInt.one)));
    BigInt d = e.modInverse(phi);
    CryptAsymmPublicKey pub = CryptAsymmPublicKey.createFromNums(e, n);
    CryptAsymmPrivateKey priv = CryptAsymmPrivateKey.createFromNums(d, n);
    return new CryptAsymmKeysPair(pub, priv);
  }
}
