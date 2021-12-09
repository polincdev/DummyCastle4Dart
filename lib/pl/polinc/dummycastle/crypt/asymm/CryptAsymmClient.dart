library pl.polinc.dummycastle.crypt.asymm;

import '../symm/CryptSymmKey.dart';

class CryptAsymmClient {
  CryptSymmKey cryptSymmKey = CryptSymmKey.empty();

  CryptAsymmClient(CryptSymmKey cryptSymmKey) {
    this.cryptSymmKey = cryptSymmKey;
  }

  List<int> encrypt(List<int> inputStr) {
    return crypt(inputStr);
  }

  List<int> encryptFrom(List<int> inputStr, int keyPos) {
    return cryptFrom(inputStr, keyPos);
  }

  List<int> decrypt(List<int> inputStr) {
    return crypt(inputStr);
  }

  List<int> decryptFrom(List<int> inputStr, int keyPos) {
    return cryptFrom(inputStr, keyPos);
  }

  List<int> crypt(List<int> toEnc) {
    int t = 0;
    List<int> tog = new List.filled(toEnc.length, 0);
    while (t < toEnc.length) {
      int a = toEnc[t];
      int c = (a ^ cryptSymmKey.getKeyAt(t));
      int d = c;
      tog[t] = d;
      t++;
    }
    return tog;
  }

  List<int> cryptFrom(List<int> toEnc, int keyPos) {
    int t = 0;
    List<int> tog = new List.filled(toEnc.length, 0);
    while (t < toEnc.length) {
      int a = toEnc[t];
      int c = (a ^ cryptSymmKey.getKeyAt(t + keyPos));
      int d = c;
      tog[t] = d;
      t++;
    }
    return tog;
  }

  void encryptInside(List<int> inputStr) {
    cryptInside(inputStr);
  }

  void decryptInside(List<int> inputStr) {
    cryptInside(inputStr);
  }

  void cryptInside(List<int> toEnc) {
    int t = 0;
    while (t < toEnc.length) {
      int a = toEnc[t];
      int c = (a ^ cryptSymmKey.getKeyAt(t));
      int d = c;
      toEnc[t] = d;
      t++;
    }
  }
}
