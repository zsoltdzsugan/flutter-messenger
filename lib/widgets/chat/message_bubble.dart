import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/chat_action_overlay_controller.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/enums/picker_mode.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/core/models/message_image.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/view/home/chat/context_menu.dart';
import 'package:messenger/view/home/chat/hover_context_menu.dart';
import 'package:messenger/view/home/chat/image_viewer.dart';
import 'package:messenger/widgets/gif/bubble.dart';
import 'package:messenger/widgets/picker/picker.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;
  final String otherUserId;
  final Future<void> Function()? onOpenMenu;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.otherUserId,
    required this.onOpenMenu,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final LayerLink _layerLink = LayerLink();
  bool _hovered = false;

  void _deleteMessage(Message message) {
    ConversationController.instance.deleteMessage(message);
  }

  void _saveImage(Message message) {
    ConversationController.instance.saveImage(message);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Image saved')));
  }

  void _copyMessage(Message message) {
    ConversationController.instance.copyMessage(message);
  }

  bool get _hasBubbleBackground {
    if (widget.message.deleted) return true;
    switch (widget.message.type) {
      case MessageType.sticker:
        return false;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final device = t.device;
    final isDesktop = device == DeviceType.desktop;

    final isDeleted = widget.message.deleted;
    final canDelete = widget.isMe && !isDeleted;
    final canCopy = widget.message.type == MessageType.text && !isDeleted;
    final canSave = widget.message.type == MessageType.image && !isDeleted;
    final canForward = !isDeleted;

    final maxWidth = MediaQuery.of(context).size.width * 0.55;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(widget.isMe ? 16 : 4),
      bottomRight: Radius.circular(widget.isMe ? 4 : 16),
    );
    final incomingBubbleBgColor = context.resolveStateColor(
      ChatBubbleColors.incomingBg,
    );
    final incomingBubbleTextColor = context.resolveStateColor(
      ChatBubbleColors.incomingText,
    );
    final outgoingBubbleBgColor = context.resolveStateColor(
      ChatBubbleColors.outgoingBg,
    );
    final outgoingBubbleTextColor = context.resolveStateColor(
      ChatBubbleColors.outgoingText,
    );
    final bubbleBgColor = widget.isMe
        ? outgoingBubbleBgColor
        : incomingBubbleBgColor;

    final bubbleTextColor = widget.isMe
        ? outgoingBubbleTextColor
        : incomingBubbleTextColor;

    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: widget.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isMe) const CircleAvatar(radius: 14),

          if (!widget.isMe) const SizedBox(width: 6),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  onEnter: (_) {
                    if (isDesktop) setState(() => _hovered = true);
                  },
                  onExit: (_) {
                    if (isDesktop) setState(() => _hovered = false);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: ContextMenu(
                          onOpen: () async {
                            final link = _layerLink;
                            final isMe = widget.isMe;

                            final onCopy = canCopy
                                ? () => _copyMessage(widget.message)
                                : null;
                            final onDelete = canDelete
                                ? () => _deleteMessage(widget.message)
                                : null;
                            final onSave = canSave
                                ? () => _saveImage(widget.message)
                                : null;
                            final onForward = canForward
                                ? () {
                                    showPicker(
                                      context: context,
                                      mode: PickerMode.forward,
                                      onSelected: (user) {
                                        ConversationController.instance
                                            .forwardMessage(
                                              widget.message,
                                              user,
                                            );
                                      },
                                    );
                                  }
                                : null;

                            await widget.onOpenMenu?.call();

                            if (!mounted) return;

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;

                              ChatActionOverlayController.showFor(
                                context: context,
                                link: link,
                                isMe: isMe,
                                onCopy: onCopy,
                                onDelete: onDelete,
                                onSave: onSave,
                                onForward: onForward,
                              );
                            });
                          },
                          child: Container(
                            decoration: _hasBubbleBackground
                                ? BoxDecoration(
                                    color: bubbleBgColor,
                                    borderRadius: radius,
                                  )
                                : null,
                            padding: _hasBubbleBackground
                                ? _bubblePadding()
                                : EdgeInsets.zero,
                            child: _buildContent(context),
                          ),
                        ),
                      ),

                      // Desktop hover actions
                      if (isDesktop)
                        Positioned(
                          top: 8,
                          right: widget.isMe ? -48 : null,
                          left: widget.isMe ? null : -48,
                          child: IgnorePointer(
                            ignoring: !_hovered,
                            child: AnimatedOpacity(
                              opacity: _hovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeOut,
                              child: HoverActions(
                                onCopy: canCopy
                                    ? () => _copyMessage(widget.message)
                                    : null,
                                onDelete: canDelete
                                    ? () => _deleteMessage(widget.message)
                                    : null,
                                onSave: canSave
                                    ? () => _saveImage(widget.message)
                                    : null,
                                onForward: canForward
                                    ? () {
                                        showPicker(
                                          context: context,
                                          mode: PickerMode.forward,
                                          onSelected: (user) {
                                            ConversationController.instance
                                                .forwardMessage(
                                                  widget.message,
                                                  user,
                                                );
                                          },
                                        );
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                _buildMeta(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _bubblePadding() {
    if (widget.message.deleted) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }

    switch (widget.message.type) {
      case MessageType.image:
      case MessageType.gif:
        return const EdgeInsets.all(4);
      case MessageType.sticker:
        return const EdgeInsets.symmetric(vertical: 6, horizontal: 4);
      default:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }

  Widget _imageGroupBubble(BuildContext context) {
    final images = widget.message.images;

    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    // Single image
    if (images.length == 1) {
      return _singleImage(context, images.first, 0);
    }

    // Multiple images → grid
    return SizedBox(
      width: 320,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: images.length,
        itemBuilder: (_, index) {
          return _singleImage(context, images[index], index);
        },
      ),
    );
  }

  Widget _singleImage(BuildContext context, MessageImage img, int index) {
    final images = widget.message.images
        .map(
          (e) => ChatImage(
            url: e.url,
            width: e.width,
            height: e.height,
            messageId: widget.message.id,
          ),
        )
        .toList();

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
      child: Hero(
        tag: images[index].heroTag,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: img.url,
              imageBuilder: (_, provider) {
                return Image(image: provider, fit: BoxFit.contain);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final incomingBubbleTextColor = context.resolveStateColor(
      ChatBubbleColors.incomingText,
    );
    final outgoingBubbleTextColor = context.resolveStateColor(
      ChatBubbleColors.outgoingText,
    );

    final bubbleTextColor = widget.isMe
        ? outgoingBubbleTextColor
        : incomingBubbleTextColor;

    if (widget.message.deleted) {
      return Text(
        'Üzenet törölve',
        style: TextStyle(
          color: bubbleTextColor.withAlpha(150),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    switch (widget.message.type) {
      case MessageType.text:
        return Text(
          widget.message.text,
          style: TextStyle(color: bubbleTextColor),
        );

      case MessageType.image:
        return _imageGroupBubble(context);

      case MessageType.gif:
        return SizedBox(
          width: 220,
          child: GifBubble(
            gif: Gif(
              previewUrl: widget.message.previewUrl,
              url: widget.message.mediaUrl,
              width: widget.message.width ?? 220,
              height: widget.message.height ?? 220,
              provider: GifProvider.tenor,
            ),
            borderRadius: BorderRadius.circular(12),
            limitLoops: false,
            autoplay: true,
          ),
        );

      case MessageType.sticker:
        return SizedBox(
          width: widget.message.width ?? 128,
          height: widget.message.height ?? 128,
          child: CachedNetworkImage(
            imageUrl: widget.message.mediaUrl,
            fit: BoxFit.contain,
          ),
        );

      default:
        return const Text(
          'Unsupported message',
          style: TextStyle(color: Colors.white70),
        );
    }
  }

  Widget _buildMeta(BuildContext context) {
    final isSeenByOther =
        widget.isMe &&
        widget.message.readBy.length > 1 &&
        widget.message.readBy.contains(widget.otherUserId);

    final seenColor = context.resolveStateColor(
      ChatBubbleColors.seen,
      isSelected: isSeenByOther,
    );
    final timestampColor = context.resolveStateColor(
      ChatBubbleColors.timestamp,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(widget.message.timestamp),
          style: TextStyle(fontSize: 10, color: timestampColor),
        ),
        if (widget.isMe && isSeenByOther) ...[
          const SizedBox(width: 4),
          Icon(Icons.done_all, size: 14, color: seenColor),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
