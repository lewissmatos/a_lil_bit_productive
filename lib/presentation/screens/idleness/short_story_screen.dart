import 'package:a_lil_bit_productive/presentation/providers/short_story/short_story_impl_provider.dart';
import 'package:a_lil_bit_productive/presentation/screens/idleness/bookmarked_stories_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/entities.dart';

class ShortStoryScreen extends ConsumerStatefulWidget {
  const ShortStoryScreen({super.key});

  @override
  ShortStoryScreenState createState() => ShortStoryScreenState();
}

class ShortStoryScreenState extends ConsumerState<ShortStoryScreen> {
  ShortStory story = ShortStory(storyId: '', title: '', description: '');
  bool isStoryFetched = false;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> fetchStory() async {
    ref.read(shortStoryRepositoryImplProvider).getShortStory().then((value) {
      setState(() {
        story = value;
        isStoryFetched = true;
      });
    });

    return true;
  }

  void setStoryValue(ShortStory newStory) {
    setState(() {
      story = newStory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shortStoryProvider = ref.read(shortStoryRepositoryImplProvider);

    Future<ShortStory?> bookmarkShortStory() async {
      return await shortStoryProvider
          .bookmarkShortStory(story: story)
          .then((value) {
        setState(() {
          story = value!;
          isStoryFetched = true;
        });
        return story;
      });
    }

    void onShowModalBottomSheet() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BookmarkedStoriesScreen(setStoryValue: setStoryValue);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Short Story'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: onShowModalBottomSheet,
            icon: const Icon(Icons.bookmark_border_outlined),
          ),
        ],
      ),
      body: !isStoryFetched
          ? Container(
              alignment: Alignment.center,
              child: FadeInLeft(
                  duration: const Duration(milliseconds: 500),
                  child: SpinPerfect(
                    infinite: true,
                    child: const Icon(
                      Icons.sync,
                      size: 50,
                    ),
                  )),
            )
          : FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: Dismissible(
                key: Key(story.storyId),
                background: DismissibleItemBackground(
                  isBookmarked: story.isBookmarked,
                ),
                secondaryBackground:
                    FadeIn(child: const DismissibleItemSecondaryBackground()),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await bookmarkShortStory();
                    return false;
                  }
                  setState(() {
                    isStoryFetched = false;
                  });
                  await fetchStory();
                  return true;
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(children: [
                      ShortStoryContainer(story: story),
                      Positioned(
                        bottom: 40,
                        right: 0,
                        child: FadeOut(
                          child: Column(children: [
                            IconButton.filledTonal(
                              onPressed: () async {
                                await bookmarkShortStory();
                              },
                              icon: Icon(
                                !story.isBookmarked
                                    ? Icons.bookmark_add_outlined
                                    : Icons.bookmark_remove_outlined,
                                color: !story.isBookmarked
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () async {
                                setState(() {
                                  isStoryFetched = false;
                                });
                                await fetchStory();
                              },
                              icon: const Icon(Icons.next_plan_outlined),
                            ),
                          ]),
                        ),
                      ),
                    ])),
              ),
            ),
    );
  }
}

class ShortStoryContainer extends StatelessWidget {
  final ShortStory story;
  const ShortStoryContainer({
    required this.story,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height, // or any specific height

      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  story.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (story.isBookmarked)
                const Icon(Icons.bookmark_added_outlined,
                    size: 30, color: Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            story.description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          // TextField(
          //   controller: TextEditingController(text: story.description),
          //   maxLines: 20,
          //   readOnly: true,
          //   style: const TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.normal,
          //   ),
          //   decoration: const InputDecoration(
          //     isCollapsed: true,
          //     border: OutlineInputBorder(
          //       borderSide: BorderSide.none,
          //     ),
          //     hintText: 'more details',
          //   ),
          // ),
          const SizedBox(height: 10),
          Text(
            '-${story.moral}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class DismissibleItemBackground extends StatelessWidget {
  final bool isBookmarked;
  const DismissibleItemBackground({
    super.key,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Icon(
            !isBookmarked
                ? Icons.bookmark_add_outlined
                : Icons.bookmark_remove_outlined,
            color: !isBookmarked ? Colors.green : Colors.orange,
          ),
          Text(!isBookmarked ? " bookmark" : " remove bookmark",
              style: TextStyle(
                color: !isBookmarked ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }
}

class DismissibleItemSecondaryBackground extends StatelessWidget {
  const DismissibleItemSecondaryBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.next_plan_outlined,
          ),
          Text(" Next Story", style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
