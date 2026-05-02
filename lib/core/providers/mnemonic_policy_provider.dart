import 'package:coldbit_wallet/core/crypto/mnemonic_strength.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mnemonicStrengthProvider = StateProvider<MnemonicStrength>(
  (ref) => MnemonicStrength.words24,
);
