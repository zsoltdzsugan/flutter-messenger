import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:messenger/core/utils/image_compression.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<UploadedMedia> uploadImage(File file) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final Uint8List compressed = await compressImage(file);

    final decoded = img.decodeImage(compressed);
    if (decoded == null) throw Exception('Failed to decode image');

    final id = _uuid.v4();
    final ref = _storage.ref().child('images/$uid/$id.jpg');

    await ref.putData(compressed, SettableMetadata(contentType: 'image/jpeg'));

    final url = await ref.getDownloadURL();

    return UploadedMedia(
      url: url,
      width: decoded.width.toDouble(),
      height: decoded.height.toDouble(),
    );
  }
}

class UploadedMedia {
  final String url;
  final double width;
  final double height;

  UploadedMedia({required this.url, required this.width, required this.height});
}
