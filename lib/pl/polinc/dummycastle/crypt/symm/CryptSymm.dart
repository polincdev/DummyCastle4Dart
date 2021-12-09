library pl.polinc.dummycastle.crypt.symm;

import 'CryptSymmKey.dart';
import 'CryptClient.dart';

class CryptSymm {
  static List<int> encryptStream(List<int> plainData, CryptSymmKey key) {
    CryptClient cryptClient = new CryptClient.withKey(key);
    List<int> encryptedData = cryptClient.encrypt(plainData);
    return encryptedData;
  }

  static List<int> encryptStreamFrom(
      List<int> plainData, CryptSymmKey key, int keyPos) {
    CryptClient cryptClient = new CryptClient.withKey(key);
    List<int> encryptedData = cryptClient.encryptFrom(plainData, keyPos);
    return encryptedData;
  }

  static List<int> decryptStream(List<int> encryptedData, CryptSymmKey key) {
    CryptClient cryptClient = new CryptClient.withKey(key);
    List<int> plainData = cryptClient.decrypt(encryptedData);
    return plainData;
  }

  static List<int> decryptStreamFrom(
      List<int> encryptedData, CryptSymmKey key, int keyPos) {
    CryptClient cryptClient = new CryptClient.withKey(key);
    List<int> plainData = cryptClient.decryptFrom(encryptedData, keyPos);
    return plainData;
  }
}
