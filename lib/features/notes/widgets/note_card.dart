import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/note.dart';
import '../../../theme/app_theme.dart';
import 'cat_badges.dart';
import 'paw_watermark.dart';
import '../../settings/controllers/cat_flair_provider.dart';
import '../../../core/text_zoom/zoomable_message_text.dart';
import 'package:catnotes/l10n/app_localizations.dart';
import 'package:catnotes/core/log.dart';

class NoteCard extends ConsumerWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
    this.isDeleting = false,
  });
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flair = ref.watch(catFlairProvider);
    logd('NoteCard build: id=${note.id}, title=${note.title}');
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(child: PawWatermark(intensity: flair)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Senior-Cat-Button links – stoppt Propagation zur Karte
                _SeniorCatCardButton(note: note),
                // Notizinhalt mittig
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.title.isEmpty
                                    ? AppLocalizations.of(context)!.withoutTitle
                                    : note.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (note.isPinned)
                              const Icon(Icons.push_pin, size: 16),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CatBadges(seed: note.id),
                        const SizedBox(height: 8),
                        ZoomableMessageText(
                          note.body.isEmpty
                              ? AppLocalizations.of(context)!.emptyState
                              : note.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // Delete-Button rechts – stoppt Propagation zur Karte
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Öffnet die Notiz im Senior-Cat-Lesemodus.
/// Eigener GestureDetector stoppt Propagation zum Karten-InkWell.
class _SeniorCatCardButton extends StatelessWidget {
  const _SeniorCatCardButton({required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
        '/senior-cat',
        extra: {'title': note.title, 'body': note.body},
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CatColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.auto_stories_rounded,
          color: CatColors.primary,
          size: 24,
        ),
      ),
    );
  }
}
