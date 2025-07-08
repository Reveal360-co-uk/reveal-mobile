import 'package:flutter/material.dart';
import 'package:reveal/components/model_tile.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/services/file_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> tmpFiles = [];
  final FileService fileService = FileService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTmpFiles();
  }

  // Make New Function
  void _getTmpFiles() async {
    List<String> files = await fileService.getFiles();

    setState(() {
      tmpFiles.addAll(files);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      isShowingFAB: true,
      child: ListView.separated(
        itemCount: tmpFiles.length,
        itemBuilder: (BuildContext context, int index) {
          return ModelTile(index: index, modelName: tmpFiles[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
