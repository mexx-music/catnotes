import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeniorCatButton extends StatelessWidget {
  final String Function() getTitleText;
  final String Function() getBodyText;

  const SeniorCatButton({
    super.key,
    required this.getTitleText,
    required this.getBodyText,
  });

  void _openSeniorMode(BuildContext context) {
    // Text direkt beim Klick lesen
    final title = getTitleText().trim();
    final body = getBodyText().trim();

    context.push(
      '/senior-cat',
      extra: {
        'title': title,
        'body': body,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
      child: IconButton(
        tooltip: 'Senior-Cat Lesemodus',
        icon: const Icon(Icons.visibility, size: 24),
        onPressed: () => _openSeniorMode(context),
      ),
    );
  }
}
