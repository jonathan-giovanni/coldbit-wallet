import 'dart:convert';
import 'dart:typed_data';
import 'package:sodium_libs/sodium_libs.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';

class SealedState<T> {
  SecureKey? _key;
  Uint8List? _nonce;
  Uint8List? _ciphertext;

  SealedState(T initialValue) {
    _seal(initialValue);
  }

  void _seal(T value) {
    final sodium = MemGuard.sodium;
    _key = sodium.crypto.secretBox.keygen();
    _nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    final bytes = _serialize(value);
    
    _ciphertext = sodium.crypto.secretBox.easy(
      message: bytes,
      nonce: _nonce!,
      key: _key!,
    );
  }

  T unseal() {
    if (_key == null || _nonce == null || _ciphertext == null) {
      throw StateError('DEAD_STATE');
    }
    
    final sodium = MemGuard.sodium;
    
    try {
      final decryptedBytes = sodium.crypto.secretBox.openEasy(
        cipherText: _ciphertext!,
        nonce: _nonce!,
        key: _key!,
      );
      return _deserialize(decryptedBytes);
    } catch (e) {
      throw StateError('TAMPER_DETECTED');
    }
  }

  void update(T Function(T current) updater) {
    final current = unseal();
    final newValue = updater(current);
    _key?.dispose();
    _seal(newValue);
  }

  void destroy() {
    _key?.dispose();
    _key = null;
    _nonce = null;
    _ciphertext = null;
  }

  Uint8List _serialize(T value) {
    if (value is int) {
      final bdata = ByteData(8);
      bdata.setInt64(0, value);
      return bdata.buffer.asUint8List();
    } else if (value is String) {
      return Uint8List.fromList(utf8.encode(value));
    } else if (value is bool) {
      return Uint8List.fromList([value ? 1 : 0]);
    } else if (value is Uint8List) {
      return value;
    }
    throw UnsupportedError('UNSUPPORTED_TYPE');
  }

  T _deserialize(Uint8List bytes) {
    if (T == int) {
      return ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes).getInt64(0) as T;
    } else if (T == String) {
      return utf8.decode(bytes) as T;
    } else if (T == bool) {
      return (bytes[0] == 1) as T;
    } else if (T == Uint8List) {
      return bytes as T;
    }
    throw UnsupportedError('UNSUPPORTED_TYPE');
  }
}
