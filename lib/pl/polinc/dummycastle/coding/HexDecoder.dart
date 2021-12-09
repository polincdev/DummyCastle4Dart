library pl.polinc.dummycastle.coding;

import 'dart:convert';
import 'dart:typed_data';

const hexDecoder = HexDecoder._();

class HexDecoder extends Converter<String, List<int>> {
  const HexDecoder._();

  final int $percent = 0x25;
  final int $dash = 0x2d;
  final int $dot = 0x2e;

  final int $9 = 0x39;
  final int $A = 0x41;
  final int $underscore = 0x5f;

  final int $z = 0x7a;
  final int $tilde = 0x7e;

  @override
  List<int> convert(String input) {
    if (!input.length.isEven) {
      throw FormatException(
          "Invalid input length, must be even.", input, input.length);
    }

    var bytes = Uint8List(input.length ~/ 2);
    _decode(input.codeUnits, 0, input.length, bytes, 0);
    return bytes;
  }

  @override
  StringConversionSink startChunkedConversion(Sink<List<int>> sink) =>
      _HexDecoderSink(sink);
}

class _HexDecoderSink extends StringConversionSinkBase {
  final Sink<List<int>> _sink;

  int? _lastDigit;

  _HexDecoderSink(this._sink);

  int digitForCodeUnit(List<int> codeUnits, int index) {
    var codeUnit = codeUnits[index];
    var digit = 0x30 ^ codeUnit;
    if (digit <= 9) {
      if (digit >= 0) return digit;
    } else {
      var letter = 0x20 | codeUnit;
      if (0x61 <= letter && letter <= 0x66) return letter - 0x61 + 10;
    }

    throw FormatException(
        "Invalid hexadecimal code unit "
        "U+${codeUnit.toRadixString(16).padLeft(4, '0')}.",
        codeUnits,
        index);
  }

  @override
  void addSlice(String string, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, string.length);

    if (start == end) {
      if (isLast) _close(string, end);
      return;
    }

    var codeUnits = string.codeUnits;
    Uint8List bytes;
    int bytesStart;
    if (_lastDigit == null) {
      bytes = Uint8List((end - start) ~/ 2);
      bytesStart = 0;
    } else {
      var hexPairs = (end - start - 1) ~/ 2;
      bytes = Uint8List(1 + hexPairs);
      bytes[0] = _lastDigit! + digitForCodeUnit(codeUnits, start);
      start++;
      bytesStart = 1;
    }

    _lastDigit = _decode(codeUnits, start, end, bytes, bytesStart);

    _sink.add(bytes);
    if (isLast) _close(string, end);
  }

  @override
  ByteConversionSink asUtf8Sink(bool allowMalformed) =>
      _HexDecoderByteSink(_sink);

  @override
  void close() => _close();

  /// Like [close], but includes [string] and [index] in the [FormatException]
  /// if one is thrown.
  void _close([String? string, int? index]) {
    if (_lastDigit != null) {
      throw FormatException(
          "Input ended with incomplete encoded byte.", string, index);
    }

    _sink.close();
  }
}

/// A conversion sink for chunked hexadecimal decoding from UTF-8 bytes.
class _HexDecoderByteSink extends ByteConversionSinkBase {
  /// The underlying sink to which decoded byte arrays will be passed.
  final Sink<List<int>> _sink;

  /// The trailing digit from the previous string.
  ///
  /// This will be non-`null` if the most recent string had an odd number of
  /// hexadecimal digits. Since it's the most significant digit, it's always a
  /// multiple of 16.
  int? _lastDigit;

  _HexDecoderByteSink(this._sink);

  int digitForCodeUnit(List<int> codeUnits, int index) {
    var codeUnit = codeUnits[index];
    var digit = 0x30 ^ codeUnit;
    if (digit <= 9) {
      if (digit >= 0) return digit;
    } else {
      var letter = 0x20 | codeUnit;
      if (0x61 <= letter && letter <= 0x66) return letter - 0x61 + 10;
    }

    throw FormatException(
        "Invalid hexadecimal code unit "
        "U+${codeUnit.toRadixString(16).padLeft(4, '0')}.",
        codeUnits,
        index);
  }

  @override
  void add(List<int> chunk) => addSlice(chunk, 0, chunk.length, false);

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, chunk.length);

    if (start == end) {
      if (isLast) _close(chunk, end);
      return;
    }

    Uint8List bytes;
    int bytesStart;
    if (_lastDigit == null) {
      bytes = Uint8List((end - start) ~/ 2);
      bytesStart = 0;
    } else {
      var hexPairs = (end - start - 1) ~/ 2;
      bytes = Uint8List(1 + hexPairs);
      bytes[0] = _lastDigit! + digitForCodeUnit(chunk, start);
      start++;
      bytesStart = 1;
    }

    _lastDigit = _decode(chunk, start, end, bytes, bytesStart);

    _sink.add(bytes);
    if (isLast) _close(chunk, end);
  }

  @override
  void close() => _close();

  /// Like [close], but includes [chunk] and [index] in the [FormatException]
  /// if one is thrown.
  void _close([List<int>? chunk, int? index]) {
    if (_lastDigit != null) {
      throw FormatException(
          "Input ended with incomplete encoded byte.", chunk, index);
    }

    _sink.close();
  }
}

int digitForCodeUnit(List<int> codeUnits, int index) {
  var codeUnit = codeUnits[index];
  var digit = 0x30 ^ codeUnit;
  if (digit <= 9) {
    if (digit >= 0) return digit;
  } else {
    var letter = 0x20 | codeUnit;
    if (0x61 <= letter && letter <= 0x66) return letter - 0x61 + 10;
  }

  throw FormatException(
      "Invalid hexadecimal code unit "
      "U+${codeUnit.toRadixString(16).padLeft(4, '0')}.",
      codeUnits,
      index);
}

/// Decodes [codeUnits] and writes the result into [destination].
///
/// This reads from [codeUnits] between [sourceStart] and [sourceEnd]. It writes
/// the result into [destination] starting at [destinationStart].
///
/// If there's a leftover digit at the end of the decoding, this returns that
/// digit. Otherwise it returns `null`.
int? _decode(List<int> codeUnits, int sourceStart, int sourceEnd,
    List<int> destination, int destinationStart) {
  var destinationIndex = destinationStart;
  for (var i = sourceStart; i < sourceEnd - 1; i += 2) {
    var firstDigit = digitForCodeUnit(codeUnits, i);
    var secondDigit = digitForCodeUnit(codeUnits, i + 1);
    destination[destinationIndex++] = 16 * firstDigit + secondDigit;
  }

  if ((sourceEnd - sourceStart).isEven) return null;
  return 16 * digitForCodeUnit(codeUnits, sourceEnd - 1);
}
