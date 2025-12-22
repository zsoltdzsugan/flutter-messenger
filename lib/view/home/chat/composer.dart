import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/icon_state.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/enums/picker_mode.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/core/services/image_picker.dart';
import 'package:messenger/core/utils/icon_data.dart';
import 'package:messenger/widgets/input/app_text_field.dart';
import 'package:messenger/widgets/picker/picker.dart';

class ChatComposer extends StatefulWidget {
  final String conversationId;

  const ChatComposer({super.key, required this.conversationId});

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingDebounce;
  bool _isTyping = false;

  void _onChanged(String value) {
    if (!_isTyping) {
      _isTyping = true;
      ConversationController.instance.setTyping(widget.conversationId, true);
    }

    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(seconds: 2), () {
      _isTyping = false;
      ConversationController.instance.setTyping(widget.conversationId, false);
    });
  }

  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    _typingDebounce?.cancel();
    _isTyping = false;

    await ConversationController.instance.send(
      widget.conversationId,
      type: MessageType.text,
      text: text,
    );

    ConversationController.instance.setTyping(widget.conversationId, false);

    if (mounted) {
      _focusNode.requestFocus();
    }
  }

  Future<void> _sendGif(Gif gif) async {
    if (gif.url.isEmpty) return;

    await ConversationController.instance.send(
      widget.conversationId,
      type: MessageType.gif,
      gif: gif,
    );
  }

  Future<void> _sendImages() async {
    try {
      final files = await ImageService.pickMultipleImages();
      if (files.isEmpty) return;

      await ConversationController.instance.send(
        widget.conversationId,
        type: MessageType.image,
        files: files,
      );
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem sikerült a kép kiválasztás')),
      );
    }
  }

  Future<void> _sendEmoji(Gif sticker) async {
    if (sticker.url.isEmpty) return;

    await ConversationController.instance.send(
      widget.conversationId,
      type: MessageType.sticker,
      gif: sticker,
    );
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    IconState iconState = IconState.idle;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: t.spacing(c.spaceSmall),
        left: t.spacing(c.spaceXSmall),
        right: t.spacing(c.spaceXSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              hint: 'Üzenet küldése...',
              idleIcon: Icons.send,
              onChanged: _onChanged,
              onPressed: _sendText,
              onSubmitted: (_) => _sendText(),
              state: iconState,
              prefixIcons: [
                AppIconData(
                  icon: Icons.add_box_outlined,
                  iconSize: 28,
                  onTap: () => _sendImages(),
                ),
                AppIconData(
                  icon: Icons.gif_box_rounded,
                  iconSize: 28,
                  onTap: () {
                    showPicker(
                      context: context,
                      mode: PickerMode.gif,
                      onSelected: (gif) {
                        ConversationController.instance.send(
                          widget.conversationId,
                          type: MessageType.gif,
                          gif: gif,
                        );
                      },
                    );
                  },
                ),
                AppIconData(
                  icon: Icons.emoji_emotions_rounded,
                  iconSize: 28,
                  onTap: () {
                    showPicker(
                      context: context,
                      mode: PickerMode.sticker,
                      onSelected: (sticker) {
                        ConversationController.instance.send(
                          widget.conversationId,
                          type: MessageType.sticker,
                          gif: sticker,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
