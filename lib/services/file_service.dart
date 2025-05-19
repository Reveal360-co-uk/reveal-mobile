import 'dart:io';
import 'package:path/path.dart' as path;

class FileService {
  final Directory currentDirectory = Directory.current;
  final String modelsDirectory = path.join(Directory.current.path, 'models');
  FileService() {
    Directory(modelsDirectory).exists().then((exists) {
      if (!exists) {
        Directory(modelsDirectory).createSync(recursive: true);
      }
    });
  }

  Future<List<String>> getFiles() async {
    //Directory systemTempDir = Directory.fromUri(Uri.directory(modelsDirectory));
    Directory systemTempDir = Directory.systemTemp;
    List<String> files = [];

    await for (var entity in systemTempDir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        files.add(path.basename(entity.path));
      }
      print(entity.path);
    }

    return files;
  }
}
