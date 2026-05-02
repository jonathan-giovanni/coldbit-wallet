enum MnemonicStrength {
  words12(wordCount: 12, entropyBits: 128),
  words24(wordCount: 24, entropyBits: 256);

  const MnemonicStrength({required this.wordCount, required this.entropyBits});

  final int wordCount;
  final int entropyBits;

  static MnemonicStrength fromWordCount(int wordCount) {
    return switch (wordCount) {
      12 => MnemonicStrength.words12,
      24 => MnemonicStrength.words24,
      _ => throw ArgumentError.value(
        wordCount,
        'wordCount',
        'Only 12 and 24-word BIP39 phrases are supported.',
      ),
    };
  }
}
