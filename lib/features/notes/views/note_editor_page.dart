import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/text_zoom/text_zoom_controls.dart';
import '../../../core/text_zoom/text_zoom_scope.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
import 'package:catnotes/l10n/app_localizations.dart';

class NoteEditorPage extends StatelessWidget {
  const NoteEditorPage({super.key, this.noteId});
  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('DEBUG: Editor minimal'),
    );
  }
}

class NoteEditorScaffold extends ConsumerStatefulWidget {
  final String? noteId;
  const NoteEditorScaffold({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScaffold> createState() => _NoteEditorScaffoldState();
}

class _NoteEditorScaffoldState extends ConsumerState<NoteEditorScaffold> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      // Notiz laden und Felder setzen
      Future.microtask(() async {
        final repo = ref.read(noteRepositoryProvider);
        final note = repo.getById(widget.noteId!);
        if (note != null) {
          _title.text = note.title;
          _body.text = note.body;
        }
      });
    }
  }

  Future<void> _saveNote() async {
    final title = _title.text.trim();
    final body = _body.text.trim();
    if (title.isEmpty && body.isEmpty) return;
    final repo = ref.read(noteRepositoryProvider);
    final now = DateTime.now();
    final note = Note(
      id: widget.noteId ?? const Uuid().v4(),
      title: title,
      body: body,
      tags: const [],
      isPinned: false,
      remindAt: null,
      imagePath: null,
      createdAt: now,
      updatedAt: now,
    );
    await repo.upsert(note);
    if (mounted) {
      // Prüfe, ob GoRouter verwendet wird
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName != null) {
        context.go('/');
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextZoomScope.of(context);
    final textStyle = TextStyle(fontSize: controller.size);
    return TextZoomControls(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: AppLocalizations.of(context)!.back,
            onPressed: () => context.go('/'),
          ),
          title: Text(AppLocalizations.of(context)!.editorTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: AppLocalizations.of(context)!.save,
              onPressed: _saveNote,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          child: const Icon(Icons.pets, size: 28),
          tooltip: AppLocalizations.of(context)!.save,
        ),
        body: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.titleLabel),
              style: textStyle,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _body,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.bodyLabel),
                maxLines: null,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
