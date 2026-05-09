import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
import '../../../theme/app_theme.dart';
import 'package:catnotes/l10n/app_localizations.dart';

/// Einfacher Bearbeiten-Screen für bestehende Notizen.
/// Kein SmartNoteInput, kein Parser, nur Titel + Inhalt.
class SimpleNoteEditPage extends ConsumerStatefulWidget {
  final String noteId;
  const SimpleNoteEditPage({super.key, required this.noteId});

  @override
  ConsumerState<SimpleNoteEditPage> createState() => _SimpleNoteEditPageState();
}

class _SimpleNoteEditPageState extends ConsumerState<SimpleNoteEditPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  Note? _original;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final repo = ref.read(noteRepositoryProvider);
      final note = repo.getById(widget.noteId);
      if (note != null && mounted) {
        _original = note;
        _title.text = note.title;
        _body.text = note.body;
      }
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

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
    final updated = (_original ?? Note(
      id: widget.noteId,
      title: title,
      body: body,
      tags: const [],
      isPinned: false,
      remindAt: null,
      imagePath: null,
      createdAt: now,
      updatedAt: now,
    )).copyWith(
      title: title,
      body: body,
      updatedAt: now,
    );
    await repo.upsert(updated);
    if (mounted) _navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: CatColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.back,
          onPressed: _navigateBack,
        ),
        title: Text(l10n.editorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: l10n.save,
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.titleLabel,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _title,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  hintText: l10n.titleLabel,
                  hintStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: CatColors.textMid,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: CatColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.bodyLabel,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _body,
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  hintText: l10n.bodyLabel,
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: CatColors.textMid,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 21,
                  height: 1.3,
                  color: CatColors.textDark,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
