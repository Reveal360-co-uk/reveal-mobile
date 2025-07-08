import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:reveal/configs/layout.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final String mascotUrl = 'assets/reveal360-01.glb';
  late Flutter3DController _mascotController;

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(children: [mascotCharacter()]);
  }

  Widget mascotCharacter() {
    return ModelViewer(
      src: mascotUrl,
      autoPlay: true,
      autoRotate: true,
      autoRotateDelay: 300,
    );
    return Positioned(
      // left: 100,
      // top: 100,
      // width: 500,
      // height: 500,
      //child: Flutter3DViewer(src: mascotUrl, controller: mascotController()),
      child: Text("Sample", style: TextStyle(color: Colors.white)),
      //O3D.asset(src: mascotUrl, autoPlay: true),
    );
  }

  Flutter3DController mascotController() {
    _mascotController = Flutter3DController();

    try {
      print('Mascot model loaded: $_mascotController.onModelLoaded.value');
      _mascotController.onModelLoaded.addListener(() {
        _mascotController.getAvailableTextures().then((textures) {
          if (textures.isNotEmpty) {
            final textureName = textures.first;
            print('Available texture: $textureName');
            _mascotController.setTexture(textureName: textureName);
          } else {
            print('No textures available.');
          }
        });

        _mascotController.getAvailableAnimations().then((animations) {
          if (animations.isNotEmpty) {
            final animationName = animations.first;
            print('Available animation: $animationName');
            _mascotController.playAnimation(
              animationName: animationName,
              loopCount: 0,
            );
          } else {
            //print('No animations available.');
          }
        });

        _mascotController.playAnimation(
          animationName: "Animation",
          loopCount: 0,
        );
      });
    } catch (e) {
      print(e);
    }

    return _mascotController;
  }
}
