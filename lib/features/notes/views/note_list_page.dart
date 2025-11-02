import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/note.dart';
import '../widgets/note_card.dart';
import 'package:go_router/go_router.dart';
import 'package:catnotes/data/repos/note_repository.dart';
import 'package:catnotes/l10n/app_localizations.dart';
import 'package:catnotes/core/log.dart';
import '../../../core/text_zoom/text_zoom_controls.dart';
import 'note_editor_page.dart';

// StateNotifier für Lösch-Lade-Status
class LoadingDeleteNotifier extends StateNotifier<Map<String, bool>> {
  LoadingDeleteNotifier() : super({});

  void setDeleting(String noteId, bool isDeleting) {
    state = {...state, noteId: isDeleting};
  }
}

final loadingDeleteProvider = StateNotifierProvider<LoadingDeleteNotifier, Map<String, bool>>(
  (ref) => LoadingDeleteNotifier(),
);

class NoteListPage extends ConsumerWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(noteRepositoryProvider);
    // Lade-Status für Löschvorgang
    final loadingDelete = ref.watch(loadingDeleteProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/cat_notes_holder.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(AppLocalizations.of(context)!.notesTitle),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NoteEditorScaffold(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: AppLocalizations.of(context)!.newNote,
      ),
      body: FutureBuilder(
        future: repo.getAll(),
        builder: (context, snap) {
          return StreamBuilder(
            stream: repo.watchAll(),
            builder: (context, s2) {
              final items = (s2.data?.isNotEmpty == true)
                  ? s2.data!
                  : (snap.data ?? const <Note>[]);
              logd('Notizen-Liste Länge: ${items.length}');
              final body = items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cat_notes_holder.png',
                            width: 220,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.emptyState,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final note = items[i];
                        final isDeleting = loadingDelete[note.id] == true;
                        logd('[DEBUG] itemBuilder: id=${note.id}, title=${note.title}');
                        return Row(
                          children: [
                            Expanded(
                              child: NoteCard(
                                note: note,
                                onTap: () {
                                  context.go('/edit', extra: note.id);
                                },
                              ),
                            ),
                            IconButton(
                              icon: isDeleting
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.delete, color: Colors.red),
                              tooltip: AppLocalizations.of(context)!.deleteNote,
                              onPressed: isDeleting
                                  ? null
                                  : () async {
                                      ref.read(loadingDeleteProvider.notifier).setDeleting(note.id, true);
                                      try {
                                        logd('[DEBUG] Lösche Notiz: id=${note.id}, title=${note.title}');
                                        await repo.delete(note.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(AppLocalizations.of(context)!.noteDeleted),
                                              action: SnackBarAction(
                                                label: AppLocalizations.of(context)!.undo,
                                                onPressed: () async {
                                                  await repo.upsert(note);
                                                },
                                              ),
                                              duration: const Duration(seconds: 5),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${AppLocalizations.of(context)!.deleteError}: $e')),
                                          );
                                        }
                                      } finally {
                                        ref.read(loadingDeleteProvider.notifier).setDeleting(note.id, false);
                                      }
                                    },
                            ),
                          ],
                        );
                      },
                    );
              return TextZoomControls(child: body);
            },
          );
        },
      ),
    );
  }
}
