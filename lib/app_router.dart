import 'package:go_router/go_router.dart';
import 'features/notes/views/note_list_page.dart';
import 'features/notes/views/note_editor_page.dart';
import 'splash/splash_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const NoteListPage(),
    ),
    GoRoute(
      path: '/edit',
      builder: (_, state) {
        final id = state.extra is String ? state.extra as String : state.uri.queryParameters['id'];
        return NoteEditorScaffold(noteId: id);
      },
    ),
  ],
);
