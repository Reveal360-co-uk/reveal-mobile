import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reveal/components/model_tile.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/types.dart';
import 'package:reveal/preview.dart';
import 'package:reveal/services/file_service.dart';

class BuildInModels extends StatefulWidget {
  final List<BuiltInModelFile> models = AppConstants.BUILT_IN_MODELS;
  BuildInModels({super.key});

  @override
  State<BuildInModels> createState() => _BuildInModelsState();
}

class _BuildInModelsState extends State<BuildInModels> {
  final FlutterTts flutterTts = FlutterTts();

  void _initSpeech() async {
    if (Platform.isIOS) {
      await flutterTts.setVoice({
        "identifier": "com.apple.voice.compact.en-AU.Karen",
      });
    }

    flutterTts.speak('Hello, and welcome to Reveal three sixty');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // await flutterTts.setVoice({"name": "Karen", "locale": "en-US"});
    // flutterTts.speak('Hello, and welcome to Reveal three sixty');

    setState(() {
      fetchFiles();
    });
  }

  Future<void> fetchFiles() async {
    print(widget.models.length);
    final List<String> files = await FileService().getFiles();
    for (String file in files) {
      widget.models.add(
        BuiltInModelFile(
          path: file,
          name: FileService().getFileName(file),
          isDae: file.endsWith("dae"),
          isAsset: false,
        ),
      );
      print(widget.models.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    void pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files[0];

        String uploadToPath = await FileService().getUploadsDirectory(
          file.name,
        );
        file.xFile.saveTo(uploadToPath);

        setState(() {
          fetchFiles();
        });
      } else {
        print("No file selected");
      }
    }

    return AppLayout(
      isShowingFAB: false,
      onFABPressed: () {
        pickFile();
      },
      child: ListView.separated(
        itemCount: widget.models.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return ModelTile(
            index: index,
            modelName: widget.models[index].name,
            onClick: (index) {
              // Handle model selection
              print("Selected model: ${widget.models[index].name}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewModel(selectedModelIndex: index),
                ),
              );
              // You can add your logic here to handle the model selection
            },
          );
        },
      ),
    );
  }
}
