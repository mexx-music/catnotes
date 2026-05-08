import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/text_zoom/text_zoom_scope.dart';
import '../../../data/models/note.dart';
import '../../../data/repos/note_repository.dart';
import '../../../theme/app_theme.dart';
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
      backgroundColor: CatColors.surface,
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
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _MainInputCard(
                rawInput: _rawInput,
                onApply: () =>
                    _applySmartDraft(parseSmartNoteInput(_rawInput.text)),
                onApplyAsContent: _applyRawAsContent,
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.titleLabel,
                ),
                style: textStyle,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _body,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.bodyLabel,
                ),
                maxLines: null,
                minLines: 6,
                style: textStyle,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Haupt-Eingabekarte mit Katze ──────────────────────────────────────────────

class _MainInputCard extends StatelessWidget {
  final TextEditingController rawInput;
  final VoidCallback onApply;
  final VoidCallback onApplyAsContent;

  const _MainInputCard({
    required this.rawInput,
    required this.onApply,
    required this.onApplyAsContent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Karte, leicht nach unten versetzt damit Katze oben rausschaut
        Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Container(
            decoration: BoxDecoration(
              color: CatColors.cardWhite,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: CatColors.primary.withValues(alpha: 0.10),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: CatColors.primary.withValues(alpha: 0.04),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SmartNoteInput(controller: rawInput),
                const SizedBox(height: 20),
                _InlineButtons(
                  rawController: rawInput,
                  onApply: onApply,
                  onApplyAsContent: onApplyAsContent,
                ),
                const SizedBox(height: 16),
                const _TipBox(),
              ],
            ),
          ),
        ),
        // Katzen-Illustration — sitzt auf dem oberen Kartenrand
        const Positioned(
          top: 0,
          child: _CatAvatar(),
        ),
      ],
    );
  }
}

// ── Inline Action-Buttons ─────────────────────────────────────────────────────

class _InlineButtons extends StatelessWidget {
  final TextEditingController rawController;
  final VoidCallback onApply;
  final VoidCallback onApplyAsContent;

  const _InlineButtons({
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
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: hasText ? onApply : null,
                icon: const Icon(Icons.auto_fix_high, size: 18),
                label: const Text('In Titel & Inhalt übernehmen'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: hasText ? onApplyAsContent : null,
                child: const Text('Nur als Inhalt'),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Tipp-Box ──────────────────────────────────────────────────────────────────

class _TipBox extends StatelessWidget {
  const _TipBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CatColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🐾', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tipp: Diktat ist oft schneller als Tippen.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CatColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: CatColors.primary,
          ),
        ],
      ),
    );
  }
}

// ── Katzen-Illustration ───────────────────────────────────────────────────────

class _CatAvatar extends StatelessWidget {
  const _CatAvatar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 80,
      height: 72,
      child: CustomPaint(painter: _CatAvatarPainter()),
    );
  }
}

class _CatAvatarPainter extends CustomPainter {
  const _CatAvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final headCy = size.height * 0.64;
    const headR = 22.0;

    final whitePaint = Paint()
      ..color = CatColors.cardWhite
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = CatColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    final eyePaint = Paint()
      ..color = CatColors.primary
      ..style = PaintingStyle.fill;
    final nosePaint = Paint()
      ..color = CatColors.peach
      ..style = PaintingStyle.fill;
    final innerEarPaint = Paint()
      ..color = CatColors.peach.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = CatColors.primary.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Weicher Schatten hinter Kopf
    canvas.drawCircle(Offset(cx, headCy + 2), headR + 3, shadowPaint);

    // Ohren (weiß, dann Border, dann Innenfläche)
    final leftEar = Path()
      ..moveTo(cx - headR * 0.65, headCy - headR * 0.60)
      ..lineTo(cx - headR * 1.05, headCy - headR * 1.55)
      ..lineTo(cx - headR * 0.12, headCy - headR * 0.95)
      ..close();
    final rightEar = Path()
      ..moveTo(cx + headR * 0.65, headCy - headR * 0.60)
      ..lineTo(cx + headR * 1.05, headCy - headR * 1.55)
      ..lineTo(cx + headR * 0.12, headCy - headR * 0.95)
      ..close();

    canvas.drawPath(leftEar, whitePaint);
    canvas.drawPath(rightEar, whitePaint);

    // Innenohr rosa
    final innerLeftEar = Path()
      ..moveTo(cx - headR * 0.55, headCy - headR * 0.68)
      ..lineTo(cx - headR * 0.88, headCy - headR * 1.35)
      ..lineTo(cx - headR * 0.18, headCy - headR * 0.98)
      ..close();
    final innerRightEar = Path()
      ..moveTo(cx + headR * 0.55, headCy - headR * 0.68)
      ..lineTo(cx + headR * 0.88, headCy - headR * 1.35)
      ..lineTo(cx + headR * 0.18, headCy - headR * 0.98)
      ..close();

    canvas.drawPath(innerLeftEar, innerEarPaint);
    canvas.drawPath(innerRightEar, innerEarPaint);

    // Kopf
    canvas.drawCircle(Offset(cx, headCy), headR, whitePaint);
    canvas.drawCircle(Offset(cx, headCy), headR, borderPaint);
    canvas.drawPath(leftEar, borderPaint);
    canvas.drawPath(rightEar, borderPaint);

    // Augen
    canvas.drawCircle(Offset(cx - 7, headCy - 5), 3.5, eyePaint);
    canvas.drawCircle(Offset(cx + 7, headCy - 5), 3.5, eyePaint);

    // Glanzpunkt in den Augen
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 5.8, headCy - 6.2), 1.3, shinePaint);
    canvas.drawCircle(Offset(cx + 8.2, headCy - 6.2), 1.3, shinePaint);

    // Nase
    canvas.drawCircle(Offset(cx, headCy + 5), 2.5, nosePaint);

    // Mund
    final mouthPaint = Paint()
      ..color = CatColors.textMid.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(cx, headCy + 7.5)
        ..quadraticBezierTo(cx - 5, headCy + 9.5, cx - 7, headCy + 8),
      mouthPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx, headCy + 7.5)
        ..quadraticBezierTo(cx + 5, headCy + 9.5, cx + 7, headCy + 8),
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(_CatAvatarPainter oldDelegate) => false;
}
