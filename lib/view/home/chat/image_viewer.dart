import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/picker_mode.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/widgets/picker/picker.dart';

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
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _saveImage() {
    final image = widget.images[_currentIndex];
    ConversationController.instance.saveImageByUrl(image.url);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image saved')));
  }

  void _forwardImage() {
    final image = widget.images[_currentIndex];

    showPicker(
      context: context,
      mode: PickerMode.forward,
      onSelected: (userId) {
        ConversationController.instance.forwardImage(image, userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final device = t.device;

    bool showArrows =
        device == DeviceType.desktop || device == DeviceType.tablet;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
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
              child: Padding(
                padding: EdgeInsets.all(t.spacing(c.spaceXSmall)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      t.spacing(c.spaceSmall),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: context.core.colors.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(t.spacing(c.spaceXSmall)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      t.spacing(c.spaceSmall),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: context.core.colors.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Close button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(t.spacing(c.spaceXSmall)),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                          context.core.baseRadius * t.radiusScale,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: t.spacing(c.spaceSmall),
                        vertical: t.spacing(1),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: context.core.colors.textPrimary,
                              size: 28,
                            ),
                            onPressed: _forwardImage,
                          ),
                          SizedBox(width: t.spacing(c.spaceSmall)),
                          IconButton(
                            icon: Icon(
                              Icons.download,
                              color: context.core.colors.textPrimary,
                              size: 28,
                            ),
                            onPressed: _saveImage,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: t.spacing(c.spaceLarge)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                          context.core.baseRadius * t.radiusScale,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: context.core.colors.textPrimary,
                          size: 32,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
