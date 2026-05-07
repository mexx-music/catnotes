import 'package:flutter/material.dart';
import 'smart_note_parser.dart';

/// Großer Eingabebereich für Freitext oder System-Diktat.
/// Parst den Text per [parseSmartNoteInput] in Titel + Inhalt.
class SmartNoteInput extends StatefulWidget {
  final void Function(SmartNoteDraft draft) onApply;
  final void Function(String content)? onApplyAsContent;

  const SmartNoteInput({
    super.key,
    required this.onApply,
    this.onApplyAsContent,
  });

  @override
  State<SmartNoteInput> createState() => _SmartNoteInputState();
}

class _SmartNoteInputState extends State<SmartNoteInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _apply() {
    final draft = parseSmartNoteInput(_controller.text);
    widget.onApply(draft);
    _controller.clear();
  }

  void _applyAsContent() {
    widget.onApplyAsContent?.call(_controller.text.trim());
    _controller.clear();
  }

  void _requestFocus() => _focusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.mic, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Diktieren oder schreiben',
                    style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                  ),
                ),
                // Fokus-Button öffnet Tastatur inkl. System-Diktat
                TextButton.icon(
                  onPressed: _requestFocus,
                  icon: const Icon(Icons.keyboard_alt_outlined, size: 16),
                  label: const Text('Diktat starten'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tippe auf „Diktat starten" oder direkt ins Feld – '
              'dann das Mikrofon-Symbol deiner Tastatur nutzen.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              maxLines: 5,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Sprich oder schreibe deine Notiz…\n\nErste Zeile → Titel, Rest → Inhalt.',
                hintMaxLines: 3,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: const Tooltip(
                  message: 'Mikrofon-Taste deiner Tastatur für Diktat nutzen',
                  child: Icon(Icons.mic_none),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _hasText ? _apply : null,
                    icon: const Icon(Icons.auto_fix_high, size: 18),
                    label: const Text('In Titel & Inhalt übernehmen'),
                  ),
                ),
                if (widget.onApplyAsContent != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _hasText ? _applyAsContent : null,
                    child: const Text('Nur als Inhalt'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
