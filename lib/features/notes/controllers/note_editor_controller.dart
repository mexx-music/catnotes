import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
import 'package:catnotes/core/log.dart';

final noteEditorControllerProvider =
    NotifierProvider<NoteEditorController, Note?>(NoteEditorController.new);

class NoteEditorController extends Notifier<Note?> {
  late final NoteRepository _repo;

  @override
  Note? build() {
    _repo = ref.read(noteRepositoryProvider);
    // Neu anlegen als Default (wird bei load(id) überschrieben)
    final now = DateTime.now();
    return Note(
      id: const Uuid().v4(),
      title: '',
      body: '',
      tags: const [],
      isPinned: false,
      remindAt: null,
      imagePath: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  void load(String id) {
    final n = _repo.getById(id);
    if (n != null) state = n;
  }

  Future<void> save({
    required String title,
    required String body,
    List<String> tags = const [],
  }) async {
    final n = state;
    if (n == null) return;
    final updated = n.copyWith(
      title: title.trim(),
      body: body,
      tags: tags,
      updatedAt: DateTime.now(),
    );
    state = updated;
    await _repo.upsert(updated);
    // Debug
    logi('[Editor] saved ${updated.id} "${updated.title}"');
    // Nach dem Speichern neuen State für nächste Notiz erzeugen
    final now = DateTime.now();
    state = Note(
      id: const Uuid().v4(),
      title: '',
      body: '',
      tags: const [],
      isPinned: false,
      remindAt: null,
      imagePath: null,
      createdAt: now,
      updatedAt: now,
    );
  }
}
