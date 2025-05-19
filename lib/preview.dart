import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/types.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PreviewModel extends StatefulWidget {
  final int selectedModelIndex;
  final List<BuiltInModelFile> models = AppConstants.BUILT_IN_MODELS;
  PreviewModel({super.key, required this.selectedModelIndex});

  @override
  State<PreviewModel> createState() => _PreviewModelState();
}

class _PreviewModelState extends State<PreviewModel> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: ARKitSceneView(
        showFeaturePoints: true,
        enableTapRecognizer: true,
        planeDetection: ARPlaneDetection.horizontalAndVertical,
        onARKitViewCreated: onARKitViewCreated,
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onARTap = (ar) {
      final point = ar.firstWhereOrNull(
        (o) => o.type == ARKitHitTestResultType.featurePoint,
      );
      if (point != null) {
        _onARTapHandler(point);
      }
    };
  }

  void _onARTapHandler(ARKitTestResult point) {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    final node = _getNodeFromFlutterAsset(position);
    arkitController.add(node);
  }

  ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) =>
      ARKitGltfNode(
        assetType: AssetType.flutterAsset,
        //url: 'assets/fox.glb',
        url: widget.models[widget.selectedModelIndex].path,
        scale: vector.Vector3(0.01, 0.01, 0.01),
        name: 'fox_node', // Consistent naming for animation control
        position: position,
      );
}
