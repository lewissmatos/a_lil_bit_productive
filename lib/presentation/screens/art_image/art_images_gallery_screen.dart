import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/presentation/providers/art_image/art_image_impl_provider.dart';
import 'package:a_lil_bit_productive/presentation/screens/screens.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtImagesGalleryScreen extends ConsumerStatefulWidget {
  const ArtImagesGalleryScreen({Key? key}) : super(key: key);

  @override
  ArtImagesGalleryScreenState createState() => ArtImagesGalleryScreenState();
}

class ArtImagesGalleryScreenState
    extends ConsumerState<ArtImagesGalleryScreen> {
  List<ArtImage?> images = [];

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchImages({int pageAddition = 0, bool reload = false}) async {
    if (!(currentPage == 1 && pageAddition < 0)) {
      currentPage += pageAddition;
    }
    final newImages = await ref
        .read(artImageRepositoryImplProvider)
        .getArtImages(page: currentPage);

    if (reload) {
      setState(() {
        images = newImages;
        return;
      });
    } else {
      setState(() {
        images.addAll(newImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
        child: PageView.builder(
          controller: PageController(
            keepPage: true,
          ),
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final image = images[index];
            if (image == null) {
              return const Center(child: Text('no data available'));
            }

            return FadeInUp(
              child: ArtImageItem(
                fetchImages: fetchImages,
                image: image,
              ),
            );
          },
          onPageChanged: (index) {
            if (index == images.length - 2) {
              fetchImages(pageAddition: 1);
            }
          },
        ),
      ),
    );
  }
}
