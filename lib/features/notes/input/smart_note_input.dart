import 'package:flutter/material.dart';

/// Kompaktes Diktat/Schreib-Eingabefeld.
/// Action-Buttons werden vom Parent verwaltet, damit sie immer sichtbar bleiben.
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.mic, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Diktieren oder schreiben',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _focusNode.requestFocus(),
                icon: const Icon(Icons.keyboard_alt_outlined, size: 14),
                label: const Text('Tastatur öffnen'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: true,
            maxLines: 4,
            minLines: 2,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Erste Zeile → Titel, Rest → Inhalt',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: Tooltip(
                message: 'Mikrofon-Taste der Tastatur für Diktat',
                child: Icon(
                  Icons.mic_none,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
