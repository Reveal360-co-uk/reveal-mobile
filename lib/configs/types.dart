import 'package:reveal/services/file_service.dart';

class BuiltInModelFile {
  final String name;
  final String path;
  final bool isDae;
  final bool isAsset;

  BuiltInModelFile({
    required this.name,
    required this.path,
    this.isDae = false,
    this.isAsset = true,
  });

  Future<List<BuiltInModelFile>> createdModelsFromDownloads() async {
    List<String> files = await FileService().getFiles();

    return Future<List<BuiltInModelFile>>.value(
      files.map((file) => BuiltInModelFile(name: file, path: file)).toList(),
    );
  }
}

class Questions {
  final String question;
  final String answer;

  Questions({required this.question, required this.answer});
}
