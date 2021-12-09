library pl.polinc.dummycastle.hash;

import 'dart:core';
import 'dart:math';

class PermutClient {
  static Random rnd = new Random();

  static List<int> shuffle(List<int> ar) {
    for (int i = (ar.length - 1); i > 0; i--) {
      int index = rnd.nextInt(i + 1);
      int a = ar[index];
      ar[index] = ar[i];
      ar[i] = a;
    }
    return ar;
  }

  static List<int> shuffleDeterministic(List<int> ar, List<int> seed) {
    for (int i = ar.length - 1; i > 0; i--) {
      int index = seed[i % seed.length] % ar.length;
      // Simple swap
      int a = ar[index];

      ar[index] = ar[i];
      ar[i] = a;
    }
    return ar;
  }
}
