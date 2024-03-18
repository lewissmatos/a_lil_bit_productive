import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final List<Map<String, String>> idlenessItems = [
  {
    'title': 'Short Story',
    'subtitle': 'Read a short story',
    'route': '/base/3/short-story',
  },
  {
    'title': 'Art Images',
    'subtitle': 'View art images',
    'route': '/base/3/art-images-gallery',
  },
];

class IdlenessView extends ConsumerStatefulWidget {
  const IdlenessView({super.key});

  @override
  IdlenessViewState createState() => IdlenessViewState();
}

class IdlenessViewState extends ConsumerState<IdlenessView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center, // Add this line
          children: [
            ...idlenessItems.map((item) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: IdlenessItem(
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                    route: item['route']!,
                  ));
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class IdlenessItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;
  const IdlenessItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.route});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.45,
      child: Card(
          elevation: 3,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            onTap: () {
              context.go(route);
            },
          )),
    );
  }
}
