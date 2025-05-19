import 'package:flutter/material.dart';
import 'package:reveal/components/model_tile.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/types.dart';
import 'package:reveal/preview.dart';

class BuildInModels extends StatefulWidget {
  final List<BuiltInModelFile> models = AppConstants.BUILT_IN_MODELS;
  BuildInModels({super.key});

  @override
  State<BuildInModels> createState() => _BuildInModelsState();
}

class _BuildInModelsState extends State<BuildInModels> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
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
