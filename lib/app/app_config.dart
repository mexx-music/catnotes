import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:catnotes/core/text_zoom/text_zoom_controller.dart';
import 'package:catnotes/data/models/note.dart';
import 'package:catnotes/data/repos/note_repository.dart';
import 'app.dart';

final _textZoomController = TextZoomController();

Future<ProviderContainer> initializeApp() async {
  // Initialize Flutter bindings
  // WidgetsFlutterBinding.ensureInitialized() - caller must do this

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapter exactly once
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(NoteAdapter());
  }

  // Open boxes and migrate data if necessary
  final b2 = await Hive.openBox<Note>('notesBox2');
  final b1 = await Hive.openBox<Note>('notesBox');

  if (b1.isEmpty && b2.isNotEmpty) {
    for (final key in b2.keys) {
      final n = b2.get(key);
      if (n != null) await b1.put(n.id, n);
    }
    // Optional: b2.clear(); // keep for safety
  }

  // Load text zoom settings
  await _textZoomController.load();

  // Create and configure provider container
  final container = ProviderContainer(
    overrides: [
      noteRepositoryProvider.overrideWithValue(NoteRepository(b1)),
    ],
  );

  return container;
}

TextZoomController getTextZoomController() => _textZoomController;

CatNotesApp buildApp() => const CatNotesApp();
