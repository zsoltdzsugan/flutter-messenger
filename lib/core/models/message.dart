import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/message_image.dart';

class Message {
  final String id;
  final String conversationId;
  final String sender;
  final MessageType type;
  final String text;

  final List<MessageImage> images;
  final String mediaUrl;
  final String previewUrl;
  final double? width;
  final double? height;

  final DateTime timestamp;
  final List<String> readBy;

  //final DocumentSnapshot firestoreDoc;
  final bool deleted;

  final bool isLocal;
  final double uploadProgress;
  final String? localPath;

  final GifProvider? provider;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.type,
    required this.text,
    required this.images,
    required this.mediaUrl,
    required this.previewUrl,
    required this.width,
    required this.height,
    required this.timestamp,
    required this.readBy,
    //required this.firestoreDoc,
    required this.deleted,
    this.isLocal = false,
    this.uploadProgress = 1.0,
    this.localPath,
    this.provider,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final media = (data['media'] as Map<String, dynamic>?) ?? {};

    final ts = data['timestamp'];
    final time = ts is Timestamp ? ts.toDate() : DateTime.now();

    final images =
        (data['images'] as List<dynamic>?)
            ?.map((e) => MessageImage.fromMap(e))
            .toList() ??
        const [];

    GifProvider? provider;
    final providerString = media['provider'];
    if (providerString is String) {
      provider = GifProvider.values.firstWhere(
        (p) => p.name == providerString,
        orElse: () => GifProvider.tenor,
      );
    }

    return Message(
      id: doc.id,
      conversationId: doc.reference.parent.parent!.id,
      sender: data['sender'],
      type: MessageType.values.firstWhere((t) => t.name == data['type']),
      text: data['text'] ?? '',
      images: images,
      mediaUrl: media['url'] ?? '',
      previewUrl: media['preview_url'] ?? '',
      width: (media['width'] as num?)?.toDouble(),
      height: (media['height'] as num?)?.toDouble(),
      timestamp: time,
      readBy: List<String>.from(data['read_by'] ?? const []),
      deleted: data['deleted'] ?? false,
      provider: provider,
    );
  }

  factory Message.localImage({
    required String id,
    required String conversationId,
    required String sender,
    required String localPath,
    bool deleted = false,
    GifProvider? provider,
  }) {
    return Message(
      id: id,
      conversationId: conversationId,
      sender: sender,
      type: MessageType.image,
      text: '',
      images: const [],
      mediaUrl: '',
      previewUrl: '',
      width: null,
      height: null,
      timestamp: DateTime.now(),
      readBy: const [],

      //firestoreDoc: _FakeDocumentSnapshot(),
      deleted: deleted,
      isLocal: true,
      uploadProgress: 0.0,
      localPath: localPath,
      provider: provider,
    );
  }
}

class _FakeDocumentSnapshot implements DocumentSnapshot {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
