import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reveal/services/file_service.dart';

class BuiltInModelFile {
  final String name;
  final String path;
  final bool isDae;
  final bool isAsset;
  final List<String>? description;

  BuiltInModelFile({
    required this.name,
    required this.path,
    this.isDae = false,
    this.isAsset = true,
    this.description,
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

class BottomMenuItem {
  final String title;
  final IconData icon;

  BottomMenuItem({required this.title, required this.icon});
}

enum OperationType { none, pinch, rotation, pan, tap }
