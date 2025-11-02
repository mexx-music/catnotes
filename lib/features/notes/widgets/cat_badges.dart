import 'package:flutter/material.dart';
import 'package:catnotes/core/log.dart';

/// Kleines, leichtgewichtiges Badge-Widget mit Katzensymbolen unter dem Titel.
/// Auswahl ist deterministisch aus Note.id, sodass die Mischung stabil bleibt.
class CatBadges extends StatelessWidget {
  const CatBadges({super.key, required this.seed});
  final String seed;

  static const _emojis = [
    '🐾','🐱','😺','🐈','🐈‍⬛','🧶','👑','🌙','✨'
  ];

  List<String> _pickBadges(String s, {int count = 3}) {
    // deterministische Auswahl
    int h = 0;
    for (final r in s.runes) { h = (h * 31 + r) & 0x7fffffff; }
    final out = <String>[];
    for (var i = 0; i < count; i++) {
      out.add(_emojis[(h + i * 7) % _emojis.length]);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    logd('CatBadges build: seed=${seed}');
    final badges = _pickBadges(seed);
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      height: 1.1,
      fontSize: 32, // deutlich größer
      color: Colors.black.withOpacity(0.18), // sehr transparent
    );
    return Wrap(
      spacing: 6,
      runSpacing: -2,
      children: badges.map((e) => Text(e, style: style)).toList(),
    );
  }
}
