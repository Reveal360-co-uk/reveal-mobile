import 'dart:async';
import 'package:flutter/foundation.dart';
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

class Late<T> {
  final ValueNotifier<bool> _initialization = ValueNotifier(false);
  late T _val;

  Late([T? value]) {
    if (value != null) {
      this.val = value;
    }
  }

  get isInitialized {
    return _initialization.value;
  }

  T get val => _val;

  set val(T val) =>
      this
        .._initialization.value = true
        .._val = val;
}

extension LateExtension<T> on T {
  Late<T> get late => Late<T>();
}

extension ExtLate on Late {
  Future<bool> get wait {
    Completer<bool> completer = Completer();
    this._initialization.addListener(() async {
      completer.complete(this._initialization.value);
    });

    return completer.future;
  }
}

enum OperationType { none, pinch, rotation, pan, tap }
