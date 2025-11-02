import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:catnotes/l10n/app_localizations.dart';

Widget _app(Locale locale) => MaterialApp(
  locale: locale,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'), Locale('de'), Locale('it'),
    Locale('es'), Locale('ja'), Locale('zh'),
  ],
  home: Builder(
    builder: (ctx) => Text(AppLocalizations.of(ctx)!.notesTitle, textDirection: TextDirection.ltr),
  ),
);

void main() {
  testWidgets('loads en/de without throwing', (tester) async {
    await tester.pumpWidget(_app(const Locale('en')));
    await tester.pump();
    expect(find.byType(Text), findsOneWidget);

    await tester.pumpWidget(_app(const Locale('de')));
    await tester.pump();
    expect(find.byType(Text), findsOneWidget);
  });
}

