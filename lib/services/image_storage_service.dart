import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  Future<String> saveImage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'images'));
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
    }
    final fileName = p.basename(sourcePath);
    final newPath = p.join(imagesDir.path, fileName);
    await File(sourcePath).copy(newPath);
    return newPath;
  }

  Future<List<String>> loadSavedImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'images'));
    if (!imagesDir.existsSync()) return [];
    return imagesDir.listSync().whereType<File>().map((f) => f.path).toList();
  }

  Future<void> deleteImage(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
