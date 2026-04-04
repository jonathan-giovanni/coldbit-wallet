import 'dart:convert';
import 'dart:typed_data';
import 'package:sodium_libs/sodium_libs.dart';
import 'mem_guard.dart';

/// A cryptographically protected state wrapper for variables in RAM. 
/// Utilizes Libsodium SecretBox (ChaCha20-Poly1305) to encrypt and sign values,
/// protecting against runtime RAM tampering.
class SealedState<T> {
  SecureKey? _key;
  Uint8List? _nonce;
  Uint8List? _ciphertext;

  SealedState(T initialValue) {
    _seal(initialValue);
  }

  void _seal(T value) {
    final sodium = MemGuard.sodium;
    
    // 1. Generate ephemeral execution key
    _key = sodium.crypto.secretBox.keygen();
    
    // 2. Generate nonce
    _nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    
    // 3. Serialize data
    final bytes = _serialize(value);
    
    // 4. Authenticated Encryption (ChaCha20-Poly1305 MAC)
    _ciphertext = sodium.crypto.secretBox.easy(
      message: bytes,
      nonce: _nonce!,
      key: _key!,
    );
  }

  /// Unseals the data, verifying the MAC to ensure the cipher was not manipulated.
  /// Throws an exception if tampering is detected.
  T unseal() {
    if (_key == null || _nonce == null || _ciphertext == null) {
      throw StateError('SealedState has been wiped or destroyed.');
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
      // SecretBox throws if MAC is invalid -> Tampering detected.
      throw Exception('TamperDetectedException: Memory signature validation failed. $e');
    }
  }

  /// Mutates the state securely by decrypting, applying the function, and re-sealing.
  void update(T Function(T current) updater) {
    final current = unseal();
    final newValue = updater(current);
    
    // Dispose previous key immediately for memory hygiene
    _key?.dispose();
    
    _seal(newValue);
  }

  /// Zeroes out the memory pointers completely.
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
    throw UnsupportedError('Type not supported by SealedState');
  }

  T _deserialize(Uint8List bytes) {
    if (T == int) {
      return ByteData.view(bytes.buffer).getInt64(0) as T;
    } else if (T == String) {
      return utf8.decode(bytes) as T;
    } else if (T == bool) {
      return (bytes[0] == 1) as T;
    } else if (T == Uint8List) {
      return bytes as T;
    }
    throw UnsupportedError('Type not supported by SealedState');
  }
}
