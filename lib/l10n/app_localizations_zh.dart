// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Cat Notes';

  @override
  String get notesTitle => '笔记';

  @override
  String get addNote => '添加笔记';

  @override
  String get editNote => '编辑笔记';

  @override
  String get deleteNote => '删除';

  @override
  String get saved => '已保存 🐾';

  @override
  String get deleted => '已删除';

  @override
  String get emptyState => '还没有笔记';

  @override
  String get fontSize => '文字大小';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get withoutTitle => '无标题';

  @override
  String get editorTitle => '编辑器';

  @override
  String get save => '保存';

  @override
  String get back => '返回';

  @override
  String get titleLabel => '标题';

  @override
  String get bodyLabel => '文本';

  @override
  String get newNote => '新建笔记';

  @override
  String get noteDeleted => '笔记已删除';

  @override
  String get undo => '撤销';

  @override
  String get deleteError => '删除失败';
}
