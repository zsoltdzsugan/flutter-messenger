import 'package:flutter/material.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/utils/chat_image.dart';

class ImageCarouselViewer extends StatefulWidget {
  final List<ChatImage> images;
  final int initialIndex;

  const ImageCarouselViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageCarouselViewer> createState() => _ImageCarouselViewerState();
}

class _ImageCarouselViewerState extends State<ImageCarouselViewer> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final device = t.device;

    bool showArrows =
        device == DeviceType.desktop || device == DeviceType.tablet;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (_, index) {
              final img = widget.images[index];
              return InteractiveViewer(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: img.width / img.height,
                    child: Image.network(img.url, fit: BoxFit.contain),
                  ),
                ),
              );
            },
          ),

          if (showArrows) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],

          // Close button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
