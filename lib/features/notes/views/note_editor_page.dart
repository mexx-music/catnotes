import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/text_zoom/text_zoom_scope.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
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
  final _rawInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
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

  void _applySmartDraft(SmartNoteDraft draft) {
    _title.text = draft.title;
    _body.text = draft.content;
    _rawInput.clear();
  }

  void _applyRawAsContent() {
    _body.text = _rawInput.text.trim();
    _rawInput.clear();
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
    _rawInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextZoomScope.of(context);
    final textStyle = TextStyle(fontSize: controller.size);

    return Scaffold(
      // resizeToAvoidBottomInset: true (default) → Scaffold verkleinert body
      // automatisch wenn Tastatur erscheint → _ActionBar bleibt immer sichtbar.
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
      body: SafeArea(
        child: Column(
          children: [
            // Scrollbarer Inhalt
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SmartNoteInput(controller: _rawInput),
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
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                      child: TextField(
                        controller: _body,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.bodyLabel,
                        ),
                        maxLines: null,
                        minLines: 6,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action-Buttons: immer sichtbar, dank resizeToAvoidBottomInset
            // automatisch direkt über der Tastatur.
            _ActionBar(
              rawController: _rawInput,
              onApply: () =>
                  _applySmartDraft(parseSmartNoteInput(_rawInput.text)),
              onApplyAsContent: _applyRawAsContent,
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned Action-Bar mit den beiden Übernahme-Buttons.
/// Reagiert reaktiv auf Änderungen im [rawController].
class _ActionBar extends StatelessWidget {
  final TextEditingController rawController;
  final VoidCallback onApply;
  final VoidCallback onApplyAsContent;

  const _ActionBar({
    required this.rawController,
    required this.onApply,
    required this.onApplyAsContent,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: rawController,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: hasText ? onApply : null,
                  icon: const Icon(Icons.auto_fix_high, size: 18),
                  label: const Text('In Titel & Inhalt übernehmen'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: hasText ? onApplyAsContent : null,
                child: const Text('Nur als Inhalt'),
              ),
            ],
          ),
        );
      },
    );
  }
}
