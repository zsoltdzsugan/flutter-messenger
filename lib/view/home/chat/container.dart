import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/view/home/chat/composer.dart';
import 'package:messenger/view/home/chat/header.dart';
import 'package:messenger/view/home/image/container.dart';
import 'package:messenger/widgets/chat/typing_indicator.dart';
import 'package:messenger/widgets/message/container.dart';

class ChatContainer extends StatefulWidget {
  final String conversationId;
  final String otherUserId;

  const ChatContainer({
    super.key,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  bool showImages = false;
  final List<ChatImage> images = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markConversationRead();
  }

  void _toggleImages() {
    setState(() {
      showImages = !showImages;
    });
  }

  Future<void> _markConversationRead() {
    return ConversationController.instance.markConversationAsRead(
      widget.conversationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(MainBgColors.chat);
    final textColor = context.resolveStateColor(MainBgColors.text);

    return Column(
      children: [
        ChatHeader(
          conversationId: widget.conversationId,
          otherUserId: widget.otherUserId,
          showImages: showImages,
          onImagesToggle: _toggleImages,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: t.spacing(c.spaceXSmall),
              horizontal: t.spacing(c.spaceXSmall),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  context.core.baseRadius * t.radiusScale,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: showImages
                          ? ImageContainer(
                              key: const ValueKey('images'),
                              conversationId: widget.conversationId,
                            )
                          : Column(
                              key: const ValueKey('messages'),
                              children: [
                                Expanded(
                                  child: MessageContainer(
                                    key: ValueKey(widget.conversationId),
                                    conversationId: widget.conversationId,
                                    otherUserId: widget.otherUserId,
                                  ),
                                ),
                                /*
                                Expanded(
                                  child: MessageList(
                                    key: ValueKey(widget.conversationId),
                                    conversationId: widget.conversationId,
                                    otherUserId: widget.otherUserId,
                                  ),
                                ),
                                */
                                TypingIndicator(
                                  conversationId: widget.conversationId,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        ChatComposer(conversationId: widget.conversationId),
      ],
    );
  }
}
