import 'package:a_lil_bit_productive/presentation/providers/short_story/short_story_impl_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkedStoriesScreen extends ConsumerStatefulWidget {
  final setStoryValue;
  const BookmarkedStoriesScreen({
    super.key,
    required this.setStoryValue,
  });

  @override
  BookmarkedStoriesScreenState createState() => BookmarkedStoriesScreenState();
}

class BookmarkedStoriesScreenState
    extends ConsumerState<BookmarkedStoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: screenSize.height * 0.8,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Bookmarked Stories',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Expanded(
          child: FutureBuilder(
            future: ref
                .read(shortStoryRepositoryImplProvider)
                .getBookmarkedStories()
                .then((value) {
              return value;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                final stories = snapshot.data as List;

                return ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(story.title),
                        subtitle: Text(story.moral),
                        onTap: () {
                          widget.setStoryValue(story);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text('No Bookmarked Stories'),
              );
            },
          ),
        ),
      ]),
    );
  }
}


// ElevatedButton(
//               child: const Text('Close BottomSheet'),
//               onPressed: () => Navigator.pop(context),
//             ),