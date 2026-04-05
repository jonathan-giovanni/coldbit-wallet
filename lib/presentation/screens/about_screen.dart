import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

const String _missionMarkdown = '''
# ColdBit Wallet Misión

Esta aplicación fue forjada con un propósito absoluto: **Asumir que todos los entornos en internet están comprometidos o son inherentemente hostiles**. 

## Principios de Diseño
1. **Air-gapped Puro**: 
   Tu dispositivo no enviará una sola clave privada a la internet abierta. Solo firma de PSBTs.
2. **Defensa de Capa RAM (MemGuard)**: 
   Las semillas (Seed Phrases) existen en RAM criptográfica sellada temporal. Se pulsa y se quema a discreción.

---

### Componentes de Seguridad Implementados:
- **libsodium**: Derivación de hashes estilo Argon2id y almacenamiento aislado.
- **Fail-Close Policy**: Cualquier perturbación (salir de la App, fallo biométrico, jailbreak detectado) colapsa la sesión por protocolo.

*El software es para uso soberano. Verifique el Hash del código y construya usted mismo.*
''';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca del Proyecto'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: ColdBitTheme.goldBitcoin),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Markdown(
          data: _missionMarkdown,
          styleSheet: MarkdownStyleSheet(
            h1: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColdBitTheme.pureWhiteText, fontWeight: FontWeight.bold),
            h2: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColdBitTheme.goldBitcoin, fontWeight: FontWeight.bold),
            p: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColdBitTheme.platinumText, height: 1.6),
            listBullet: const TextStyle(color: ColdBitTheme.goldBitcoin),
          ),
        ),
      ),
    );
  }
}
