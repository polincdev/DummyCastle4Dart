library pl.polinc.dummycastle.hash;

import 'dart:core';
import '../coding/Coder.dart';


class HasherClient {
  String saltStr = "";
  List<int> saltBytes = [];
  int saltSize = 0;
  String keyStr = "";
  List<int> keyBytes = [];
  int keySize = 0;

  static List<int> hash(List<int> textInput, int outputLen) {
    int iLen = textInput.length;
    List<int> ibuf = textInput;
    List<int> obuf = new List.filled(outputLen, 0);
    List<int> salt = new List.filled(outputLen, 0);
    List<int> pass = new List.filled(outputLen, 0);
    int seed = 0;
    for (int i = 0; i < iLen; i++) {
      seed = (seed ^ ibuf[i]);
    }
    for (int i = 0; i < salt.length; i++) {
      salt[i] = (seed ^ ibuf[i % iLen]);
    }

    int hash = 1;
    for (int i = 0; i < pass.length; i++) {
      hash = (((hash << 5) + hash) + ibuf[i % iLen]);
      pass[i] = ((seed ^ ibuf[i % iLen]) ^ hash);
    }
    HasherClient.hashBytes(pass, ibuf, obuf, iLen, outputLen, salt);

    return Coder.cleanByteList(obuf);
  }

  static int hashBytes(List<int> pass, List<int> ibuf, List<int> obuf, int ilen,
      int olen, List<int> salt) {
    int plen = pass.length;
    int i;
    int n = 0;
    int p = (-1);
    int seed = 0;
    int rval;
    if (ilen < 0) {
      ilen = ibuf.length;
    }
    for ((i = 1); i < salt.length; i++) {
      seed = (seed ^ salt[i]);
    }
    p = (seed % plen);
    for ((i = 0); i < olen; i++) {
      p++;
      if (p >= plen) {
        p = 0;
      }
      rval = pass[p];
      if (p == (seed % plen)) {
        seed = (pass[p] ^ seed);
      }
      rval = (pass[p] ^ seed);
      obuf[n % olen] = (ibuf[i% ilen] ^ rval);

      n++;
    }
    return ilen;
  }

  String setSalt(String saltStr) {
    if (saltStr == null) {
      int hash = DateTime.now().millisecondsSinceEpoch;
      for (int i = 0; i < keyStr.length; i++) {
        hash = (((hash << 5) + hash) + keyStr.codeUnitAt(i));
      }
      saltStr = hash.toString();
    }
    this.saltStr = saltStr;
    saltBytes = Coder.getBytesSimple(saltStr);
    saltSize = saltStr.length;
    return saltStr;
  }
}
