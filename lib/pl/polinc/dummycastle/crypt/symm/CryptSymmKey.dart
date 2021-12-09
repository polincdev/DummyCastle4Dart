library pl.polinc.dummycastle.crypt.symm;

import 'dart:core';

import '../../random/RandomClient.dart';
import '../../coding/Coder.dart';

enum KEY_TYPE { TYPE_ROT, TYPE_SEED }

class CryptSymmKey {
  KEY_TYPE type = KEY_TYPE.TYPE_SEED;
  String keyStr = "";
  List<int> keyBytes = [];

  int keySize = 0;
  int seed = 0;

  CryptSymmKey(String keyStr, KEY_TYPE type) {
    this.type = type;
    this.keyStr = keyStr;
    keyBytes = Coder.getBytesSimple(keyStr);
    keySize = keyStr.length;

    if (type == KEY_TYPE.TYPE_SEED)
      for (int i = 0; i < keySize; i++) seed = (seed ^ keyBytes[i]);
  }

  CryptSymmKey.empty() {
    this.type = KEY_TYPE.TYPE_SEED;
    this.keyStr = RandomClient.generateRandomString(
        32, RandomClientMode.ALPHANUMERIC, true);
    keyBytes = Coder.getBytesSimple(keyStr);
    keySize = keyStr.length;

    if (type == KEY_TYPE.TYPE_SEED)
      for (int i = 0; i < keySize; i++) seed = (seed ^ keyBytes[i]);
  }

  CryptSymmKey.fromStr(String keyStr) {
    this.type = KEY_TYPE.TYPE_SEED;
    this.keyStr = keyStr;
    keyBytes = Coder.getBytesSimple(keyStr);
    keySize = keyStr.length;

    if (type == KEY_TYPE.TYPE_SEED)
      for (int i = 0; i < keySize; i++) seed = (seed ^ keyBytes[i]);
  }

  int getKeyAt(int pos) {
    if (type == KEY_TYPE.TYPE_ROT) {
      return keyStr.codeUnitAt(pos % keySize);
    } else {
      if (type == KEY_TYPE.TYPE_SEED) {
        return keyStr.codeUnitAt(pos % keySize) ^ (seed + pos);
      } else {
        return keyStr.codeUnitAt(pos % keySize);
      }
    }
  }

  String toString() {
    return toStringWithLen(keySize);
  }

  String toStringWithLen(int len) {
    if (len < 0) {
      return "";
    }
    StringBuffer sb = new StringBuffer();
    if (type == KEY_TYPE.TYPE_ROT) {
      for (int i = 0; i < len; i++) {
        sb.write(keyStr.codeUnitAt(i % keySize));
      }
      return sb.toString();
    } else {
      if (type == KEY_TYPE.TYPE_SEED) {
        for (int i = 0; i < len; i++) {
          sb.write((keyStr.codeUnitAt(i % keySize) ^ seed) ^ i);
        }
        return sb.toString();
      }
    }
    return keyStr;
  }

  int getKeySize() {
    return keySize;
  }
}
