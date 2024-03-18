import 'package:a_lil_bit_productive/domain/entities/art_image.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;

class ArtImageItem extends StatefulWidget {
  final Future<void> Function({int pageAddition, bool reload}) fetchImages;
  final ArtImage image;
  const ArtImageItem(
      {super.key, required this.image, required this.fetchImages});

  @override
  State<ArtImageItem> createState() => ArtImageItemState();
}

class ArtImageItemState extends State<ArtImageItem> {
  Future<void> saveImage({
    required BuildContext context,
    required ArtImage image,
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message = '';

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(image.mediaUrl));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/image${image.id}.png';

      // Save to filesystem
      final file = File(filename);

      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'image saved to disk';
      }
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    if (message.isNotEmpty) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    final avgColor = image.avgColor ?? Colors.white;
    return Dismissible(
      key: Key(image.id.toString()),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await widget.fetchImages(pageAddition: -1, reload: true);
        } else {
          await widget.fetchImages(pageAddition: 1, reload: true);
        }
        return false;
      },
      background: DismissibleBackground(
        isPrimary: true,
        text: 'load previous 15',
        icon: Icons.rotate_left_sharp,
        color: avgColor,
      ),
      secondaryBackground: DismissibleBackground(
        isPrimary: false,
        text: 'load next 15',
        icon: Icons.rotate_right_outlined,
        color: avgColor,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadeIn(
            child: Image.network(
              image.mediaUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    avgColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 50,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () async {
                        await widget.fetchImages(
                            pageAddition: -1, reload: true);
                      },
                      icon: const Icon(
                        Icons.rotate_left_sharp,
                      ),
                      iconSize: 24,
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          avgColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () async {
                        await saveImage(context: context, image: image);
                      },
                      label: const Text(
                        'save to files',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.save_alt_outlined,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          avgColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        await widget.fetchImages(pageAddition: 1, reload: true);
                      },
                      icon: const Icon(
                        Icons.rotate_right_outlined,
                      ),
                      iconSize: 24,
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          avgColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  final bool isPrimary;
  final String text;
  final IconData icon;
  final Color color;
  const DismissibleBackground({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color.withOpacity(0.8),
      child: Row(
        mainAxisAlignment:
            isPrimary ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Icon(icon),
          Text(" $text", style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
