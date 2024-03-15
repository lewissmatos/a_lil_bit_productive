import 'package:a_lil_bit_productive/presentation/widgets/shared/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../views/views.dart';

final List<String> screenNames = ['reminders', 'notes', 'expenses', 'idleness'];

class BaseScreen extends ConsumerWidget {
  static const String name = 'home-screen';
  final int pageIndex;

  final List<Widget> viewRoutes = const [
    RemindersView(),
    NotesView(),
    ExpensesView(),
    ExpensesView(),
  ];

  const BaseScreen({super.key, required this.pageIndex});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    void toggleTheme() {
      themeNotifier.toggleTheme();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(screenNames[pageIndex]),
        actions: [
          IconButton(
              onPressed: toggleTheme,
              icon: Icon(isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined)),
        ],
      ),
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: pageIndex),
    );
  }
}
