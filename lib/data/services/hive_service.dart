import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class HiveService {
  static const notesBoxName = 'notesBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(notesBoxName);
  }

  static Box<Note> get notesBox => Hive.box<Note>(notesBoxName);
}

