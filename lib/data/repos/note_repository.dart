import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import 'package:catnotes/core/log.dart';

class NoteRepository {
  NoteRepository(this._box);
  final Box<Note> _box;

  Future<void> upsert(Note note) async {
    await _box.put(note.id, note);
    logi('[repo] upsert ${note.id} total=${_box.length}');
  }

  Future<List<Note>> getAll({bool pinnedFirst = true}) async {
    return _sorted(_box.values.toList(), pinnedFirst: pinnedFirst);
  }

  Stream<List<Note>> watchAll({bool pinnedFirst = true}) {
    final listenable = _box.listenable();
    return Stream<List<Note>>.multi((controller) {
      void emit() => controller.add(_sorted(_box.values.toList(), pinnedFirst: pinnedFirst));
      emit();
      listenable.addListener(emit);
      controller.onCancel = () => listenable.removeListener(emit);
    });
  }

  Note? getById(String id) => _box.get(id);
  Future<void> delete(String id) async => _box.delete(id);

  Map<String, dynamic> _toMap(Note n) => {
    'id': n.id,
    'title': n.title,
    'body': n.body,
    'tags': n.tags,
    'isPinned': n.isPinned,
    'remindAt': n.remindAt?.toIso8601String(),
    'imagePath': n.imagePath,
    'createdAt': n.createdAt.toIso8601String(),
    'updatedAt': n.updatedAt.toIso8601String(),
  };

  Note _fromMap(Map<String,dynamic> m) => Note(
    id: m['id'] as String,
    title: (m['title'] ?? '') as String,
    body: (m['body'] ?? '') as String,
    tags: (m['tags'] as List?)?.cast<String>() ?? const <String>[],
    isPinned: (m['isPinned'] ?? false) as bool,
    remindAt: (m['remindAt'] != null) ? DateTime.parse(m['remindAt']) : null,
    imagePath: m['imagePath'] as String?,
    createdAt: DateTime.parse(m['createdAt']),
    updatedAt: DateTime.parse(m['updatedAt']),
  );

  Future<String> exportJson() async {
    final list = _box.values.map(_toMap).toList();
    return jsonEncode(list);
  }

  Future<int> importJson(String jsonStr) async {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! List) return 0;
    var count = 0;
    for (final e in decoded) {
      final note = _fromMap(Map<String,dynamic>.from(e as Map));
      await _box.put(note.id, note);
      count++;
    }
    return count;
  }

  List<Note> _sorted(List<Note> items, {required bool pinnedFirst}) {
    items.sort((a, b) {
      final pin = (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0);
      if (pinnedFirst && pin != 0) return pin;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return items;
  }
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  throw UnimplementedError('noteRepositoryProvider must be overridden');
});
