import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    void toggleTheme() {
      themeNotifier.toggleTheme();
    }

    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(
                    Icons.movie_outlined,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "cinemapedia",
                    style: titleStyle,
                  )
                ]),
                const Spacer(),
                IconButton(
                    onPressed: toggleTheme,
                    icon: Icon(isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined)),
              ],
            ),
          ),
        ));
  }
}
