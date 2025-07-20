import 'dart:async';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reveal/components/three_d_character.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/messages.dart';
import 'package:reveal/services/ai_service.dart';
import 'package:reveal/services/voice_service.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  VoiceService voiceService = VoiceService();
  AiService aiService = AiService();
  int totalQuestions = 0;
  bool isShowVase = false;
  bool isShowPlesiosaurus = false;
  double scrollOffset = 0.0;
  ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  String messageToDisplay = "Reveal 360";
  bool isScrollText = false;

  void setDisplayMessage(String text, {bool scrollText = false}) {
    setState(() {
      messageToDisplay = text;
      scrollOffset = 0.0;

      isScrollText = scrollText;
    });
  }

  Widget scrollingText(String text) {
    if (!isScrollText) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w800),
      );
    }

    List<String> data = text.split(".");

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (scrollOffset >= 300) {
        timer.cancel();
      }

      setState(() {
        scrollOffset = scrollOffset + 1;
      });

      //print(scrollOffset);
      scrollController.animateTo(
        100,
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });

    return FadingEdgeScrollView.fromAnimatedList(
      gradientFractionOnStart: 1.0,
      gradientFractionOnEnd: 1.0,
      child: AnimatedList(
        controller: scrollController,
        initialItemCount: data.length,
        itemBuilder: (_, index, animation) {
          return Text(
            data[index],
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          );
        },
      ),
    );
  }

  void showcaseVase(Function onComplete) {
    setDisplayMessage(AppMessages.vaseMessage1);
    voiceService.speak(
      AppMessages.vaseMessage1,
      onComplete: () {
        setDisplayMessage(AppMessages.vaseMessage2);
        voiceService.speak(
          AppMessages.vaseMessage2,
          onComplete: () {
            setDisplayMessage(AppMessages.vaseMessage3);
            voiceService.speak(
              AppMessages.vaseMessage3,
              onComplete: () {
                setState(() {
                  isShowVase = true;
                });
                setDisplayMessage(AppMessages.vaseMessage4);
                voiceService.speak(
                  AppMessages.vaseMessage4,
                  onComplete: () {
                    setDisplayMessage(AppMessages.vaseMessage5);
                    voiceService.speak(
                      AppMessages.vaseMessage5,
                      onComplete: () {
                        setDisplayMessage(
                          AppMessages.vaseMessage6,
                          scrollText: true,
                        );
                        voiceService.speak(
                          AppMessages.vaseMessage6,
                          onComplete: () {
                            setState(() {
                              isShowVase = false;
                              isShowPlesiosaurus = true;
                            });
                            setDisplayMessage(AppMessages.vaseMessage7);
                            voiceService.speak(
                              AppMessages.vaseMessage7,
                              onComplete: () {
                                setDisplayMessage(
                                  AppMessages.vaseMessage8,
                                  scrollText: true,
                                );
                                voiceService.speak(
                                  AppMessages.vaseMessage8,
                                  onComplete: () {
                                    setState(() {
                                      isShowPlesiosaurus = false;
                                    });
                                    setDisplayMessage(AppMessages.vaseMessage9);
                                    voiceService.speak(
                                      AppMessages.vaseMessage9,
                                      onComplete: () {
                                        onComplete();
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void startListening() async {
    if (totalQuestions == 2) {
      // Showcase vase
      showcaseVase(() {
        totalQuestions++;
        startListening();
      });
    } else {
      print("*********** Listening Started **********");
      //setListening(true);
      voiceService.startListening((String value) async {
        print("*********** Listening Stopped **********");
        //voiceService.stopListening();
        print(value);
        if (value != "") {
          print("Calling AI Service");

          setDisplayMessage(value);

          String aiResponse = await aiService.generateResponse(value);

          setState(() {
            totalQuestions++;
          });

          setDisplayMessage(aiResponse);
          //setListening(false);
          await voiceService.speak(
            aiResponse,
            onComplete: () {
              print("*********** Listening Started **********");
              startListening();
            },
          );
        } else {
          print("*********** Listening Started **********");
          startListening();
        }
        //lastQuestion = value;
      });
      // await voiceService.listen((String value) async {
      //   print("*********** Listening Stopped **********");
      //   voiceService.stopListening();
      //   print(value);
      //   String newQuery = value.replaceAll(lastQuestion, "");
      //   String aiResponse = await aiService.generateResponse(value);
      //   //lastQuestion = value;
      //   await voiceService.speak(
      //     aiResponse,
      //     onComplete: () {
      //       print("*********** Listening Started **********");
      //       voiceService.startListening();
      //     },
      //   );
      // });
    }
  }

  void speakingSequence() async {
    await Future.delayed(Duration(seconds: 3));
    await voiceService.speak(
      AppMessages.welcomeMessage,
      onComplete: () {
        voiceService.speak(
          AppMessages.welcomeMessage2,
          onComplete: () {
            voiceService.speak(AppMessages.welcomeMessage3);
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    speakingSequence();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    voiceService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(
      isShowDarkBackground: false,
      children: [
        Positioned.fromRect(
          rect: Rect.fromLTWH(0, 0, 300, 400),
          child: ThreeDCharacter(
            url: AppConstants.TALKING_WOMEN,
            animationName: "Take 001",
          ),
        ).animate().fadeOut(
          delay: Duration(seconds: 16),
          duration: Duration(seconds: 5),
        ),
        Positioned.fromRect(
              rect: Rect.fromLTWH(0, 0, 500, 500),
              child: ThreeDCharacter(
                url: AppConstants.TALKING_WOMEN,
                animationName: "Take 001",
              ),
            )
            .animate(
              onComplete: (controller) {
                startListening();
              },
            )
            .fadeIn(
              duration: Duration(seconds: 5),
              delay: Duration(seconds: 16),
            ),
        isShowVase == true
            ? Positioned.fromRect(
              rect: Rect.fromLTWH(700, 100, 200, 200),
              child: Rotating3DObject(url: AppConstants.VASE1),
            ).animate().fadeIn(duration: Duration(seconds: 5))
            : SizedBox(),
        isShowPlesiosaurus == true
            ? Positioned.fromRect(
              rect: Rect.fromLTWH(700, 100, 200, 200),
              child: Rotating3DObject(url: AppConstants.PLESIOSAURUS),
            ).animate().fadeIn(duration: Duration(seconds: 5))
            : SizedBox(),
        Positioned.fromRect(
          rect: Rect.fromLTWH(350, 100, 200, 200),
          child: scrollingText(messageToDisplay),
        ),
      ],
    );
  }
}
