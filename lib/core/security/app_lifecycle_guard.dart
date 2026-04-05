import 'dart:async';
import 'dart:ui';

import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/security/threat_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLifecycleGuard extends ConsumerStatefulWidget {

  const AppLifecycleGuard({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLifecycleGuard> createState() => _AppLifecycleGuardState();
}

class _AppLifecycleGuardState extends ConsumerState<AppLifecycleGuard> with WidgetsBindingObserver {
  bool _isHidden = false;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
    ThreatDetector.isCompromised(); // Escaneo estático base
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 2), () {
      if (ref.read(authProvider) == AuthState.authenticated) {
         _expelUser();
      }
    });
  }

  void _onInteraction(PointerEvent details) {
    if (ref.read(authProvider) == AuthState.authenticated) {
      _resetInactivityTimer();
    }
  }

  void _expelUser() {
     ref.read(authProvider.notifier).logout();
     // Purgar sesión automáticamente enruta por Riverpod + GoRouter
  }

  bool _wasPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPaused = true;
      setState(() => _isHidden = true);
    } else if (state == AppLifecycleState.inactive) {
      // Inmediatamente oscurecemos la UI para que los snapshots del OS no copien datos, o para cubrir FaceID modal
      setState(() => _isHidden = true);
    } else if (state == AppLifecycleState.resumed) {
      setState(() => _isHidden = false);
      
      // La regla bancaria no negociable: Si pones la app verdaderamente en fondo (paused), pierdes la sesión.
      if (_wasPaused && ref.read(authProvider) == AuthState.authenticated) {
         _expelUser();
      }
      _wasPaused = false;
      _resetInactivityTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onInteraction,
      onPointerMove: _onInteraction,
      onPointerUp: _onInteraction,
      child: Stack(
        textDirection: TextDirection.ltr,
        children: [
          widget.child,
          if (_isHidden)
             Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(color: Colors.black.withValues(alpha: 0.6)),
                ),
             ),
        ],
      ),
    );
  }
}
