// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reveal/views/archive/built_in_models.dart';
import 'package:reveal/views/archive/test_stt.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AppLayout extends StatefulWidget {
  final Widget child;
  final bool isShowingFAB;
  final IconData iconFAB;
  final Function? onFABPressed;
  final Function? onMicPressed;
  const AppLayout({
    super.key,
    required this.child,
    this.onFABPressed,
    this.onMicPressed,
    this.isShowingFAB = false,
    this.iconFAB = Icons.add,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reveal360'),
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    // Handle menu action
                    Navigator.pop(context);
                  },
                )
                : null,
        elevation: 1,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: () {
              // Handle settings action
              print('Mic clicked');
              if (widget.onMicPressed != null) {
                widget.onMicPressed!();
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => STTTestPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(10), child: widget.child),
      ),
      floatingActionButton:
          widget.isShowingFAB
              ? FloatingActionButton(
                onPressed: () {
                  // Handle FAB action
                  if (widget.onFABPressed != null) {
                    widget.onFABPressed!();
                  }
                },
                child: Icon(widget.iconFAB),
              )
              : null,
    );
  }
}

class ARAppLayout extends StatefulWidget {
  final List<Widget> children;
  final bool isShowingFAB;
  final IconData iconFAB;
  final Function? onFABPressed;
  final Function? onMicPressed;
  final bool isShowDarkBackground;
  //final Function? onImageDetected;
  //final Function? onImageRemoved;

  const ARAppLayout({
    super.key,
    required this.children,
    this.onFABPressed,
    this.onMicPressed,
    //this.onImageDetected,
    //this.onImageRemoved,
    this.isShowingFAB = false,
    this.iconFAB = Icons.add,
    this.isShowDarkBackground = false,
  });

  @override
  State<ARAppLayout> createState() => _ARAppLayoutState();
}

class _ARAppLayoutState extends State<ARAppLayout> {
  late ARKitController arkitController;
  List<ARKitReferenceImage> detectionImages = [];
  bool anchorWasFound = false;
  Timer? timer;
  String message = "";

