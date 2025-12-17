import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/message_image.dart';

class Message {
  final String id;
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

  final DocumentSnapshot firestoreDoc;

  final bool isLocal;
  final double uploadProgress;
  final String? localPath;

  Message({
    required this.id,
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
    required this.firestoreDoc,

    this.isLocal = false,
    this.uploadProgress = 1.0,
    this.localPath,
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

    return Message(
      id: doc.id,
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
      firestoreDoc: doc,

      isLocal: false,
      uploadProgress: 1.0,
      localPath: null,
    );
  }

  factory Message.localImage({
    required String id,
    required String sender,
    required String localPath,
  }) {
    return Message(
      id: id,
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
      firestoreDoc: _FakeDocumentSnapshot(),

      isLocal: true,
      uploadProgress: 0.0,
      localPath: localPath,
    );
  }
}

class _FakeDocumentSnapshot implements DocumentSnapshot {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
