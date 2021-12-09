library pl.polinc.dummycastle.coding;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'HexCoder.dart';

class Coder {
  static String encode(String plainText) {
    return encodeHex(plainText);
  }

  static String decode(String plainText) {
    return decodeHex(plainText);
  }

  static List<int> decodeString2Bytes(String plainText) {
    return HEX.decode(plainText);
  }

  static List<int> encodeBytes(List<int> plainText) {
    return encodeHexBytes(plainText);
  }

  static List<int> decodeBytes(List<int> plainText) {
    return decodeHexBytes(plainText);
  }

  static String encodeBase64(String plainText) {
    final bytes = Coder.getBytesSimple(plainText);
    return base64.encode(bytes);
  }

  static String encodeHex(String plainText) {
    return HEX.encode(Coder.getBytesSimple(plainText));
  }

  static List<int> encodeBase64Bytes(List<int> plainText) {
    final base64Str = base64.encode(plainText);
    return Coder.getBytesSimple(base64Str);
  }

  static List<int> encodeHexBytes(List<int> plainText) {
    return Coder.getBytesSimple(HEX.encode(plainText));
  }

  static String decodeBase64(String plainText) {
    final base64Str = base64.decode(plainText);
    return Coder.getStringSimple(base64Str);
  }

  static String decodeHex(String plainText) {
    return Coder.getStringSimple(HEX.decode(plainText));
  }

  static List<int> decodeBase64Bytes(List<int> plainText) {
    final str = Coder.getStringSimple(plainText);
    final base64Str = base64.decode(str);
    return base64Str;
  }

  static List<int> decodeHexBytes(List<int> plainText) {
    return HEX.decode(Coder.getStringSimple(plainText));
  }

  static List<int> getBytesFromString(String text) {
    var charCodes = text.codeUnits;
    var bytes = Uint16List.fromList(charCodes).buffer.asUint8List();
    return bytes;
  }

  static List<int> getBytesSimple(String text) {
    return utf8.encode(text);
  }

  static String getStringFromBytes(List<int> bytes) {
    return String.fromCharCodes(bytes);
  }

  static String getStringSimple(List<int> bytes) {
    return utf8.decode(bytes);
  }

  static BigInt readBytes(List<int> bytes) {
    BigInt read(int start, int end) {
      if (end - start <= 4) {
        int result = 0;
        for (int i = end - 1; i >= start; i--) {
          result = result * 256 + bytes[i];
        }
        return new BigInt.from(result);
      }
      int mid = start + ((end - start) >> 1);
      var result = read(start, mid) +
          read(mid, end) * (BigInt.one << ((mid - start) * 8));
      return result;
    }

    return read(0, bytes.length);
  }

  static List<int> intToByteArray(int value) {
    return new List<int>.from([value >> 24, value >> 16, value >> 8, value]);
  }

  static int fromByteArray(List<int> bytes) {
    //   return ((((bytes[0] & 15) << 24) | ((bytes[1] & 15) << 16)) | ((bytes[2] & 15) << 8)) | ((bytes[3] & 15) << 0);
    return Uint8List.fromList(bytes).buffer.asByteData().getInt32(0);
  }

  static Uint8List int32bytes(int value) {
    return Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);
  }

  static Uint8List intList2ByteList(List<int> fullList) {
    var bb = BytesBuilder();
    for (int a = 0; a < fullList.length; a++) {
      bb.add(int32bytes(fullList.elementAt(a)));
    }

    return bb.toBytes();
  }

  static List<int> cleanByteList(List<int> fullList) {
    for (int a = 0; a < fullList.length; a++)
      fullList[a] = ((fullList[a] & 0xFF));

    return fullList;
  }

  static Uint8List writeBigInt(BigInt number) {
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = new BigInt.from(256);
    var result = new Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }
}
