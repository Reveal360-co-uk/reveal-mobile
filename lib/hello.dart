import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LoadGltfOrGlbFilePage extends StatefulWidget {
  @override
  State<LoadGltfOrGlbFilePage> createState() => _LoadGltfOrGlbFilePageState();
}

class _LoadGltfOrGlbFilePageState extends State<LoadGltfOrGlbFilePage> {
  late ARKitController arkitController;
  String? lastAddedNodeName; // Track the last added model

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reveal360')),
    body: ARKitSceneView(
      showFeaturePoints: true,
      enableTapRecognizer: true,
      planeDetection: ARPlaneDetection.horizontalAndVertical,
      onARKitViewCreated: onARKitViewCreated,
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.play_arrow),
      onPressed: _playAnimation, // Added animation trigger button
    ),
  );

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
    lastAddedNodeName = node.name; // Store the node name for animation control
  }

  ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) =>
      ARKitGltfNode(
        assetType: AssetType.documents,
        //assetType: AssetType.flutterAsset,
        //url: 'assets/fox.glb',
        url: Uri.file('assets/fox.glb').toFilePath(),
        scale: vector.Vector3(0.01, 0.01, 0.01),
        name: 'fox_node', // Consistent naming for animation control
        position: position,
      );

  // New method to play animation
  void _playAnimation() {
    this.arkitController.playAnimation(
      key: "animation",
      sceneName: "fox_node",
      animationIdentifier: "Take 001",
    );
  }
}
