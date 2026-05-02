import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';

class TransactionDetails {
  TransactionDetails({
    required this.txid,
    required this.feeBtc,
    required this.totalAmountBtc,
    required this.outputCount,
  });
  final String txid;
  final double feeBtc;
  final double totalAmountBtc;
  final int outputCount;
}

class TransactionAnalyzer {
  static Future<TransactionDetails> analyzePsbt(String base64Psbt) async {
    // 1. Pre-validation: Sanitize input to reject non-base64 malformed data instantly
    final sanitizedData = base64Psbt.trim();
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');

    if (sanitizedData.length < 50 || !base64Regex.hasMatch(sanitizedData)) {
      throw StateError('CORRUPT_PAYLOAD');
    }

    try {
      final psbt = await WalletEngine.parsePsbt(sanitizedData);
      final feeSats = psbt.feeAmount();
      if (feeSats == null) {
        throw StateError('PSBT_FEE_UNAVAILABLE');
      }

      final tx = psbt.extractTx();
      final outputs = tx.output();
      final totalOutputSats = outputs.fold<BigInt>(
        BigInt.zero,
        (sum, output) => sum + output.value,
      );

      return TransactionDetails(
        txid: psbt.txid(),
        feeBtc: _satsToBtc(feeSats),
        totalAmountBtc: _satsToBtc(totalOutputSats),
        outputCount: outputs.length,
      );
    } catch (_) {
      throw StateError('INVALID_PSBT_FORMAT');
    }
  }

  static double _satsToBtc(BigInt sats) => sats.toDouble() / 100000000;
}
