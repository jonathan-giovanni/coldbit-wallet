import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final slides = [
      _OnboardingSlide(
        icon: LucideIcons.shieldCheck,
        title: loc.onboardingSlide1Title,
        description: loc.onboardingSlide1Desc,
      ),
      _OnboardingSlide(
        icon: LucideIcons.fingerprint,
        title: loc.onboardingSlide2Title,
        description: loc.onboardingSlide2Desc,
      ),
      _OnboardingSlide(
        icon: LucideIcons.hardDrive,
        title: loc.onboardingSlide3Title,
        description: loc.onboardingSlide3Desc,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.1),
                        blurRadius: 150,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 6.seconds,
                curve: Curves.easeInOutBack,
              ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    itemCount: slides.length,
                    itemBuilder: (context, index) => slides[index],
                  ),
                ),

                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? ColdBitTheme.goldBitcoin
                            : ColdBitTheme.brushedMetal.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ).animate().fade(delay: 1.seconds),

                const SizedBox(height: 48),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_currentPage < slides.length - 1)
                        ColdBitActionButton(
                          label: "Next",
                          onPressed: () {
                            _pageController.nextPage(
                              duration: 500.ms,
                              curve: Curves.easeInOutQuart,
                            );
                          },
                          isPrimary: false,
                        )
                      else
                        ColdBitActionButton(
                          label: loc.onboardingCreateBtn,
                          icon: LucideIcons.plusCircle,
                          onPressed: () => context.push('/setup'),
                          isPrimary: true,
                        ).animate().shimmer(duration: 2.seconds),

                      const SizedBox(height: 16),
                      
                      if (_currentPage == slides.length - 1)
                        TextButton(
                          onPressed: () => context.push('/recover'),
                          child: Text(
                            loc.onboardingRecoverBtn,
                            style: const TextStyle(
                              color: ColdBitTheme.platinumText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ).animate().fade(delay: 400.ms),

                      const SizedBox(height: 16),
                    ],
                  ),
                ).animate().fade(delay: 500.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: ColdBitTheme.brushedMetal.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 72,
              color: ColdBitTheme.goldBitcoin,
            ),
          )
          .animate(key: ValueKey(icon))
          .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.easeOutBack)
          .shimmer(delay: 600.ms, duration: 1.5.seconds),

          const SizedBox(height: 48),

          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ).animate(key: ValueKey(title)).fade().slideY(begin: 0.2),

          const SizedBox(height: 16),

          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ColdBitTheme.platinumText,
              height: 1.6,
            ),
          ).animate(key: ValueKey(description)).fade(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
