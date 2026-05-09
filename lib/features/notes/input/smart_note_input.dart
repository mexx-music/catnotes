import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Diktat/Schreib-Eingabefeld im Card-Stil.
/// Action-Buttons werden vom Parent verwaltet.
class SmartNoteInput extends StatefulWidget {
  final TextEditingController controller;

  const SmartNoteInput({super.key, required this.controller});

  @override
  State<SmartNoteInput> createState() => _SmartNoteInputState();
}

class _SmartNoteInputState extends State<SmartNoteInput> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.mic, size: 16, color: CatColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Diktieren oder schreiben',
                style: textTheme.labelMedium?.copyWith(
                  color: CatColors.textMid,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _focusNode.requestFocus(),
              icon: const Icon(Icons.keyboard_alt_outlined, size: 15),
              label: const Text('Tastatur öffnen'),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: textTheme.labelSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: true,
          maxLines: 8,
          minLines: 5,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'z. B. Einkauf: Milch und Brot kaufen',
            contentPadding: EdgeInsets.fromLTRB(16, 18, 16, 18),
            suffixIcon: Tooltip(
              message: 'Mikrofon-Taste der Tastatur für Diktat',
              child: Icon(
                Icons.mic_none,
                size: 20,
                color: CatColors.textMid,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Text(
                'Doppelpunkt trennt Titel und Inhalt',
                style: TextStyle(
                  fontSize: 12,
                  color: CatColors.textMid.withValues(alpha: 0.80),
                ),
              ),
              const Spacer(),
              Text(
                '🐾',
                style: TextStyle(
                  fontSize: 12,
                  color: CatColors.textMid.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
