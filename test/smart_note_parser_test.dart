import 'package:flutter_test/flutter_test.dart';
import 'package:catnotes/features/notes/input/smart_note_parser.dart';

void main() {
  group('parseSmartNoteInput', () {
    test('mehrzeilig – erste Zeile Titel, Rest Inhalt', () {
      final r = parseSmartNoteInput('Einkauf\nMilch\nBrot\nKaffee');
      expect(r.title, 'Einkauf');
      expect(r.content, 'Milch\nBrot\nKaffee');
    });

    test('mehrzeilig mit \\r\\n (Windows)', () {
      final r = parseSmartNoteInput('Einkauf\r\nMilch Brot');
      expect(r.title, 'Einkauf');
      expect(r.content, 'Milch Brot');
    });

    test('mehrzeilig mit \\r (iOS/macOS Diktat)', () {
      final r = parseSmartNoteInput('Einkauf\rMilch\rBrot');
      expect(r.title, 'Einkauf');
      expect(r.content, 'Milch\nBrot');
    });

    test('Titel:-Prefix + Inhalt:-Prefix', () {
      final r = parseSmartNoteInput('Titel: Werkstatt\nInhalt: Reifen prüfen');
      expect(r.title, 'Werkstatt');
      expect(r.content, 'Reifen prüfen');
    });

    test('nur eine Zeile', () {
      final r = parseSmartNoteInput('Nur eine kurze Notiz');
      expect(r.title, 'Nur eine kurze Notiz');
      expect(r.content, '');
    });

    test('leerer Text', () {
      final r = parseSmartNoteInput('');
      expect(r.title, '');
      expect(r.content, '');
    });

    test('Leerzeilen werden ignoriert', () {
      final r = parseSmartNoteInput('\n\nEinkauf\n\nMilch\n\n');
      expect(r.title, 'Einkauf');
      expect(r.content, 'Milch');
    });
  });
}
