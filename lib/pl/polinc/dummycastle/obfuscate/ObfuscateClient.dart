library pl.polinc.dummycastle.obfuscate;


import 'dart:core';

import '../coding/Coder.dart';
import '../random/RandomClient.dart';

class ObfuscateClient {
  static List<int> obfuscate(List<int> ibuf) {
    List<int> key = Coder.getBytesSimple(
        RandomClient.generateNextDeterministicStr(
            Coder.getBytesSimple((ibuf.length.toString())),
            0,
            8,
            RandomClientMode.ALPHANUMERIC,
            true));

    int iLen = ibuf.length;
    List<int> result = new List.filled(iLen, 0);
    for (int i = 0; i < iLen; i++) {
      result[i] = (ibuf[i] + key[i % key.length]);
    }
    return result;
  }

  static List<int> unobfuscate(List<int> ibuf) {
    List<int> key = Coder.getBytesSimple(
        RandomClient.generateNextDeterministicStr(
            Coder.getBytesSimple((ibuf.length.toString())),
            0,
            8,
            RandomClientMode.ALPHANUMERIC,
            true));

    int iLen = ibuf.length;
    List<int> result = new List.filled(iLen, 0);
    for (int i = 0; i < iLen; i++) {
      result[i] = (ibuf[i] - key[i % key.length]);
    }
    return result;
  }
}
