// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Cat Notes';

  @override
  String get notesTitle => 'メモ';

  @override
  String get addNote => 'メモを追加';

  @override
  String get editNote => 'メモを編集';

  @override
  String get deleteNote => '削除';

  @override
  String get saved => '保存しました 🐾';

  @override
  String get deleted => '削除しました';

  @override
  String get emptyState => 'メモはまだありません';

  @override
  String get fontSize => '文字サイズ';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get withoutTitle => 'タイトルなし';

  @override
  String get editorTitle => 'エディタ';

  @override
  String get save => '保存';

  @override
  String get back => '戻る';

  @override
  String get titleLabel => 'タイトル';

  @override
  String get bodyLabel => 'テキスト';

  @override
  String get newNote => '新しいメモ';

  @override
  String get noteDeleted => 'メモを削除しました';

  @override
  String get undo => '元に戻す';

  @override
  String get deleteError => '削除に失敗しました';
}
