import 'package:coldbit_wallet/core/crypto/transaction_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionAnalyzer', () {
    test('rejects non-base64 payloads before review', () async {
      expect(
        () => TransactionAnalyzer.analyzePsbt('not a psbt'),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects short base64 payloads before review', () async {
      expect(
        () => TransactionAnalyzer.analyzePsbt('cHNidA=='),
        throwsA(isA<StateError>()),
      );
    });
  });
}
