import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/view/home/chat/image_viewer.dart';

class ImageContainer extends StatelessWidget {
  final String conversationId;

  const ImageContainer({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatImage>>(
      stream: ConversationController.instance.streamConversationImages(
        conversationId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final images = snapshot.data!;
        if (images.isEmpty) {
          return const Center(child: Text('Nincsenek képek'));
        }

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
                    pageBuilder: (_, __, ___) => ImageCarouselViewer(
                      images: images,
                      initialIndex: index,
                    ),
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
      },
    );
  }
}
