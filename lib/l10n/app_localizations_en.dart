// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cat Notes';

  @override
  String get notesTitle => 'Notes';

  @override
  String get addNote => 'Add note';

  @override
  String get editNote => 'Edit note';

  @override
  String get deleteNote => 'Delete';

  @override
  String get saved => 'Saved 🐾';

  @override
  String get deleted => 'Deleted';

  @override
  String get emptyState => 'No notes yet';

  @override
  String get fontSize => 'Text size';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get withoutTitle => 'Untitled';

  @override
  String get editorTitle => 'Editor';

  @override
  String get save => 'Save';

  @override
  String get back => 'Back';

  @override
  String get titleLabel => 'Title';

  @override
  String get bodyLabel => 'Text';

  @override
  String get newNote => 'New note';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get undo => 'Undo';

  @override
  String get deleteError => 'Failed to delete note';
}
