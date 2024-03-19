import 'package:a_lil_bit_productive/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
    //Initial Route
    initialLocation: '/base/0',
    routes: [
      // HomeScreen
      GoRoute(
        path: '/base/:page',
        builder: (context, state) {
          final int pageIndex = int.parse(state.pathParameters['page'] ?? '0');
          return BaseScreen(pageIndex: pageIndex);
        },
        routes: [
          GoRoute(
            path: 'new-reminder',
            builder: (context, state) {
              return const NewReminderScreen();
            },
          ),
          GoRoute(
            path: 'reminder/:reminderId',
            builder: (context, state) {
              final reminderId = state.pathParameters['reminderId'] != null
                  ? int.parse(state.pathParameters['reminderId']!)
                  : null;

              return NewReminderScreen(reminderId: reminderId);
            },
          ),
          GoRoute(
            path: 'new-note',
            builder: (context, state) {
              return const NewNoteScreen();
            },
          ),
          GoRoute(
            path: 'note/:noteId',
            builder: (context, state) {
              final noteId = state.pathParameters['noteId'] != null
                  ? int.parse(state.pathParameters['noteId']!)
                  : null;

              return NewNoteScreen(noteId: noteId);
            },
          ),
          GoRoute(
            path: 'short-story',
            builder: (context, state) {
              return const ShortStoryScreen();
            },
          ),
          GoRoute(
            path: 'art-images-gallery',
            builder: (context, state) {
              return const ArtImagesGalleryScreen();
            },
          ),
          GoRoute(
            path: 'add-expense',
            builder: (context, state) {
              return const NewExpenseScreen();
            },
          ),
          GoRoute(
            path: 'expense/:expenseId',
            builder: (context, state) {
              final expenseId = state.pathParameters['expenseId'] != null
                  ? int.parse(state.pathParameters['expenseId']!)
                  : null;
              return NewExpenseScreen(expenseId: expenseId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        redirect: (_, __) => '/base/0',
      )
    ]);
