import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SeedRecoveryScreen extends ConsumerStatefulWidget {
  const SeedRecoveryScreen({super.key});

  @override
  ConsumerState<SeedRecoveryScreen> createState() => _SeedRecoveryScreenState();
}

class _SeedRecoveryScreenState extends ConsumerState<SeedRecoveryScreen> {
  final List<TextEditingController> _controllers = List.generate(
    24,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(24, (_) => FocusNode());
  final ScrollController _scrollController = ScrollController();

  bool _isValid = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  String get _mnemonic =>
      _controllers.map((c) => c.text.trim().toLowerCase()).join(' ');

  void _validate() {
    final allFilled = _controllers.every((c) => c.text.trim().isNotEmpty);
    if (!allFilled) {
      setState(() {
        _isValid = false;
        _error = null;
      });
      return;
    }

    final valid = WalletEngine.validateMnemonic(_mnemonic);
    setState(() {
      _isValid = valid;
      _error = valid ? null : AppLocalizations.of(context)!.recoverInvalidSeed;
    });
  }

  Future<void> _recover() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);

    try {
      ref.read(seedProvider.notifier).setSeed(_mnemonic);
      await ref.read(seedProvider.notifier).persist();
      ref.read(seedProvider.notifier).wipe();

      if (!mounted) return;
      ref.read(authProvider.notifier).markRecoveryComplete();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = AppLocalizations.of(context)!.recoverError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.recoverTitle),
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: ColdBitTheme.goldBitcoin,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                loc.recoverDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ).animate().fade(),
              if (_error != null) ...[
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
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: ColdBitTheme.errorCrimson,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().shake(hz: 6, duration: 400.ms),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    return Container(
                          decoration: BoxDecoration(
                            color: ColdBitTheme.darkGraphite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _controllers[index].text.trim().isNotEmpty
                                  ? ColdBitTheme.goldBitcoin.withValues(
                                      alpha: 0.4,
                                    )
                                  : ColdBitTheme.brushedMetal.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: ColdBitTheme.goldBitcoin,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                  ),
                                  textInputAction: index < 23
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z]'),
                                    ),
                                  ],
                                  onChanged: (_) => _validate(),
                                  onSubmitted: (_) {
                                    if (index < 23) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else {
                                      _validate();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fade(delay: (20 * index).ms)
                        .slideY(begin: 0.2, duration: 200.ms);
                  },
                ),
              ),
              const SizedBox(height: 16),
              ColdBitActionButton(
                label: loc.recoverConfirmBtn,
                icon: LucideIcons.keyRound,
                isLoading: _isLoading,
                onPressed: _isValid ? _recover : null,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
