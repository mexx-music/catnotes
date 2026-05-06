import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catnotes/core/text_zoom/text_zoom_scope.dart';
import 'package:catnotes/app/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = await initializeApp();

  runApp(
    TextZoomScope(
      controller: getTextZoomController(),
      child: UncontrolledProviderScope(
        container: container,
        child: buildApp(),
      ),
    ),
  );
}

