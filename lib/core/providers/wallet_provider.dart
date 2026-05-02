import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletState {
  const WalletState({
    required this.fingerprint,
    required this.descriptor,
    required this.network,
    required this.receiveAddress,
    required this.receivePath,
  });

  final String fingerprint;
  final Descriptor descriptor;
  final Network network;
  final String receiveAddress;
  final String receivePath;
}

final walletProvider = FutureProvider<WalletState?>((ref) async {
  final seed = await SeedProvider.loadPersistedSeed();
  if (seed == null) return null;

  const network = Network.testnet;
  final descriptor = await WalletEngine.deriveNativeSegwit(seed, network);

  final descriptorStr = descriptor.asString();
  final fingerprint = _extractFingerprint(descriptorStr);
  final receiveAddress = await WalletEngine.deriveReceiveAddress(
    descriptor: descriptor,
    network: network,
  );

  return WalletState(
    fingerprint: fingerprint,
    descriptor: descriptor,
    network: network,
    receiveAddress: receiveAddress,
    receivePath: "m/84'/1'/0'/0/0",
  );
});

String _extractFingerprint(String descriptorStr) {
  final regex = RegExp(r'\[([0-9a-fA-F]{8})/');
  final match = regex.firstMatch(descriptorStr);
  if (match != null) return match.group(1)!.toUpperCase();

  return descriptorStr.hashCode
      .toUnsigned(32)
      .toRadixString(16)
      .padLeft(8, '0')
      .toUpperCase();
}
