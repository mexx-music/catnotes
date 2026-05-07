import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/text_zoom/text_zoom_scope.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
import '../../../features/senior_cat/senior_cat_button.dart';
import '../input/smart_note_input.dart';
import '../input/smart_note_parser.dart';
import 'package:catnotes/l10n/app_localizations.dart';

class NoteEditorPage extends StatelessWidget {
  const NoteEditorPage({super.key, this.noteId});
  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('DEBUG: Editor minimal'));
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

  void _applySmartDraft(SmartNoteDraft draft) {
    _title.text = draft.title;
    _body.text = draft.content;
  }

  // Korrekte Rücknavigation für beide Einstiegspfade:
  // Navigator.push() (FAB in NoteListPage) → pop()
  // GoRouter /edit → go('/')
  void _navigateBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go('/');
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
    if (mounted) _navigateBack();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: AppLocalizations.of(context)!.back,
          onPressed: _navigateBack,
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
        tooltip: AppLocalizations.of(context)!.save,
        child: const Icon(Icons.pets, size: 28),
      ),
      body: Stack(
        children: [
          // Scrollbar verhindert Overflow wenn Tastatur aufgeht
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SmartNoteInput(
                  onApply: _applySmartDraft,
                  onApplyAsContent: (content) => _body.text = content,
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.titleLabel,
                    ),
                    style: textStyle,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  // Unten extra Platz für FAB + SeniorCatButton
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                  child: TextField(
                    controller: _body,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.bodyLabel,
                    ),
                    maxLines: null,
                    minLines: 8,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
          // Senior-Cat Button in der unteren linken Ecke
          Positioned(
            left: 12,
            bottom: 12,
            child: SeniorCatButton(
              getTitleText: () => _title.text,
              getBodyText: () => _body.text,
            ),
          ),
        ],
      ),
    );
  }
}
