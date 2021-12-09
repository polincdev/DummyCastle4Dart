# DummyCastle - Cryptography for dummies.

## What is DummyCastle?

It's a quick and simple solution for developers who want to apply any level of security to their applications and they are not
interested in learning to use available libraries.

## Who is this solution for?
DummyCastle should be used wherever there is a need to protect information that is not essential. For example, to protect:
- API keys
- chats
- messages
- settings
- generally small amount of data

## Who is this solution not for?

DummyCastle should not be used whenever there is a need to secure high-value information. For example, to protect:
- money - ecoins
- secret information
- illegal information
- generally large amounts of data

## Features

The library provides the following features:
- symmetric encryption
- asymmetric encryption
- random generation
- hashing(digesting)
- shuffling
- obfuscation

## Getting started

One simple object is enough to handle all the operations and methods.
```dart
import 'package:dummycastle/pl/polinc/dummycastle/dummycastle.dart';
...
DummyCastle dummyCastle = new DummyCastle();
...
String password="Password";
dummyCastle.genSymmKeyWith(password);
String encrypted = dummyCastle.encryptSymmWith(plainText).getResult();
```

## Usage

//Symmetric encryption

```dart
String encrypted = dummyCastle.encryptSymmWith(plainText).getResult();
String decrypted = dummyCastle.decryptSymmWith(encrypted).getResult();
String decodedResult = dummyCastle.decodeWith(decrypted).toStringDecoded();
```

//Asymmetric encryption

```dart
CryptAsymmKeysPair cryptAsymmKeysPair = dummyCastle.genAsymmKeys();
CryptAsymmPublicKey cryptAsymmPublicKey = cryptAsymmKeysPair.getCryptAsymmPublicKey();
CryptAsymmPrivateKey cryptAsymmPrivateKey = cryptAsymmKeysPair.getCryptAsymmPrivateKey();

String encrypted = dummyCastle.encryptAsymmWith(plainText, cryptAsymmPublicKey).getResult();
String decrypted = dummyCastle.decryptAsymmWith( encrypted , cryptAsymmPrivateKey).getResult();
String decodedResult=dummyCastle.decodeWith(decrypted).toStringDecoded();
```

//Random generation

```dart
String randomInt1 = dummyCastle.randomNumWith(8).getResultDecoded();
String randomStr1 = dummyCastle.randomStrWith(8).getResultDecoded();
String randomInt2 = dummyCastle.randomDeterministicNumWith(someRand1, 8).getResult();
```

//Hashing

```dart
String hashed1  = dummyCastle.hashToNumWith(plainText1).getResult();
String hashed2  = dummyCastle.hashToStrWith(plainText1).getResult();
```

//Shuffling

```dart
String someRand1="aAbBcC";
String shuffled1 = dummyCastle.shuffleWith(plainText).getResultDecoded();
String shuffled2 = dummyCastle.shuffleDeterministicWith(plainText, someRand1).getResultDecoded();
```

//Obfuscation

```dart
String obfuscated = dummyCastle.obfuscateWith(plainText).getResult();
String unobfuscated = dummyCastle.unobfuscateWith(obfuscated).getResult();
```

//Clean up - optional
```dart
dummyCastle.reset();
```

## Additional information

This library is an official port fo Java version which can be found here:
https://github.com/polincdev/DummyCastle

The Dart/FLutter versio is available here:
https://github.com/polincdev/DummyCastle4Dart

The versions remain synced.