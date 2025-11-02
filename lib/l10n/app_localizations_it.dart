// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Cat Notes';

  @override
  String get notesTitle => 'Note';

  @override
  String get addNote => 'Aggiungi nota';

  @override
  String get editNote => 'Modifica nota';

  @override
  String get deleteNote => 'Elimina';

  @override
  String get saved => 'Salvato 🐾';

  @override
  String get deleted => 'Eliminato';

  @override
  String get emptyState => 'Nessuna nota';

  @override
  String get fontSize => 'Dimensione testo';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get withoutTitle => 'Senza titolo';

  @override
  String get editorTitle => 'Editor';

  @override
  String get save => 'Salva';

  @override
  String get back => 'Indietro';

  @override
  String get titleLabel => 'Titolo';

  @override
  String get bodyLabel => 'Testo';

  @override
  String get newNote => 'Nuova nota';

  @override
  String get noteDeleted => 'Nota eliminata';

  @override
  String get undo => 'Annulla';

  @override
  String get deleteError => 'Errore durante l\'eliminazione';
}
