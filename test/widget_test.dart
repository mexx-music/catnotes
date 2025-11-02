// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catnotes/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app wrapped in a ProviderScope so Riverpod providers are available.
    await tester.pumpWidget(ProviderScope(child: const CatNotesApp()));

    // Allow one frame to settle
    await tester.pumpAndSettle();

    // Verify that the app built and the top-level widget is present.
    expect(find.byType(CatNotesApp), findsOneWidget);
  });
}
