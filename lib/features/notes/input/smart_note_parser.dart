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

/// Parst freien Text in Titel + Inhalt.
///
/// Regeln (in dieser Reihenfolge):
/// 1. "Titel: X" in erster Zeile → Titel = X, Rest = Inhalt (Inhalt:-Prefix wird entfernt)
/// 2. Mehrzeilig ohne Prefix → erste Zeile = Titel, Rest = Inhalt
/// 3. Einzeilig → Titel = Text, Inhalt = leer
SmartNoteDraft parseSmartNoteInput(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const SmartNoteDraft(title: '', content: '');

  final lines =
      text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  if (lines.isEmpty) return const SmartNoteDraft(title: '', content: '');

  if (lines.length == 1) {
    final line = lines.first;
    if (_hasPrefix(line, _titlePrefixes)) {
      return SmartNoteDraft(title: _stripPrefix(line, _titlePrefixes), content: '');
    }
    return SmartNoteDraft(title: line, content: '');
  }

  // Expliziter "Titel:"-Prefix in der ersten Zeile
  if (_hasPrefix(lines.first, _titlePrefixes)) {
    final title = _stripPrefix(lines.first, _titlePrefixes);
    final contentLines = lines.skip(1).map((l) {
      return _hasPrefix(l, _contentPrefixes) ? _stripPrefix(l, _contentPrefixes) : l;
    }).toList();
    return SmartNoteDraft(title: title, content: contentLines.join('\n'));
  }

  // Standard: erste Zeile = Titel, Rest = Inhalt
  return SmartNoteDraft(
    title: lines.first,
    content: lines.skip(1).join('\n'),
  );
}
