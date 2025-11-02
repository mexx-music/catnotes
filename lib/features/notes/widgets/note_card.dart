import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/note.dart';
import 'cat_badges.dart';
import 'paw_watermark.dart';
import '../../settings/controllers/cat_flair_provider.dart';
import '../../../core/text_zoom/zoomable_message_text.dart';
import 'package:catnotes/l10n/app_localizations.dart';
import 'package:catnotes/core/log.dart';

class NoteCard extends ConsumerWidget {
  const NoteCard({super.key, required this.note, this.onTap, this.onDelete});
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flair = ref.watch(catFlairProvider);
    logd('NoteCard build: id=${note.id}, title=${note.title}');
    return Card(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(child: PawWatermark(intensity: flair)),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title.isEmpty ? AppLocalizations.of(context)!.withoutTitle : note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.deepPurple,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (note.isPinned) const Icon(Icons.push_pin, size: 16),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CatBadges(seed: note.id),
                    const SizedBox(height: 8),
                    ZoomableMessageText(
                      note.body.isEmpty ? AppLocalizations.of(context)!.emptyState : note.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
