/// language: dart
import 'dart:developer' as dev;

enum LogLevel { d, i, w, e }

void logd(String msg) => dev.log(msg, level: 500, name: 'CatNotes/D');
void logi(String msg) => dev.log(msg, level: 800, name: 'CatNotes/I');
void logw(String msg, [Object? error, StackTrace? st]) =>
    dev.log(msg, level: 900, name: 'CatNotes/W', error: error, stackTrace: st);
void loge(String msg, [Object? error, StackTrace? st]) =>
    dev.log(msg, level: 1000, name: 'CatNotes/E', error: error, stackTrace: st);

