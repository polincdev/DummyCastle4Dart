library pl.polinc.dummycastle.random;

import 'dart:math';


enum RandomClientMode { ALPHA, ALPHANUMERIC, NUMERIC }

class RandomClient {
  static var rnd = new Random();

  static String generateRandomString(
      int length, RandomClientMode mode, bool nonleadzero) {
    StringBuffer buffer = new StringBuffer();
    String characters = "";
    switch (mode) {
      case RandomClientMode.ALPHA:
        characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        break;
      case RandomClientMode.ALPHANUMERIC:
        characters =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        break;
      case RandomClientMode.NUMERIC:
        characters = "1234567890";
        break;
    }
    int charactersLength = characters.length;
    for (int i = 0; i < length; i++) {
      int index = generateNextRandomInt(charactersLength);

      int ch = characters.codeUnitAt(index);
      if (nonleadzero && (ch == '0'.codeUnitAt(0))) {
        index = generateNextRandomInt(charactersLength - 1);
      }
      buffer.write(String.fromCharCode(characters.codeUnitAt(index)));
    }
    return buffer.toString();
  }

  static int generateRandomIntWithBits(int nbits) {
    int seed = (DateTime.now().microsecondsSinceEpoch +
        DateTime.now().millisecondsSinceEpoch);
    return generateRandomIntWithSeedAndBits(seed, nbits);
  }

  static int generateRandomIntWithSeedAndBits(int seed, int nbits) {
    int x = seed;
    x = (x ^ (x << 21));
    x = (x ^ (x >> 35));
    x = (x ^ (x << 4));
    seed = x;
    x &= ((1 << nbits) - 1);
    return x;
  }

  static int generateRandomInt() {
    //int seed = (DateTime.now().microsecondsSinceEpoch + DateTime.now().millisecondsSinceEpoch);
    int seed = rnd.nextInt(4294967296);

    return generateRandomIntWithSeedAndBits(seed, 32);
  }

  static int generateNextRandomInt(int cap) {
    int num = (generateRandomInt() % cap);
    return (num > 0) ? num : (-num);
  }

  static String generateNextDeterministicStr(List<int> salt, int posStart,
      int length, RandomClientMode mode, bool nonleadzero) {
    List<int> ibuf = salt; //Coder.getBytesSimple(salt );
    int iLen = ibuf.length;
    int seed = 0;
    for (int i = 0; i < iLen; i++) {
      seed = (seed ^ ibuf[i]);
    }
    StringBuffer buffer = new StringBuffer();
    String characters = "";
    switch (mode) {
      case RandomClientMode.ALPHA:
        characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        break;
      case RandomClientMode.ALPHANUMERIC:
        characters =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        break;
      case RandomClientMode.NUMERIC:
        characters = "1234567890";
        break;
    }
    int charactersLength = characters.length;
    for (int i = 0; i < length; i++) {
      int index =
          ((salt[(posStart + i) % salt.length] ^ (seed + (posStart + i))) %
              charactersLength);
      int ch = characters.codeUnitAt(index);
      if (nonleadzero && (ch == '0'.codeUnitAt(0))) {
        index =
            ((salt[(posStart + i) % salt.length] ^ (seed * (posStart + i))) %
                (charactersLength - 1));
      }
      buffer.write(String.fromCharCode(characters.codeUnitAt(index)));
    }
    return buffer.toString();
  }
}
