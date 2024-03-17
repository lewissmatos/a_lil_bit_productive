import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        child: const Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center, // Add this line
          children: [
            IdlenessItem(),
          ],
        ),
      ),
    );
  }
}

class IdlenessItem extends StatelessWidget {
  const IdlenessItem({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.45,
      child: Card(
          elevation: 3,
          child: ListTile(
            title: const Text('Short Story'),
            subtitle: const Text('Read a short story'),
            onTap: () {
              context.go('/base/3/short-story');
            },
          )),
    );
  }
}
