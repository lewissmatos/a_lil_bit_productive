import 'package:a_lil_bit_productive/helpers/color_helper.dart';
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
    IdlenessView(),
  ];

  const BaseScreen({super.key, required this.pageIndex});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colorSchemeSeed = ref.watch(themeNotifierProvider).colorSchemeSeed;
    void toggleTheme() {
      themeNotifier.toggleTheme();
    }

    void setColorSchemeSeed(Color color) {
      themeNotifier.setColorSchemeSeed(color);
    }

    Future<void> onOpenColorSchemeSelectorDialog() async {
      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ColorSchemeSelectorDialog(
              setColorSchemeSeed: setColorSchemeSeed,
              currentColorSchemeSeed: colorSchemeSeed,
            );
          });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(60), // Set the preferred height here
        child: AppBar(
          centerTitle: false,
          title: Text(
            screenNames[pageIndex],
            style: const TextStyle(fontSize: 40),
          ),
          actions: [
            IconButton(
              onPressed: onOpenColorSchemeSelectorDialog,
              icon: Icon(Icons.color_lens_outlined, color: colorSchemeSeed),
            ),
            IconButton(
              onPressed: toggleTheme,
              icon: Icon(isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: pageIndex),
    );
  }
}

class ColorSchemeSelectorDialog extends StatefulWidget {
  final void Function(Color color) setColorSchemeSeed;
  final Color currentColorSchemeSeed;
  const ColorSchemeSelectorDialog(
      {super.key,
      required this.setColorSchemeSeed,
      required this.currentColorSchemeSeed});

  @override
  State<ColorSchemeSelectorDialog> createState() =>
      _ColorSchemeSelectorDialogState();
}

class _ColorSchemeSelectorDialogState extends State<ColorSchemeSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Color Scheme"),
      content: SizedBox(
        height: 400,
        width: double.maxFinite,
        child: ListView(children: [
          ...Colors.primaries
              .map((color) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      maxRadius: 10,
                    ),
                    title: Text('#${ColorHelper.getHexFromColor(color)}'),
                    onTap: () {
                      widget.setColorSchemeSeed(color);
                      Navigator.of(context).pop();
                    },
                    trailing: widget.currentColorSchemeSeed.value == color.value
                        ? Icon(Icons.check_circle,
                            color: widget.currentColorSchemeSeed)
                        : null,
                  ))
              .toList()
        ]),
      ),
    );
  }
}
