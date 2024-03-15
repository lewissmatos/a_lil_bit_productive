import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> get loadingMessageStream async* {
    final List<String> loadingMessages = [
      'loading movies',
      'buying popcorn',
      'checking tickets',
      'getting ready',
      'setting up the screen',
      'checking the sound',
      'preparing the projector',
      'this is taking longer than expected 😥',
    ];

    for (var i = 0; i < loadingMessages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      yield loadingMessages[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("please wait...", style: textStyle),
        const SizedBox(height: 20),
        const CircularProgressIndicator(
          strokeWidth: 2,
        ),
        const SizedBox(height: 20),
        StreamBuilder(
          stream: loadingMessageStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('loading...', style: textStyle);
            }
            return Text(snapshot.data!, style: textStyle);
          },
        )
      ]),
    );
  }
}
