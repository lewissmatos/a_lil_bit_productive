import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatelessWidget {
  int currentIndex;
  CustomBottomNavigationBar({super.key, required this.currentIndex});

  void _onTabTapped({required context, int index = 0}) =>
      GoRouter.of(context).go('/base/$index');

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onTabTapped(context: context, index: index),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'reminders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_alt_outlined),
          label: 'notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_outlined),
          label: 'expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: 'idleness',
        ),
      ],
    );
  }
}
