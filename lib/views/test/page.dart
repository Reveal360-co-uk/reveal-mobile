import 'dart:async';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:reveal/configs/layout.dart';

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  String url = "assets/mascot-01.glb";
  Flutter3DController mascotController = Flutter3DController();
  List<String> data = List.generate(
    100,
    (index) =>
        "Arbitrarily long text that would fit the width of the screen $index",
  );
  ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  late TickerFuture clock;
  double lastScrollPosition = 0;
  String imageCompareMessage = "";

  void platMascotAnimation() {
    print("***************** Listner added *****************");

    mascotController.getAvailableAnimations().then((animations) {
      for (var animation in animations) {
        print(animation);
      }

      mascotController.playAnimation(animationName: animations[0]);
    });

    mascotController.getAvailableTextures().then((textures) {
      for (var texture in textures) {
        print(texture);
      }
    });

    mascotController.setCameraOrbit(0.2, 0.2, 1.5);

    Future.delayed(Duration(seconds: 3), () {
      mascotController.resetCameraOrbit();
    });
  }

  @override
  void initState() {
    mascotController.onModelLoaded.addListener(platMascotAnimation);

    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   print(timer.tick);

    //   if (lastScrollPosition <= 1300) {
    //     lastScrollPosition += 100;
    //   } else {
    //     timer.cancel();
    //   }

    //   scrollController.animateTo(
    //     lastScrollPosition,
    //     duration: Duration(seconds: 3),
    //     curve: Curves.easeInOut,
    //   );
    // });

    // scrollController.animateTo(
    //   100,
    //   duration: Duration(seconds: 3),
    //   curve: Curves.easeInOut,
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     mascotThroughModelViewer(),
        //     mascotThroughFlutter3DController(),
        //   ],
        // ),
        //SizedBox(height: 300, child: scrollingText()),
      ],
    );
  }

  Widget mascotThroughModelViewer() {
    var mascot = ModelViewer(
      src: url,
      autoPlay: true,
      interpolationDecay: 200,
      interactionPrompt: InteractionPrompt.none,
      autoRotate: true,
      autoRotateDelay: 1,
      rotationPerSecond: "30deg",
    );

    return SizedBox(width: 100, child: mascot);
  }

  Widget mascotThroughFlutter3DController() {
    Flutter3DViewer mascot = Flutter3DViewer(
      src: url,
      controller: mascotController,
    );

    return SizedBox(width: 100, child: mascot);
  }

  Widget scrollingText() {
    return FadingEdgeScrollView.fromAnimatedList(
      gradientFractionOnStart: 1.0,
      gradientFractionOnEnd: 1.0,
      child: AnimatedList(
        controller: scrollController,
        initialItemCount: data.length,
        itemBuilder: (_, index, animation) {
          return Text(data[index]);
        },
      ),
    );
  }
}
