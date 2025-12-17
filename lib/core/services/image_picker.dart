import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final _picker = ImagePicker();

  static Future<List<File>> pickMultipleImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 85);

    if (images == null || images.isEmpty) return [];

    return images.map((x) => File(x.path)).toList();
  }
}
