import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vaultExistsProvider = FutureProvider<bool>((ref) async {
  // Verificamos pasivamente si el enclave ya contiene la sal del usuario
  final saltHex = await SecureEnclave.read('auth_salt');
  return saltHex != null && saltHex.isNotEmpty;
});
