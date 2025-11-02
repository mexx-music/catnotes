import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/models/note.dart';
import 'data/repos/note_repository.dart';
import 'app_router.dart';
import 'core/text_zoom/text_zoom_controller.dart';
import 'core/text_zoom/text_zoom_scope.dart';
import 'theme/app_theme.dart';
import 'package:catnotes/l10n/app_localizations.dart';

final _textZoomController = TextZoomController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Adapter exakt EINMAL registrieren
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(NoteAdapter());
  }

  final b2 = await Hive.openBox<Note>('notesBox2');
  final b1 = await Hive.openBox<Note>('notesBox');

  if (b1.isEmpty && b2.isNotEmpty) {
    for (final key in b2.keys) {
      final n = b2.get(key);
      if (n != null) await b1.put(n.id, n);
    }
    // Optional: b2.clear(); // auskommentiert lassen (Sicherheit)
  }

  // Für die App-Laufzeit NUR notesBox verwenden:
  final box = b1;
  await _textZoomController.load();
  runApp(TextZoomScope(
    controller: _textZoomController,
    child: ProviderScope(
      overrides: [
        noteRepositoryProvider.overrideWithValue(NoteRepository(box)),
      ],
      child: const CatNotesApp(),
    ),
  ));
}

class CatNotesApp extends StatelessWidget {
  const CatNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('it'),
        Locale('es'),
        Locale('ja'),
        Locale('zh'),
      ],
    );
  }
}
