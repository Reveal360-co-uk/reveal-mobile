import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<List<String>> getFiles() async {
    //Directory systemTempDir = Directory.fromUri(Uri.directory(modelsDirectory));
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    List<String> files = [];

    await for (var entity in documentsDirectory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        if (entity.path.endsWith('.dae') ||
            entity.path.endsWith('.gltf') ||
            entity.path.endsWith('.glb')) {
          files.add(entity.path);
        }
      }
      print(entity.path);
    }

    return files;
  }

  String getFileName(String filePath) {
    return path.basename(filePath);
  }

  Future<String> getUploadsDirectory(String filename) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return Future.value(path.join(documentsDirectory.path, filename));
  }

  Future<String> uploadFile(File file) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String fileName = path.basename(file.path);
    String newPath = path.join(documentsDirectory.path, fileName);

    File newFile = await file.copy(newPath);
    return newFile.path;
  }
}
