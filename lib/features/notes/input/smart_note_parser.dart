class SmartNoteDraft {
  final String title;
  final String content;
  const SmartNoteDraft({required this.title, required this.content});
}

const _titlePrefixes = ['titel:', 'title:'];
const _contentPrefixes = ['inhalt:', 'content:', 'notiz:', 'note:'];

bool _hasPrefix(String line, List<String> prefixes) =>
    prefixes.any((p) => line.toLowerCase().startsWith(p));

String _stripPrefix(String line, List<String> prefixes) {
  final lower = line.toLowerCase();
  for (final prefix in prefixes) {
    if (lower.startsWith(prefix)) return line.substring(prefix.length).trim();
  }
  return line.trim();
}

// Trennt auf \n, \r\n und \r (iOS/macOS-Diktat liefert teils nur \r).
final _newline = RegExp(r'\r\n|\r|\n');

/// Parst freien Text in Titel + Inhalt.
///
/// Reihenfolge:
/// 1. Expliziter "Titel:"-Prefix → Titel = Wert, Rest = Inhalt (Inhalt:-Prefix wird entfernt)
/// 2. Doppelpunkt-Hook → erster ":" in der ersten Zeile trennt Titel und Inhalt
/// 3. Mehrzeilig → erste Zeile = Titel, Rest = Inhalt
/// 4. Einzeilig → Titel = Text, Inhalt = leer
SmartNoteDraft parseSmartNoteInput(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const SmartNoteDraft(title: '', content: '');

  final lines =
      text.split(_newline).map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  if (lines.isEmpty) return const SmartNoteDraft(title: '', content: '');

  final firstLine = lines.first;

  // 1. Expliziter "Titel:"-Prefix (z.B. "Titel: Werkstatt\nInhalt: ...")
  if (_hasPrefix(firstLine, _titlePrefixes)) {
    final title = _stripPrefix(firstLine, _titlePrefixes);
    final contentLines = lines.skip(1).map((l) {
      return _hasPrefix(l, _contentPrefixes) ? _stripPrefix(l, _contentPrefixes) : l;
    }).toList();
    return SmartNoteDraft(title: title, content: contentLines.join('\n'));
  }

  // 2. Doppelpunkt-Hook (z.B. "Futter: morgen Katzenfutter kaufen")
  //    Gilt nur wenn vor dem Doppelpunkt etwas Nicht-Leeres steht (colonIdx > 0).
  final colonIdx = firstLine.indexOf(':');
  if (colonIdx > 0) {
    final beforeColon = firstLine.substring(0, colonIdx).trim();
    if (beforeColon.isNotEmpty) {
      final afterColon = firstLine.substring(colonIdx + 1).trim();
      final contentParts = [
        if (afterColon.isNotEmpty) afterColon,
        ...lines.skip(1),
      ];
      return SmartNoteDraft(title: beforeColon, content: contentParts.join('\n'));
    }
  }

  // 3. Mehrzeilig → erste Zeile = Titel, Rest = Inhalt
  if (lines.length > 1) {
    return SmartNoteDraft(title: firstLine, content: lines.skip(1).join('\n'));
  }

  // 4. Einzeiler → Titel = Text, Inhalt leer
  return SmartNoteDraft(title: firstLine, content: '');
}
