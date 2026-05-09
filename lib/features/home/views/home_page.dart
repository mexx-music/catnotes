import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CatColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 52),

              // ── Branding ──────────────────────────────────────────────────
              Center(
                child: Text(
                  'CatNotes 🐾',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: CatColors.primary,
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Deine Notizen. Katzenstark.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: CatColors.textMid,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Beschreibung ──────────────────────────────────────────────
              Center(
                child: Text(
                  'Einfach schreiben oder diktieren –\nCatNotes macht Notizen zum Kinderspiel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: CatColors.textMid,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Feature-Liste ─────────────────────────────────────────────
              _FeatureRow(
                emoji: '🐾',
                title: 'Seniorenfreundlich',
                subtitle: 'Große Schrift, klare Bedienung',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                emoji: '🐾',
                title: 'Diktat optimiert',
                subtitle: 'Einfach sprechen, Notiz fertig',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                emoji: '🐾',
                title: 'Intelligent',
                subtitle: 'Titel und Inhalt automatisch erkannt',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                emoji: '🐾',
                title: 'Charmant',
                subtitle: 'Mit Liebe für Katzenfreunde gemacht',
              ),

              const SizedBox(height: 44),

              // ── Buttons ───────────────────────────────────────────────────
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.menu_book_rounded, size: 20),
                label: const Text('Notizen öffnen'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () => context.go('/edit'),
                icon: const Icon(Icons.mic_rounded, size: 20),
                label: const Text('Neue Notiz diktieren'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Katzen-Illustration ───────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/images/cat_notes_holder.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: CatColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CatColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: CatColors.textMid,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