  @override
  void initState() {
    super.initState();

    // Hides the bottom navigation bar and the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // ARKitReferenceImage newImage = ARKitReferenceImage(
    //   name: "",
    //   physicalWidth: 1.0,
    // );
    // detectionImages.add(newImage);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, // Left-side Landscape
      DeviceOrientation.landscapeRight, // Right-side Landscape
    ]);
  }

  @override
  void dispose() {
    arkitController.onAddNodeForAnchor = null;
    arkitController.onUpdateNodeForAnchor = null;
    arkitController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Widget arKitScene() {
    return ARKitSceneView(
      //planeDetection: ARPlaneDetection.horizontalAndVertical,
      configuration: ARKitConfiguration.worldTracking,
      detectionImages: const [
        ARKitReferenceImage(
          name: 'assets/images/QR-Code.png',
          physicalWidth: 0.2, // Physical size in meters (20cm width)
          // name:
          //     'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/OSIRIS_Mars_true_color.jpg/800px-OSIRIS_Mars_true_color.jpg',
          // physicalWidth: 0.2,
        ),
      ],
      trackingImages: const [
        ARKitReferenceImage(
          name: 'assets/images/QR-Code.png',
          physicalWidth: 0.2, // Physical size in meters (20cm width)
          // name:
          //     'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/OSIRIS_Mars_true_color.jpg/800px-OSIRIS_Mars_true_color.jpg',
          // physicalWidth: 0.2,
        ),
      ],
      onARKitViewCreated: (ARKitController arKitController) {
        arkitController = arKitController;

        arkitController.onAddNodeForAnchor = (ARKitAnchor anchor) {
          //widget.onImageDetected!();
          print("Anchor added: ${anchor.identifier}");
          if (anchor is ARKitImageAnchor) {
            setState(() {
              anchorWasFound = true;
            });

            final material = ARKitMaterial(
              lightingModelName: ARKitLightingModel.lambert,
              diffuse: ARKitMaterialProperty.image(
                'assets/images/mars-texture.jpg',
              ),
            );
            final sphere = ARKitSphere(materials: [material], radius: 0.1);

            final earthPosition = anchor.transform.getColumn(3);
            final node = ARKitNode(
              geometry: sphere,
              position: vector.Vector3(
                earthPosition.x,
                earthPosition.y,
                earthPosition.z,
              ),
              eulerAngles: vector.Vector3.zero(),
            );
            arkitController.add(node);

            timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
              final old = node.eulerAngles;
              final eulerAngles = vector.Vector3(old.x + 0.01, old.y, old.z);
              node.eulerAngles = eulerAngles;

              var newAnchorPosition = anchor.transform.getColumn(3);

              setState(() {
                message =
                    "AX: ${newAnchorPosition.x} AY: ${newAnchorPosition.y} AZ: ${newAnchorPosition.z} \n X: ${eulerAngles.x} Y: ${eulerAngles.y} Z: ${eulerAngles.z}";
              });
            });
          }
        };

        arkitController.onSessionWasInterrupted = () {
          print("session interrupted");
        };

        arkitController.onUpdateNodeForAnchor = (ARKitAnchor anchor) {
          print("Anchor updated: ${anchor.identifier}");
          if (anchor is ARKitImageAnchor) {
            setState(() {
              anchorWasFound = true;
            });
          }
        };

        arkitController.onDidRemoveNodeForAnchor = (ARKitAnchor anchor) {
          //widget.onImageRemoved!();
          print("Anchor removed: ${anchor.identifier}");
          if (anchor is ARKitImageAnchor) {
            setState(() {
              anchorWasFound = false;
            });
          }
        };

        // final position1 = vector.Vector3(0, -0.14, -0.20);

        // print(position1);

        // final node = ARKitGltfNode(
        //   url: url,
        //   assetType: AssetType.flutterAsset,
        //   scale: vector.Vector3(0.1, 0.1, 0.1),
        //   position: position1,
        // );
        // // final node = _getNodeFromNetwork(position);
        // //arkitController.add(node);

        // arkitController.onARTap = (ar) {
        //   final point = ar.firstWhereOrNull(
        //     (o) => o.type == ARKitHitTestResultType.featurePoint,
        //   );
        //   if (point != null) {
        //     final position = vector.Vector3(
        //       point.worldTransform.getColumn(3).x,
        //       point.worldTransform.getColumn(3).y,
        //       point.worldTransform.getColumn(3).z,
        //     );

        //     final position1 = vector.Vector3(0.02, -0.04, -0.08);

        //     print(position);

        //     final node = ARKitGltfNode(
        //       url: url,
        //       assetType: AssetType.flutterAsset,
        //       scale: vector.Vector3(0.1, 0.1, 0.1),
        //       position: position1,
        //     );
        //     // final node = _getNodeFromNetwork(position);
        //     arkitController.add(node);
        //   }
        // };

        // arKitController.onARTap = (ar) {
        //   final ARKitTestResult? point = ar.firstWhere(
        //     (o) => o.type == ARKitHitTestResultType.featurePoint,
        //   );
        //   if (point != null) {
        //     final position = vector.Vector3(
        //       point.worldTransform.getColumn(3).x,
        //       point.worldTransform.getColumn(3).y,
        //       point.worldTransform.getColumn(3).z,
        //     );

        //     final node = ARKitGltfNode(
        //       url: url,
        //       assetType: AssetType.flutterAsset,
        //       scale: vector.Vector3(0.1, 0.1, 0.1),
        //       position: position,
        //     );
        //     // final node = _getNodeFromNetwork(position);
        //     arKitController.add(node);
        //   }
        // };
      },
    );
  }

  Widget body() {
    if (widget.isShowDarkBackground) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: widget.children,
        ),
      );
    }

    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [arKitScene(), ...widget.children],
    );
    //return Stack(alignment: AlignmentDirectional.center, children: children());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: body(),
      floatingActionButton:
          widget.isShowingFAB
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'back',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => BuildInModels()),
                        (route) => false,
                      );
                    },
                    child: Icon(Icons.chevron_left),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: 'mic',
                    onPressed: () {
                      // Handle FAB action
                      if (widget.onFABPressed != null) {
                        widget.onFABPressed!();
                      }
                    },
                    child: Icon(widget.iconFAB),
                  ),
                ],
              )
              : null,
    );
  }
}
