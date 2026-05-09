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
/// Zeigt beim Fokus auf Titel/Inhalt ein Aktions-Panel unterhalb der Felder.
class SimpleNoteEditPage extends ConsumerStatefulWidget {
  final String noteId;
  const SimpleNoteEditPage({super.key, required this.noteId});

  @override
  ConsumerState<SimpleNoteEditPage> createState() => _SimpleNoteEditPageState();
}

class _SimpleNoteEditPageState extends ConsumerState<SimpleNoteEditPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _titleFocus = FocusNode();
  final _bodyFocus = FocusNode();
  Note? _original;

  bool _showPanel = false;
  // true nachdem der Nutzer "Weiter editieren" gewählt hat —
  // verhindert sofortiges Wiedererscheinen solange Feld fokussiert bleibt
  bool _manuallyDismissed = false;

  @override
  void initState() {
    super.initState();
    _titleFocus.addListener(_onFocusChanged);
    _bodyFocus.addListener(_onFocusChanged);
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
    _titleFocus.removeListener(_onFocusChanged);
    _bodyFocus.removeListener(_onFocusChanged);
    _titleFocus.dispose();
    _bodyFocus.dispose();
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    final hasFocus = _titleFocus.hasFocus || _bodyFocus.hasFocus;
    if (hasFocus && !_manuallyDismissed) {
      if (!_showPanel) setState(() => _showPanel = true);
    } else if (!hasFocus) {
      // Verzögerung: laufende Button-Taps müssen abgeschlossen sein,
      // bevor das Panel aus dem Widget-Tree entfernt wird.
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        if (!_titleFocus.hasFocus && !_bodyFocus.hasFocus) {
          setState(() {
            _showPanel = false;
            _manuallyDismissed = false;
          });
        }
      });
    }
  }

  void _closePanel() {
    setState(() {
      _showPanel = false;
      _manuallyDismissed = true;
    });
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
    final updated = (_original ??
            Note(
              id: widget.noteId,
              title: title,
              body: body,
              tags: const [],
              isPinned: false,
              remindAt: null,
              imagePath: null,
              createdAt: now,
              updatedAt: now,
            ))
        .copyWith(title: title, body: body, updatedAt: now);
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

              // ── Titel ───────────────────────────────────────────────────────
              Text(l10n.titleLabel,
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _title,
                focusNode: _titleFocus,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 14),
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

              // ── Inhalt ───────────────────────────────────────────────────────
              Text(l10n.bodyLabel,
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _body,
                focusNode: _bodyFocus,
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 14),
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

              // ── Aktions-Panel (inline, unterhalb der Felder) ─────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: _showPanel
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _ActionPanel(
                          onSave: _saveNote,
                          onContinue: _closePanel,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Inline Aktions-Panel ──────────────────────────────────────────────────────

class _ActionPanel extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onContinue;

  const _ActionPanel({required this.onSave, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CatColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: CatColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('🐾', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Was möchtest du tun?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              FocusScope.of(context).unfocus();
              onSave();
            },
            icon: const Icon(Icons.save_rounded, size: 20),
            label: const Text('Speichern'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onContinue,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Weiter editieren'),
          ),
        ],
      ),
    );
  }
}
