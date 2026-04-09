import 'dart:convert';

import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRecord {
  TransactionRecord({
    required this.txid,
    required this.amountBtc,
    required this.feeBtc,
    required this.timestamp,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      TransactionRecord(
        txid: json['txid'],
        amountBtc: json['amountBtc'],
        feeBtc: json['feeBtc'],
        timestamp: DateTime.parse(json['timestamp']),
      );
  final String txid;
  final double amountBtc;
  final double feeBtc;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'txid': txid,
    'amountBtc': amountBtc,
    'feeBtc': feeBtc,
    'timestamp': timestamp.toIso8601String(),
  };
}

class HistoryNotifier extends StateNotifier<List<TransactionRecord>> {
  HistoryNotifier() : super([]) {
    _loadHistory();
  }

  static const String _historyKey = 'offline_tx_history';

  Future<void> _loadHistory() async {
    final rawData = await SecureEnclave.read(_historyKey);
    if (rawData != null && rawData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawData);
        final records = decoded
            .map((e) => TransactionRecord.fromJson(e))
            .toList();
        state = records;
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> addRecord(TransactionRecord record) async {
    final newState = [record, ...state];
    state = newState;

    // Persist securely to Hardware Keystore
    final rawData = jsonEncode(newState.map((e) => e.toJson()).toList());
    await SecureEnclave.write(_historyKey, rawData);
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<TransactionRecord>>((ref) {
      return HistoryNotifier();
    });
