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

    // Doppelpunkt-Hook
    test('Doppelpunkt trennt Titel und Inhalt', () {
      final r = parseSmartNoteInput('Futter: morgen Katzenfutter kaufen');
      expect(r.title, 'Futter');
      expect(r.content, 'morgen Katzenfutter kaufen');
    });

    test('Doppelpunkt mit mehreren Wörtern im Inhalt', () {
      final r = parseSmartNoteInput('Werkstatt: Reifen prüfen, Öl kontrollieren');
      expect(r.title, 'Werkstatt');
      expect(r.content, 'Reifen prüfen, Öl kontrollieren');
    });

    test('Doppelpunkt im Inhalt – nur erster trennt (Zeit mit Uhrzeit)', () {
      final r = parseSmartNoteInput('Zeit: 10:30 Uhr');
      expect(r.title, 'Zeit');
      expect(r.content, '10:30 Uhr');
    });

    test('Doppelpunkt am Anfang – kein Split, normale Logik', () {
      final r = parseSmartNoteInput(':Kein Titel');
      expect(r.title, ':Kein Titel');
      expect(r.content, '');
    });

    test('Doppelpunkt-Hook mit weiteren Zeilen im Inhalt', () {
      final r = parseSmartNoteInput('Futter: morgen\nZusatz: Leckerli');
      expect(r.title, 'Futter');
      expect(r.content, 'morgen\nZusatz: Leckerli');
    });

    test('expliziter Titel:-Prefix schlägt Doppelpunkt-Hook (Regression)', () {
      final r = parseSmartNoteInput('Titel: Werkstatt');
      expect(r.title, 'Werkstatt');
      expect(r.content, '');
    });
  });
}
