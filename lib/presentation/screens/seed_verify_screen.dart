import 'dart:math';

import 'package:coldbit_wallet/core/crypto/bip39_english_wordlist.dart'
    as bip39_english;
import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SeedVerifyScreen extends ConsumerStatefulWidget {
  const SeedVerifyScreen({
    super.key,
    this.challengeIndicesForTesting,
    this.optionsForTesting,
  });

  @visibleForTesting
  final List<int>? challengeIndicesForTesting;

  @visibleForTesting
  final Map<int, List<String>>? optionsForTesting;

  @override
  ConsumerState<SeedVerifyScreen> createState() => _SeedVerifyScreenState();
}

class _SeedVerifyScreenState extends ConsumerState<SeedVerifyScreen> {
  static const int _challengeCount = 4;
  late final List<String> _words;
  late final List<int> _challengeIndices;
  late final Map<int, List<String>> _optionsByIndex;
  final Map<int, String?> _answers = {};
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _words = ref.read(seedProvider.notifier).words;
    _challengeIndices =
        widget.challengeIndicesForTesting ??
        _pickRandomIndices(_words.length, _challengeCount);
    _optionsByIndex = {
      for (final index in _challengeIndices)
        index:
            widget.optionsForTesting?[index] ??
            _buildOptions(correctIndex: index),
    };
  }

  List<int> _pickRandomIndices(int total, int count) {
    final rng = Random.secure();
    final indices = <int>{};
    final effectiveCount = min(total, count);
    while (indices.length < effectiveCount) {
      indices.add(rng.nextInt(total));
    }
    return indices.toList()..sort();
  }

  List<String> _buildOptions({required int correctIndex}) {
    final rng = Random.secure();
    final correct = _words[correctIndex];
    final pool =
        bip39_english.englishWordlist.where((word) => word != correct).toList()
          ..shuffle(rng);
    final options = [correct, ...pool.take(3)]..shuffle(rng);
    return options;
  }

  void _selectAnswer(int challengeIndex, String word) {
    setState(() {
      _answers[challengeIndex] = word;
      _failed = false;
    });
  }

  Future<void> _verify() async {
    for (final idx in _challengeIndices) {
      if (_answers[idx] != _words[idx]) {
        HapticFeedback.heavyImpact();
        setState(() => _failed = true);
        return;
      }
    }

    await ref.read(seedProvider.notifier).persist();
    ref.read(seedProvider.notifier).wipe();
    if (!mounted) return;
    ref.read(authProvider.notifier).completeSeedBackup();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final allAnswered = _answers.length == _challengeCount;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: ColdBitTheme.platinumText,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.seedVerifyTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ).animate().fade(),
              const SizedBox(height: 8),
              Text(
                loc.seedVerifyDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ).animate().fade(delay: 100.ms),
              if (_failed) ...[
                const SizedBox(height: 12),
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ColdBitTheme.errorCrimson.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColdBitTheme.errorCrimson),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.alertTriangle,
                            color: ColdBitTheme.errorCrimson,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            loc.seedVerifyFailed,
                            style: const TextStyle(
                              color: ColdBitTheme.errorCrimson,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(key: ValueKey(_failed))
                    .shake(hz: 6, duration: 400.ms),
              ],
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _challengeIndices.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 20),
                  itemBuilder: (context, i) {
                    final wordIndex = _challengeIndices[i];
                    final options = _optionsByIndex[wordIndex]!;
                    final selected = _answers[wordIndex];

                    return _ChallengeCard(
                      wordNumber: wordIndex + 1,
                      options: options,
                      selected: selected,
                      onSelect: (word) => _selectAnswer(wordIndex, word),
                    ).animate().fade(delay: (100 * i).ms).slideX(begin: 0.1);
                  },
                ),
              ),
              const SizedBox(height: 16),
              ColdBitActionButton(
                label: loc.seedVerifyConfirmBtn,
                icon: LucideIcons.shieldCheck,
                onPressed: allAnswered ? _verify : null,
              ).animate().fade(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.wordNumber,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final int wordNumber;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColdBitTheme.darkGraphite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected != null
              ? ColdBitTheme.goldBitcoin.withValues(alpha: 0.4)
              : ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.seedVerifyWordLabel(wordNumber),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ColdBitTheme.goldBitcoin,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((word) {
              final isSelected = word == selected;
              return GestureDetector(
                onTap: () => onSelect(word),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColdBitTheme.goldBitcoin
                        : ColdBitTheme.obsidianBlack,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? ColdBitTheme.goldBitcoin
                          : ColdBitTheme.brushedMetal,
                    ),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      color: isSelected
                          ? ColdBitTheme.obsidianBlack
                          : ColdBitTheme.pureWhiteText,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
