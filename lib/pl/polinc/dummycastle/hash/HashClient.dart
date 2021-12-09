library pl.polinc.dummycastle.hash;

import 'dart:core';

class HashClient {
  static int defaultHash(List<int> str) {
    return DJBHash(str);
  }

  static int DJBHash(List<int> str) {
    int hash = 1;
    for (int i = 0; i < str.length; i++) {
      hash = (hash << 5) + hash;
      hash = hash * str.elementAt(i);
    }
    return hash;
  }
}
