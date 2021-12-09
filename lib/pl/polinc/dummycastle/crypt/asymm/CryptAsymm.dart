library pl.polinc.dummycastle.crypt.asymm;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'CryptAsymmKey.dart';
import 'CryptAsymmClient.dart';
import '../symm/CryptSymmKey.dart';
import '../../random/RandomClient.dart';
import '../../coding/Coder.dart';


class CryptAsymm {
  static List<int> encryptStream(List<int> plainData, CryptAsymmKey key) {
    int keySize = key.getKeySize() ~/ 8;
    if (keySize > plainData.length) keySize = plainData.length;
    String symmKey = RandomClient.generateRandomString(
        keySize, RandomClientMode.ALPHANUMERIC, false);

    BigInt gemStr = Coder.readBytes(Coder.getBytesSimple(symmKey)
        .reversed
        .toList()); //must be reversed to read to
    BigInt enc = gemStr.modPow(key.getExponent(), key.getProduct());
    List<int> gem = Coder.getBytesSimple(enc.toString());
    CryptAsymmClient cryptClient =
        new CryptAsymmClient(new CryptSymmKey.fromStr(symmKey));
    List<int> encryptedData = cryptClient.encrypt(plainData);
    int gemLen = gem.length;
    List<int> encryptedDataWithGem =
        new List.filled(((gemLen + 4) + encryptedData.length), 0);

    List<int> gemLenBytes = Coder.intToByteArray(gemLen);
    for (int a = 0; a < 4; a++) {
      encryptedDataWithGem[a] = gemLenBytes[a];
    }

    for (int a = 0; a < gemLen; a++) {
      encryptedDataWithGem[a + 4] = gem[a];
    }
    int a = (gemLen + 4);
    int b = 0;
    for (; a < ((gemLen + 4) + encryptedData.length); a++, b++) {
      encryptedDataWithGem[a] = encryptedData[b];
    }

    return encryptedDataWithGem;
  }

  static List<int> decryptStream(
      List<int> encryptedDataWithGem, CryptAsymmKey key) {
    List<int> gemLenBytes = new List.filled(4, 0);
    for (int a = 0; a < 4; a++) {
      gemLenBytes[a] = encryptedDataWithGem[a];
    }
    int gemLen = Coder.fromByteArray(gemLenBytes);

    List<int> gemEnc = new List.filled(gemLen, 0);
    for (int a = 0; a < gemLen; a++) {
      gemEnc[a] = encryptedDataWithGem[a + 4];
    }

    BigInt gemStr =
        BigInt.parse(String.fromCharCodes(Uint8List.fromList(gemEnc)));
    BigInt enc = gemStr.modPow(key.getExponent(), key.getProduct());
    //List<int> gem = Coder.getBytesSimple(enc.toString());
    String symmKey = utf8.decode(Coder.writeBigInt(enc).reversed.toList());

    List<int> encryptedData =
        new List.filled((encryptedDataWithGem.length - (gemLen + 4)), 0);
    for (int a = 0; a < encryptedData.length; a++) {
      encryptedData[a] = encryptedDataWithGem[(gemLen + 4) + a];
    }

    CryptAsymmClient cryptClient =
        new CryptAsymmClient(new CryptSymmKey.fromStr(symmKey));
    List<int> plainData = cryptClient.decrypt(encryptedData);

    return plainData;
  }
}
