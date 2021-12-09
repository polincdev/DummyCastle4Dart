library pl.polinc.dummycastle;

import 'crypt/symm/CryptSymmKey.dart';
import 'crypt/symm/CryptSymm.dart';
import 'random/RandomClient.dart';
import 'coding/Coder.dart';
import 'crypt/asymm/CryptAsymmKey.dart';
import 'crypt/asymm/CryptAsymmKeysPair.dart';
import 'crypt/asymm/CryptAsymmKeys.dart';
import 'crypt/asymm/CryptAsymmPublicKey.dart';
import 'crypt/asymm/CryptAsymmPrivateKey.dart';
import 'crypt/asymm/CryptAsymm.dart';
import 'coding/HexCoder.dart';
import 'hash/HasherClient.dart';
import 'hash/HashClient.dart';
import 'hash/PermutClient.dart';
import 'obfuscate/ObfuscateClient.dart';

///author polinc
///
class DummyCastle {
  List<int> resultBytes = [];
  bool error = false;
  Exception exception = new Exception("OK");
  CryptSymmKey cryptSymmKey = CryptSymmKey.empty();

  ///Encrypts provided plain text using symmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded. Use decryptSymm() do
  ///decrypt the result.
  ///
  ///param plainText to encrypt.
  ///return this object for chaining.
  ///
  DummyCastle encryptSymmWith(String plainText) {
    if (((plainText == null) || plainText.isEmpty) || (cryptSymmKey == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = CryptSymm.encryptStream(
          Coder.getBytesSimple(plainText), cryptSymmKey);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Encrypts internally a text provided by a previous operation using symmetric
  ///encryption. The result may be obtained using getResult() method and it is not
  ///encoded. Use decryptSymm() do decrypt the result.
  ///
  ///return this object for chaining.
  ///
  DummyCastle encryptSymm() {
    if (((resultBytes == null || resultBytes.length == 0) ||
            resultBytes.length == 0) ||
        (cryptSymmKey == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = CryptSymm.encryptStream(resultBytes, cryptSymmKey);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Decrypts provided plain text using symmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded.
  ///
  ///param secretText to decrypt.
  ///return this object for chaining.
  ///
  DummyCastle decryptSymmWith(String secretText) {
    if (((secretText == null) || secretText.isEmpty) ||
        (cryptSymmKey == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes = CryptSymm.decryptStream(
          Coder.decodeString2Bytes(secretText), cryptSymmKey);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Decrypts internally a text provided by previous operations using symmetric
  ///encryption. The result may be obtained using getResult() method and it is not
  ///encoded.
  ///
  ///return this object for chaining.
  ///
  DummyCastle decryptSymm() {
    if (((resultBytes == null || resultBytes.length == 0)) ||
        (cryptSymmKey == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = CryptSymm.decryptStream(resultBytes, cryptSymmKey);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Encrypts provided plain text using symmetric encryption. The result may be obtained using getResult() method.
  ///
  ///param plainText to encrypt and encode.
  ///param keyPos    starting position of the key used to encrypt previous chunks
  ///                 of data.
  ///return this object for chaining.
  ///
  DummyCastle encryptSymmFromWith(String plainText, int keyPos) {
    if ((((plainText == null) || plainText.isEmpty) ||
            (cryptSymmKey == null)) ||
        (keyPos < 0)) {
      exception = new Exception("Empty or null or <0 argument");
      error = true;
      return this;
    }

    try {
      resultBytes =
          CryptSymm.encryptStreamFrom(resultBytes, cryptSymmKey, keyPos);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Decodes and decrypts provided text using symmetric encryption. The result may
  ///be obtained using getResult() method.
  ///
  ///param secretText to decode and decrypt.
  ///param keyPos     starting position of the key used to decrypt previous
  ///                  chunks of data.
  ///return this object for chaining.
  ///
  DummyCastle decryptSymmFromWith(String secretText, int keyPos) {
    if ((((secretText == null) || secretText.isEmpty) ||
            (cryptSymmKey == null)) ||
        (keyPos < 0)) {
      exception = new Exception("Empty or null or <0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = CryptSymm.decryptStreamFrom(
          Coder.decodeString2Bytes(secretText), cryptSymmKey, keyPos);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Retrieves a key that was previously generated using genSymmKey() method for
  ///the purpose of symmetric encryption. If the genSymmKey() has not been called
  ///before this method, it generates a default key.
  ///
  ///return CryptSymmKey object containing symmetric key data
  ///
  CryptSymmKey getSymmKey() {
    try {
      if (cryptSymmKey != null) {
        return cryptSymmKey;
      } else {
        return new CryptSymmKey.empty();
      }
    } on Exception catch (e) {
      exception = e;
      error = true;
      cryptSymmKey = CryptSymmKey.empty();
      return cryptSymmKey;
    }
  }

  ///Generates a default key for the purpose of symmetric encryption. The key may
  ///be obtained using getSymmKey() method.
  ///
  ///return this object for chaining.
  ///
  DummyCastle genSymmKey() {
    try {
      cryptSymmKey = new CryptSymmKey.empty();
    } on Exception catch (e) {
      exception = e;
      error = true;
      cryptSymmKey = CryptSymmKey.empty();
    }
    return this;
  }

  ///Generates a key based on provided seed data for the purpose of symmetric
  ///encryption.
  ///
  ///param keySeed any kind of string data that will be used to generated the
  ///               key. The same seed would provide the same key.
  ///return this object for chaining.
  ///
  DummyCastle genSymmKeyWith(String keySeed) {
    if ((keySeed == null) || keySeed.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      this.cryptSymmKey = new CryptSymmKey.fromStr(keySeed);
    } on Exception catch (e) {
      exception = e;
      error = true;
      cryptSymmKey = CryptSymmKey.empty();
    }

    return this;
  }

  ///Generates a random numeric value as a string. No negative nor leading zero.
  ///The result may be obtained using getResult() method.
  ///
  ///param lengthInDigits the size of the result.
  ///return this object for chaining.
  ///
  DummyCastle randomNumWith(int lengthInDigits) {
    if (lengthInDigits < 0) {
      exception = new Exception("<0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(RandomClient.generateRandomString(
          lengthInDigits, RandomClientMode.NUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a random string. The result may be obtained using getResult()
  ///method.
  ///
  ///param lengthInChars the size of the result.
  ///return this object for chaining.
  ///
  DummyCastle randomStrWith(int lengthInChars) {
    if (lengthInChars < 0) {
      exception = new Exception("<0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(RandomClient.generateRandomString(
          lengthInChars, RandomClientMode.ALPHANUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a random numeric value as a string based on a provided seed which
  ///guarantees the result will be always the same if you provide the method with
  ///the same seed(idepotency). The result may be obtained using getResult()
  ///method.
  ///
  ///param seed           any kind of string. May not be null nor empty.
  ///param lengthInDigits the size of the result.
  ///return this object for chaining.
  ///
  DummyCastle randomDeterministicNumWith(String seed, int lengthInDigits) {
    if (((seed == null) || seed.isEmpty) || (lengthInDigits < 0)) {
      exception = new Exception("<0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(
          RandomClient.generateNextDeterministicStr(Coder.getBytesSimple(seed),
              0, lengthInDigits, RandomClientMode.NUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a random numeric value as a string based on a provided seed which
  ///guarantees the result will be always the same if you provide the method with
  ///the same seed(idepotency). The result may be obtained using getResult()
  ///method.
  ///
  ///param seed          any kind of string May not be null nor empty.
  ///param lengthInChars the size of the result.
  ///return this object for chaining.
  ///
  DummyCastle randomDeterministicStrWith(String seed, int lengthInChars) {
    if (((seed == null) || seed.isEmpty) || (lengthInChars < 0)) {
      exception = new Exception("Empty or null or <0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(
          RandomClient.generateNextDeterministicStr(Coder.getBytesSimple(seed),
              0, lengthInChars, RandomClientMode.ALPHANUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a random numeric value as a string based on a provided seed which
  ///guarantees the result will be always the same if you provide the method with
  ///the same seed(idepotency). The result is generated from a certain point. The
  ///result may be obtained using getResult() method.
  ///
  ///param seed           any kind of string. May not be null nor empty.
  ///param lengthInDigits the size of the result.
  ///param resPos         starting point of a deterministic result.
  ///return this object for chaining.
  ///
  DummyCastle randomDeterministicNumFromWith(
      String seed, int lengthInDigits, int resPos) {
    if ((((seed == null) || seed.isEmpty) || (lengthInDigits < 0)) ||
        (resPos < 0)) {
      exception = new Exception("Empty or null or <0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(
          RandomClient.generateNextDeterministicStr(Coder.getBytesSimple(seed),
              resPos, lengthInDigits, RandomClientMode.NUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a string based on a provided seed which guarantees the result will
  ///be always the same if you provide the method with the same seed(idepotency).
  ///The result is generated from certain point. The result may be obtained using
  ///getResult() method.
  ///
  ///param seed          any kind of string. May not be null nor empty.
  ///param lengthInChars the size of the result.
  ///param keyPos        starting point of a deterministic result.
  ///return this object for chaining.
  ///
  DummyCastle randomDeterministicStrFromWith(
      String seed, int lengthInChars, int keyPos) {
    if ((((seed == null) || seed.isEmpty) || (lengthInChars < 0)) ||
        (keyPos < 0)) {
      exception = new Exception("Empty or null or <0 argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(
          RandomClient.generateNextDeterministicStr(Coder.getBytesSimple(seed),
              keyPos, lengthInChars, RandomClientMode.ALPHANUMERIC, true));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Encrypts provided text using asymmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded. Use decryptSymm() to
  ///decrypt the result. Use decryptAsymm() to decrypt.
  ///
  ///param plainText to encrypt.
  ///param key       contains data used to encrypt plain text. If it is an
  ///                 instance of a CryptAsymmPublicKey class, a
  ///                 CryptAsymmPrivateKey object should be used to decrypt the
  ///                 text.
  ///return this object for chaining.
  ///
  DummyCastle encryptAsymmWith(String plainText, CryptAsymmKey key) {
    if (((plainText == null) || plainText.isEmpty) || (key == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes =
          CryptAsymm.encryptStream(Coder.getBytesSimple(plainText), key);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Encrypts data internally using asymmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded. Use decryptSymm() to
  ///decrypt the result. Use decryptAsymm() to decrypt.
  ///
  ///param key contains data used to encrypt plain text. If it is an instance of
  ///           a CryptAsymmPublicKey class, a CryptAsymmPrivateKey object should
  ///           be used to decrypt the text.
  ///return this object for chaining.
  ///
  DummyCastle encryptAsymmWithKey(CryptAsymmKey key) {
    if ((resultBytes == null || resultBytes.length == 0) || (key == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes = CryptAsymm.encryptStream(resultBytes, key);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Decrypts provided text using asymmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded.
  ///
  ///param secretText text to decrypt.
  ///param key        contains data used to crypt plain text. It should be an
  ///                  instance of a CryptAsymmPublicKey class if
  ///                  CryptAsymmPrivateKey was used to encrypt the text.
  ///return this object for chaining.
  ///
  DummyCastle decryptAsymmWith(String secretText, CryptAsymmKey key) {
    if (((secretText == null) || secretText.isEmpty) || (key == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes =
          CryptAsymm.decryptStream(Coder.decodeString2Bytes(secretText), key);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Decrypts dta internally using asymmetric encryption. The result may be
  ///obtained using getResult() method and it is not encoded.
  ///
  ///param key contains data used to crypt plain text. It should be an instance
  ///           of a CryptAsymmPublicKey class if CryptAsymmPrivateKey was used to
  ///           encrypt the text.
  ///return this object for chaining.
  ///
  DummyCastle decryptAsymmWithKey(CryptAsymmKey key) {
    if ((resultBytes == null || resultBytes.length == 0) || (key == null)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes = CryptAsymm.decryptStream(resultBytes, key);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Generates a pair of keys for the purpose of asymmetric encryption.
  ///
  ///return CryptAsymmKeysPair object containing asymmetric keys data, both
  ///        public and private.
  ///
  CryptAsymmKeysPair genAsymmKeys() {
    try {
      CryptAsymmKeys cryptAsymmKeys = new CryptAsymmKeys();
      return cryptAsymmKeys.generateKeys();
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    CryptAsymmKeys cryptAsymmKeys = new CryptAsymmKeys();
    return cryptAsymmKeys.generateKeys();
  }

  ///Generates a pair of keys for the purpose of asymmetric encryption of the
  ///specified size.
  ///
  ///param keySizeType size of the keys. Must be one of
  ///                   CryptAsymmKeys.KEY_SIZE_TYPE constants.
  ///return CryptAsymmKeysPair object containing asymmetric keys data, both
  ///        public and private.
  ///
  CryptAsymmKeysPair genAsymmKeysWithKeySizeType(
      ASYMM_KEY_SIZE_TYPE keySizeType) {
    try {
      return new CryptAsymmKeys().generateKeys();
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    CryptAsymmKeys cryptAsymmKeys = new CryptAsymmKeys();
    return cryptAsymmKeys.generateKeys();
  }

  ///Generates a public key for the purpose of asymmetric encryption.
  ///
  ///param keyData specific data containing a private key.
  ///
  ///return CryptAsymmKeysPair object containing asymmetric keys data, both
  ///        public and private.
  ///
  CryptAsymmPublicKey genAsymmPublicKeyWith(String keyData) {
    try {
      return CryptAsymmPublicKey.createFromString(keyData);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return CryptAsymmPublicKey.createFromNums(BigInt.zero, BigInt.zero);
  }

  ///Generates a private key for the purpose of asymmetric encryption.
  ///
  ///param keyData specific data containing a private key.
  ///return CryptAsymmKeysPair object containing asymmetric keys data, both
  ///        public and private.
  ///
  CryptAsymmPrivateKey genAsymmPrivateKeyWith(String keyData) {
    try {
      return CryptAsymmPrivateKey.createFromString(keyData);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return CryptAsymmPrivateKey.createFromNums(BigInt.zero, BigInt.zero);
  }

  ///Encodes a text using HEX encoding. The result may be obtained using
  ///getResult() method.
  ///
  ///param textToDecode text to be encoded. Must be non-null and not empty.
  ///return this object for chaining.
  ///
  String encodeWith(String textToDecode) {
    if ((textToDecode == null) || textToDecode.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return "";
    }

    try {
      return Coder.encode(textToDecode);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return "";
  }

  ///Decodes a text using HEX encoding. The result may be obtained using
  ///getResult().
  ///
  ///param encodedText text to be decoded. Must be non-null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle decodeWith(String encodedText) {
    if ((encodedText == null) || encodedText.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.decodeString2Bytes(encodedText);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return this;
  }

  ///Hashes(reduces) a provided text into a long number represented as a string.
  ///
  ///param textToHash to hash. Must not be null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle hashToNumWith(String textToHash) {
    if ((textToHash == null) || textToHash.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }

    try {
      resultBytes = Coder.getBytesSimple(
          HashClient.defaultHash(Coder.getBytesSimple(textToHash)).toString());
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Hashes(reduces) a text internally into a long number represented as a string.
  ///The result may be obtained using getResult() method.
  ///
  ///return this object for chaining.
  ///
  DummyCastle hashToNum() {
    if ((resultBytes == null || resultBytes.length == 0)) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes =
          Coder.getBytesSimple(HashClient.defaultHash(resultBytes).toString());
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Hashes(reduces) a provided text into a 8 characters string. The result may be
  ///obtained using getResult() method.
  ///
  ///param textToHash to hash. Must not be null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle hashToStrWith(String textToHash) {
    if ((textToHash == null) || textToHash.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = HasherClient.hash(Coder.getBytesSimple(textToHash), 8);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Hashes(reduces) a text internally into a string. The result may be obtained
  ///using getResult() method.
  ///
  ///return this object for chaining.
  ///
  DummyCastle hashToStr() {
    if (((resultBytes == null || resultBytes.length == 0))) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = HasherClient.hash(resultBytes, 8);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Shuffles randomly characters internally.
  ///
  ///param seed - key data used to shuffle
  ///return
  ///
  DummyCastle shuffle() {
    if (((resultBytes == null || resultBytes.length == 0))) {
      exception = new Exception("Empty or null");
      error = true;
      return this;
    }
    try {
      resultBytes = PermutClient.shuffle(resultBytes);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Shuffles randomly characters in a text.
  ///
  ///param textToShuffle. May not be null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle shuffleWith(String textToShuffle) {
    if ((textToShuffle == null || textToShuffle.isEmpty)) {
      exception = new Exception("Empty or null");
      error = true;
      return this;
    }
    try {
      resultBytes = PermutClient.shuffle(Coder.getBytesSimple(textToShuffle));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Shuffles characters internally based on a provided seed. It always provides
  ///the same result give the same input data.
  ///
  ///param seed - key data used to shuffle
  ///return
  ///
  DummyCastle shuffleDeterministic(String seed) {
    if ((resultBytes == null || resultBytes.length == 0) ||
        (seed == null || seed.isEmpty)) {
      exception = new Exception("Empty or null");
      error = true;
      return this;
    }
    try {
      resultBytes = PermutClient.shuffleDeterministic(
          resultBytes, Coder.getBytesSimple(seed));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Shuffles characters in a text based on a provided seed. It always provides
  ///the same result give the same input data.
  ///
  ///param textToShuffle - text to shuffle
  ///param seed          - key data used to shuffle
  ///return
  ///
  DummyCastle shuffleDeterministicWith(String textToShuffle, String seed) {
    if ((textToShuffle == null || textToShuffle.isEmpty) ||
        (resultBytes == null || resultBytes.length == 0) ||
        (seed == null || seed.isEmpty)) {
      exception = new Exception("Empty or null");
      error = true;
      return this;
    }
    try {
      resultBytes = PermutClient.shuffleDeterministic(
          Coder.getBytesSimple(textToShuffle), Coder.getBytesSimple(seed));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Obfuscates(hide) a provided text. The result may be obtained using
  ///getResult() method. Use unobfuscate() method to reveal the text.
  ///
  ///param textToObfuscate to obfuscate. Must not be null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle obfuscateWith(String textToObfuscate) {
    if ((textToObfuscate == null) || textToObfuscate.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes =
          ObfuscateClient.obfuscate(Coder.getBytesSimple(textToObfuscate));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Obfuscates(hides) a text internally. The result may be obtained using
  ///getResult() method.
  ///
  ///return this object for chaining.
  ///
  DummyCastle obfuscate() {
    if (((resultBytes == null || resultBytes.length == 0))) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = ObfuscateClient.obfuscate(resultBytes);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Unobfuscates(reveals) a provided text. The result may be obtained using
  ///getResult() method.
  ///
  ///param obfuscatedText to obfuscate. Must not be null nor empty.
  ///return this object for chaining.
  ///
  DummyCastle unobfuscateWith(String obfuscatedText) {
    if ((obfuscatedText == null) || obfuscatedText.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes =
          ObfuscateClient.unobfuscate(Coder.decodeString2Bytes(obfuscatedText));
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Unobfuscates(reveals) a text provided by a previous operation. The result may
  ///be obtained using getResult() method.
  ///
  ///return this object for chaining.
  ///
  DummyCastle unobfuscate() {
    if ((resultBytes == null) || resultBytes.length == 0) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = ObfuscateClient.unobfuscate(resultBytes);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///return results of all operations encoded using the default encoding - HEX.
  ///        The same as toString(). If no operation is executed the result will
  ///        be an empty string.
  ///
  String getResult() {
    try {
      return HEX.encode(resultBytes);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return "";
  }

  ///Returns unencoded raw byte data which is a result of library's operations
  ///
  ///return unencoded bytes
  ///
  List<int> getResultDecodedRaw() {
    try {
      return resultBytes;
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return [];
  }

  ///Returns unencoded raw string data which is a result of library's operations
  ///
  ///return unencoded string
  ///
  String getResultDecoded() {
    try {
      return Coder.getStringSimple(resultBytes);
    } on Exception catch (e) {
      exception = e;
      error = true;
    }
    return "";
  }

  ///Inserts unencoded raw string data to work on it.
  ///
  ///param plainText - unencoded plain data as string.
  ///
  ///return this object
  ///
  DummyCastle fromStringDecoded(String plainText) {
    if ((plainText == null) || plainText.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.getBytesSimple(plainText);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Inserts unencoded raw byte data to work on it.
  ///
  ///param plainText - unencoded plain byte data.
  ///
  ///return this object
  ///
  DummyCastle fromBytesDecoded(List<int> plainText) {
    if ((plainText == null) || plainText.length == 0) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = plainText;
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Inserts encoded with the library's default encoding string data to work on
  ///it.
  ///
  ///param encodedText - unencoded plain data as string.
  ///
  ///return this object
  ///
  DummyCastle fromStringEncoded(String plainText) {
    if ((plainText == null) || plainText.isEmpty) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.decodeString2Bytes(plainText);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///Inserts encoded with the library's default encoding byte data to work on it.
  ///
  ///param encodedText - encoded data.
  ///
  ///return this object
  ///
  DummyCastle fromBytesEncoded(List<int> plainText) {
    if ((plainText == null) || plainText.length == 0) {
      exception = new Exception("Empty or null argument");
      error = true;
      return this;
    }
    try {
      resultBytes = Coder.decodeBytes(plainText);
    } on Exception catch (e) {
      setUpError(e);
    }
    return this;
  }

  ///return results of all operations. Encoded with default encoding method -
  ///        HEX. The same as toString(). If not operation is executed the result
  ///        will be an empty string. The same as getResult()
  ///
  String toString() {
    return getResult();
  }

  ///Returns unencoded data being as a string. It is a result of all operations.
  ///
  ///return raw unencoded data.
  ///
  String toStringDecoded() {
    return getResultDecoded();
  }

  ///Resets the whole object and cleans its memory. Resets also the error flag.
  ///
  ///
  void reset() {
    resultBytes = [];
    error = false;
    exception = new Exception("OK");
    cryptSymmKey = CryptSymmKey.empty();
  }

  ///return true if an exception was thrown during any of previous operation.
  ///        Check this flag and use getException() to get the exception.
  ///
  bool isError() {
    return error;
  }

  ///return exception that was thrown during any of previous operation.
  ///
  Exception getException() {
    return exception;
  }

  ///Prepares exception
  ///param e exception to setup
  ///
  void setUpError(Exception e) {
    exception = e;
    error = true;
    resultBytes = [];
  }
}
