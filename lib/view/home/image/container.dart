import 'package:flutter/material.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/view/home/chat/image_viewer.dart';

class ImageContainer extends StatelessWidget {
  final List<ChatImage> images;

  const ImageContainer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final img = images[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) =>
                    ImageCarouselViewer(images: images, initialIndex: index),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
              tag: img.heroTag,
              child: Image.network(img.url, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
