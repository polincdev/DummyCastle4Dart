library pl.polinc.dummycastle.coding;

import 'dart:convert';
import 'dart:typed_data';

const hexEncoder = HexEncoder._();

class HexEncoder extends Converter<List<int>, String> {
  const HexEncoder._();

  final int $percent = 0x25;
  final int $dash = 0x2d;
  final int $dot = 0x2e;
  final int zeroCh = 0x30;
  final int $9 = 0x39;
  final int $A = 0x41;
  final int $underscore = 0x5f;
  final int aCh = 0x61;
  final int $f = 0x66;
  final int $z = 0x7a;
  final int $tilde = 0x7e;

  @override
  String convert(List<int> input) => _convert(input, 0, input.length);

  @override
  ByteConversionSink startChunkedConversion(Sink<String> sink) =>
      _HexEncoderSink(sink);
}

class _HexEncoderSink extends ByteConversionSinkBase {
  final Sink<String> _sink;

  _HexEncoderSink(this._sink);

  @override
  void add(List<int> chunk) {
    _sink.add(_convert(chunk, 0, chunk.length));
  }

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, chunk.length);
    _sink.add(_convert(chunk, start, end));
    if (isLast) _sink.close();
  }

  @override
  void close() {
    _sink.close();
  }
}

String _convert(List<int> bytes, int start, int end) {
  var buffer = Uint8List((end - start) * 2);
  var bufferIndex = 0;
  var byteOr = 0;
  for (var i = start; i < end; i++) {
    var byte = bytes[i];
    byteOr |= byte;
    buffer[bufferIndex++] = _codeUnitForDigit((byte & 0xF0) >> 4);
    buffer[bufferIndex++] = _codeUnitForDigit(byte & 0x0F);
  }

  if (byteOr >= 0 && byteOr <= 255) return String.fromCharCodes(buffer);

  for (var i = start; i < end; i++) {
    var byte = bytes[i];
    if (byte >= 0 && byte <= 0xff) continue;
    throw FormatException(
        "Invalid byte ${byte < 0 ? "-" : ""}0x${byte.abs().toRadixString(16)}.",
        bytes,
        i);
  }

  throw 'unreachable';
}

int _codeUnitForDigit(int digit) {
  int ret = 0;
  if (digit < 10)
    ret = (digit + 0x30);
  else
    ret = (digit + 0x61 - 10);

  return ret;
}
