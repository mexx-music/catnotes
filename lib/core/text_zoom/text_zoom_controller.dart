import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextZoomController extends ChangeNotifier {
  static const _kKey = 'message_text_size';
  static const double _min = 10;
  static const double _max = 40;
  static const double _default = 16;

  double _size = _default;
  double get size => _size;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _size = (prefs.getDouble(_kKey) ?? _default).clamp(_min, _max);
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kKey, _size);
  }

  Future<void> increase([double step = 2]) async {
    _size = (_size + step).clamp(_min, _max);
    await _save();
    notifyListeners();
  }

  Future<void> decrease([double step = 2]) async {
    _size = (_size - step).clamp(_min, _max);
    await _save();
    notifyListeners();
  }
}

