import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Uint8List compressImageBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Invalid image');

  // Downscale (max width 1920px)
  final resized = decoded.width > 1920
      ? img.copyResize(decoded, width: 1920)
      : decoded;

  // JPEG encode
  return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
}

Future<Uint8List> compressImage(File file) async {
  final bytes = await file.readAsBytes();
  return compute(compressImageBytes, bytes);
}
