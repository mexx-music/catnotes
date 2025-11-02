import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repos/note_repository.dart';
import '../controllers/cat_flair_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flair = ref.watch(catFlairProvider);
    final repo = ref.watch(noteRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          const Center(child: Text('Settings kommen hierhin')),
          ListTile(
            title: const Text('Mehr Katze'),
            subtitle: Text('Level ${flair}'),
          ),
          Slider(
            value: flair.toDouble(),
            min: 0,
            max: 3,
            divisions: 3,
            label: '$flair',
            onChanged: (v) =>
                ref.read(catFlairProvider.notifier).state = v.round(),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Backup als JSON kopieren'),
            onTap: () async {
              final json = await repo.exportJson();
              await Clipboard.setData(ClipboardData(text: json));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup kopiert')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Aus JSON wiederherstellen'),
            onTap: () async {
              final controller = TextEditingController();
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('JSON einfügen'),
                  content: TextField(
                    controller: controller,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: 'JSON hier einfügen'),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Importieren')),
                  ],
                ),
              );
              if (ok == true) {
                final cnt = await repo.importJson(controller.text);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${cnt} Notizen importiert')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
