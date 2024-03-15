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
            final int pageIndex =
                int.parse(state.pathParameters['page'] ?? '0');
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
          ]),
      GoRoute(
        path: '/',
        redirect: (_, __) => '/base/0',
      )
    ]);
