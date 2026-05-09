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

class NoteCard extends ConsumerStatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  ConsumerState<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<NoteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flair = ref.watch(catFlairProvider);
    logd('NoteCard build: id=${widget.note.id}, title=${widget.note.title}');
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Card(
          child: InkWell(
            onTap: widget.onTap,
            child: Stack(
              children: [
                Positioned.fill(child: PawWatermark(intensity: flair)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SeniorCatCardButton(note: widget.note),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.note.title.isEmpty
                                        ? AppLocalizations.of(context)!
                                            .withoutTitle
                                        : widget.note.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.note.isPinned)
                                  const Icon(Icons.push_pin, size: 16),
                              ],
                            ),
                            const SizedBox(height: 6),
                            CatBadges(seed: widget.note.id),
                            const SizedBox(height: 8),
                            ZoomableMessageText(
                              widget.note.body.isEmpty
                                  ? AppLocalizations.of(context)!.emptyState
                                  : widget.note.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onEdit,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.edit_rounded,
                          color: CatColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onDelete,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: widget.isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.delete_outline,
                                  color:
                                      Theme.of(context).colorScheme.error,
                                  size: 22,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
