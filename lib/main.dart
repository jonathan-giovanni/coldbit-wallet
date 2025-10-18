import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations

void main() {
  runApp(const ColdBitApp());
}

class ColdBitApp extends StatelessWidget {
  const ColdBitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColdBit Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A00)),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Color(0xFFE6E7E8),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFE6E7E8),
            fontSize: 18,
          ),
        ),
      ),
      home: const LogoHomePage(),
    );
  }
}

class LogoHomePage extends StatefulWidget {
  const LogoHomePage({super.key});

  @override
  State<LogoHomePage> createState() => _LogoHomePageState();
}

class _LogoHomePageState extends State<LogoHomePage>
    with SingleTickerProviderStateMixin {
  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _rotation += 3.14; // Rotate 180 degrees on tap
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF121417),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _rotation / (2 * 3.1415926535),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOutCubic,
                  child: Center(
                    child: Image.asset(
                      'assets/icon/icon_without_bg.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ).animate().scaleXY(
                  duration: 800.ms,
                  curve: Curves.easeInOutCubic,
                  begin: 1.0,
                  end: 1.1,
                  alignment: Alignment.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ColdBit Wallet',
              style: TextStyle(
                color: Color(0xFFE6E7E8),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}