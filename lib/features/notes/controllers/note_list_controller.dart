import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';

final noteListControllerProvider = AsyncNotifierProvider<NoteListController, List<Note>>(NoteListController.new);

class NoteListController extends AsyncNotifier<List<Note>> {
  String _query = '';
  String? _activeTag;
  bool _pinnedFirst = false;

  @override
  Future<List<Note>> build() async {
    final repo = ref.read(noteRepositoryProvider);
    var notes = await repo.getAll();
    // Filter by query (title or body)
    if (_query.isNotEmpty) {
      notes = notes.where((n) => n.title.contains(_query) || n.body.contains(_query)).toList();
    }
    // Filter by active tag
    if (_activeTag != null) {
      notes = notes.where((n) => n.tags.contains(_activeTag!)).toList();
    }
    // Sort pinned first if requested, otherwise by updatedAt desc
    if (_pinnedFirst) {
      notes.sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    } else {
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return notes;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }

  void setQuery(String query) {
    _query = query;
    refresh();
  }

  void setActiveTag(String? tag) {
    _activeTag = tag;
    refresh();
  }

  void setPinnedFirst(bool value) {
    _pinnedFirst = value;
    refresh();
  }

  Future<void> togglePin(String noteId) async {
    final repo = ref.read(noteRepositoryProvider);
    final note = repo.getById(noteId);
    if (note != null) {
      final updated = note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
      await repo.upsert(updated);
      refresh();
    }
  }

  Future<void> delete(String noteId) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.delete(noteId);
    refresh();
  }
}
