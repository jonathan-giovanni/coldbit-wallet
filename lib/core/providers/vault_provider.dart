import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vaultExistsProvider = FutureProvider<bool>((ref) async {
  // Verificamos pasivamente si el enclave ya contiene la firma fisica del PIN (Fase 8)
  final saltHex = await SecureEnclave.read('coldbit_pin_hash');
  return saltHex != null && saltHex.isNotEmpty;
});
