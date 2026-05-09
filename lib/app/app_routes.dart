import 'package:go_router/go_router.dart';
import 'package:catnotes/features/notes/views/note_list_page.dart';
import 'package:catnotes/features/notes/views/note_editor_page.dart';
import 'package:catnotes/features/senior_cat/senior_cat_page.dart';
import 'package:catnotes/splash/splash_screen.dart';
import 'package:catnotes/features/home/views/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/', builder: (_, __) => const NoteListPage()),
    GoRoute(
      path: '/edit',
      builder: (_, state) {
        final id = state.extra is String
            ? state.extra as String
            : state.uri.queryParameters['id'];
        return NoteEditorScaffold(noteId: id);
      },
    ),
    GoRoute(
      path: '/senior-cat',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final title = extra?['title'] as String? ?? '';
        final body = extra?['body'] as String? ?? '';
        return SeniorCatPage(title: title, body: body);
      },
    ),
  ],
);
