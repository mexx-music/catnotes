// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cat Notes';

  @override
  String get notesTitle => 'Notas';

  @override
  String get addNote => 'Añadir nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get deleteNote => 'Eliminar';

  @override
  String get saved => 'Guardado 🐾';

  @override
  String get deleted => 'Eliminado';

  @override
  String get emptyState => 'Aún no hay notas';

  @override
  String get fontSize => 'Tamaño de texto';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get withoutTitle => 'Sin título';

  @override
  String get editorTitle => 'Editor';

  @override
  String get save => 'Guardar';

  @override
  String get back => 'Atrás';

  @override
  String get titleLabel => 'Título';

  @override
  String get bodyLabel => 'Texto';

  @override
  String get newNote => 'Nueva nota';

  @override
  String get noteDeleted => 'Nota eliminada';

  @override
  String get undo => 'Deshacer';

  @override
  String get deleteError => 'Error al eliminar';
}
