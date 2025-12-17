import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/icon_state.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/chat_image.dart';
import 'package:messenger/core/utils/icon_data.dart';
import 'package:messenger/view/home/image/container.dart';
import 'package:messenger/widgets/chat/message_list.dart';
import 'package:messenger/widgets/chat/typing_indicator.dart';
import 'package:messenger/widgets/input/app_text_field.dart';

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
  Widget build(BuildContext context) {
    final inputController = TextEditingController();
    IconState state = IconState.idle;

    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(MainBgColors.chat);
    final textColor = context.resolveStateColor(MainBgColors.text);

    return StreamBuilder<List<Message>>(
      stream: ConversationController.instance.streamMessages(
        widget.conversationId,
      ),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? const [];

        final images = messages
            .where((m) => m.type == MessageType.image)
            .map(
              (m) => ChatImage(
                url: m.mediaUrl,
                width: m.width ?? 1,
                height: m.height ?? 1,
              ),
            )
            .toList();
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: t.spacing(c.spaceSmall),
                horizontal: t.spacing(c.spaceXSmall),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User block
                  Row(
                    children: [
                      CircleAvatar(
                        radius: t.spacing(16),
                        backgroundColor: Colors.white,
                        child: Text('U'),
                      ),
                      SizedBox(width: t.spacing(c.spaceSmall)),

                      Text(
                        'Ismeretlen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: t.font(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Images button
                      IconButton(
                        icon: Icon(showImages ? Icons.close : Icons.image),
                        onPressed: () {
                          setState(() {
                            showImages = !showImages;
                          });
                        },
                      ),
                      SizedBox(width: t.spacing(c.spaceSmall)),
                      // Chat Settings button
                      PopupMenuButton<String>(
                        tooltip: '',
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case "refresh":
                              //refreshConversation();
                              break;
                            case "delete":
                              //deleteConversation();
                              break;
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: "refresh",
                            child: Row(
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(width: 8),
                                Text("Refresh"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: const [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Text("Delete Conversation"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
                  child: showImages
                      ? ImageContainer(images: images)
                      : Column(
                          children: [
                            Expanded(
                              child: MessageList(
                                messages: messages,
                                otherUserId: widget.otherUserId,
                              ),
                            ),
                            TypingIndicator(
                              conversationId: widget.conversationId,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: t.spacing(c.spaceSmall),
                left: t.spacing(c.spaceXSmall),
                right: t.spacing(c.spaceXSmall),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: inputController,
                      keyboardType: TextInputType.text,
                      hint: 'Üzenet küldése...',
                      state: state,
                      idleIcon: Icons.send,
                      onPressed: () {
                        final text = inputController.text.trim();
                        if (text.isEmpty) return;

                        ConversationController.instance.send(
                          widget.conversationId,
                          type: MessageType.text,
                          text: text,
                        );
                        inputController.clear();
                      },
                      prefixIcons: [
                        AppIconData(
                          icon: Icons.add_box_outlined,
                          onTap: () => print("add tapped"),
                        ),
                        AppIconData(
                          icon: Icons.gif_box_rounded,
                          onTap: () => print("gif tapped"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
