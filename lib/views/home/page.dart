import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_animation/widget/path_animation.dart';
import 'package:reveal/components/three_d_character.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/services/naviagtion_service.dart';
import 'package:reveal/views/demo/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final String mascotUrl = 'assets/characters/mascot-01.glb';
  late Flutter3DController _mascotController;
  late final Path mascotAnimationPath;

  final TextStyle colorizeTextStyle = GoogleFonts.sourceSans3(
    fontWeight: FontWeight.w800,
    fontSize: 160,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.5),
        offset: const Offset(2, 2),
        blurRadius: 10,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _initMascotAnimationPath();
    // Future.delayed(Duration(seconds: 10), () {
    //   NavigationService().push(
    //     MaterialPageRoute(builder: (context) => const DemoPage()),
    //   );
    // });
  }

  void _initMascotAnimationPath() {
    //mascotAnimationPath = Path()..addOval(const Rect.fromLTWH(0, 0, 100, 100));
    mascotAnimationPath = Path()..conicTo(600, 100, 600, 600, 1.2);
  }

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(
      isShowDarkBackground: true,
      children: [
            animatedLogoBackground(),
            animatedRevealLogo(),
            mascotCharacter(),
          ]
          .animate(
            onComplete: (controller) {
              NavigationService().push(
                MaterialPageRoute(builder: (context) => const DemoPage()),
              );
            },
          )
          .fadeOut(delay: Duration(seconds: 12)),
    );
  }

  Widget animatedRevealLogo() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'REVEAL',
                    textStyle: colorizeTextStyle,
                    colors: AppConstants.TEXT_COLORS,
                    speed: const Duration(milliseconds: 1200),
                  ),
                ],
                isRepeatingAnimation: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Text(
                  "360",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ]
            .animate()
            .fadeIn(duration: const Duration(seconds: 4))
            .scale(duration: const Duration(seconds: 4), begin: Offset(20, 20)),
      ),
    );
  }

  Widget animatedLogoBackground() {
    return Center(
      child: mascot(position: Point(350, 50), size: Point(700, 700))
          .animate()
          .fadeIn(duration: const Duration(seconds: 4))
          .scale(duration: const Duration(seconds: 4), begin: Offset(0.5, 0.5)),
    );
  }

  Widget animatedMascot() {
    return PathAnimation(
      path: mascotAnimationPath,
      duration: const Duration(seconds: 2),
      repeat: true,
      curve: Curves.easeIn,
      //reverse: true,
      //drawPath: true,
      pathColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: mascot(position: Point(0, 0), size: Point(50, 50)),
      ),
    );
  }

  Widget mascot({
    Point<double> position = const Point(10, 10),
    Point<double> size = const Point(30, 30),
  }) {
    return Positioned(
      left: position.x,
      top: position.y,

      child: Container(
        width: size.x,
        height: size.y,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.cyan, Colors.purple, Colors.black],
          ),
        ),
        //child: Flutter3DViewer(src: mascotUrl, controller: mascotController()),
      ),
    );
  }

  Widget mascotCharacter() {
    return Positioned(
      left: 100,
      top: 100,
      width: 100,
      height: 100,
      child: ThreeDCharacter(
        url: AppConstants.MASCOT,
      ).animate().scale(duration: const Duration(seconds: 7)),
    );

    // return Positioned(
    //   left: 100,
    //   top: 100,
    //   width: 100,
    //   height: 100,
    //   child: Flutter3DViewer(
    //     src: AppConstants.MASCOT,
    //     controller: mascotController(),
    //   ).animate().scale(duration: const Duration(seconds: 7)),
    // );
  }

  Flutter3DController mascotController() {
    _mascotController = Flutter3DController();

    try {
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

        //_aiService = AiService();
      });
    } catch (e) {
      print(e);
    }

    return _mascotController;
  }
}
