import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDCharacter extends StatefulWidget {
  final String animationName;
  final String url;

  const ThreeDCharacter({
    super.key,
    required this.url,
    this.animationName = "Animation",
  });

  @override
  State<ThreeDCharacter> createState() => _ThreeDCharacterState();
}

class _ThreeDCharacterState extends State<ThreeDCharacter> {
  Flutter3DController mascotController = Flutter3DController();

  void playMascotAnimation() {
    print("***************** Listner added *****************");

    mascotController.getAvailableAnimations().then((animations) {
      for (var animation in animations) {
        print(animation);
      }

      //mascotController.playAnimation(animationName: animations[0]);
      mascotController.playAnimation(animationName: widget.animationName);
    });

    mascotController.getAvailableTextures().then((textures) {
      for (var texture in textures) {
        print(texture);
      }

      mascotController.setTexture(textureName: textures[0]);
    });

    // mascotController.setCameraOrbit(0.2, 0.2, 1.5);

    // Future.delayed(Duration(seconds: 3), () {
    //   mascotController.resetCameraOrbit();
    // });
  }

  Widget mascotThroughFlutter3DController() {
    Flutter3DViewer mascot = Flutter3DViewer(
      src: widget.url,
      controller: mascotController,
    );

    return mascot;

    // if (widget.location != null) {
    //   return Positioned.fromRect(rect: widget.location!, child: mascot);
    // }

    // return SizedBox(width: widget.width, child: mascot);
  }

  @override
  void initState() {
    mascotController.onModelLoaded.addListener(playMascotAnimation);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    mascotController.onModelLoaded.removeListener(playMascotAnimation);
    mascotController.onModelLoaded.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mascotThroughFlutter3DController();
  }
}

class Rotating3DObject extends StatefulWidget {
  final String url;
  const Rotating3DObject({super.key, required this.url});

  @override
  State<Rotating3DObject> createState() => _Rotating3DObjectState();
}

class _Rotating3DObjectState extends State<Rotating3DObject> {
  Widget rotatingObject() {
    var mascot = ModelViewer(
      src: widget.url,
      autoPlay: true,
      interpolationDecay: 200,
      interactionPrompt: InteractionPrompt.none,
      autoRotate: true,
      autoRotateDelay: 1,
      rotationPerSecond: "30deg",
    );

    return mascot;
  }

  @override
  Widget build(BuildContext context) {
    return rotatingObject();
  }
}
