import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/types.dart';
import 'package:reveal/services/ai_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ThreeDPage extends StatefulWidget {
  final int selectedModelIndex;
  final List<BuiltInModelFile> models = AppConstants.BUILT_IN_MODELS;
  final List<String> animations = [];
  ThreeDPage({super.key, required this.selectedModelIndex});

  @override
  State<ThreeDPage> createState() => _ThreeDPageState();
}

class _ThreeDPageState extends State<ThreeDPage> {
  // ignore: non_constant_identifier_names
  late Flutter3DController _3DController;
  final FlutterTts flutterTts = FlutterTts();
  final List<Questions?> _questions = AppConstants.QUESTIONS;
  final SpeechToText _speechToText = SpeechToText();
  late String _lastWords = '';
  late ARKitController _arKitController;
  late bool _speechEnabled = false;
  late String _message = '';
  late bool _hasSpoken = false;
  late List<String>? _linesToSpeak;
  late AiService _aiService;
  late bool _isSpeaking = false;

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

    _linesToSpeak = widget.models[widget.selectedModelIndex].description;
  }

  @override
  void dispose() {
    _arKitController.dispose();
    super.dispose();
  }

  // *** Speech related methods
  Future<void> speak(String textToSpeak) async {
    setState(() {
      _isSpeaking = true;
      _message = "Speaking ...";
    });
    return await Future.delayed(const Duration(milliseconds: 1000), () {
      // Here you can write your code

      String finalText = textToSpeak.replaceAll(
        "#name",
        widget.models[widget.selectedModelIndex].name,
      );

      flutterTts.speak(finalText).then((_) {
        setState(() {
          _isSpeaking = false;
          _message = "Done Speaking ...";
        });
        return;
      });
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    if (!_speechEnabled) {
      if (Platform.isIOS) {
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
        );
        await flutterTts.setPitch(0.8);
        await flutterTts.setSpeechRate(0.4);

        if (widget.selectedModelIndex == 0) {
          await flutterTts.setVoice({
            "identifier": "com.apple.ttsbundle.Daniel-compact",
          });
        } else {
          await flutterTts.setVoice({
            "identifier": "com.apple.ttsbundle.Lekha-compact",
          });
        }
      }
      _speechEnabled = await _speechToText.initialize();

      setState(() {
        //_speechEnabled = true;
        _linesToSpeak = widget.models[widget.selectedModelIndex].description;
        //speakDescription();
      });
    } else {
      print("Speech already enabled");
      //speakDescription();
    }
  }

  void speakLine(lineToSpeak) async => await speak(lineToSpeak);

  void speakDescription() async {
    if (_linesToSpeak == null) {
      print("No lines to speak");
    } else {
      Future.wait(_linesToSpeak!.map((line) => speak(line)).toList());
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _message = "Listening ...";
      _hasSpoken = false;
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _message = "Analyzing ...";
      _hasSpoken = true;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (_hasSpoken) {
      setState(() {
        _hasSpoken = false;
        _lastWords = result.recognizedWords;
        _message = "Analysis completed ...";
      });

      print(_lastWords.toLowerCase());

      _aiService.generateResponse(_lastWords).then((response) {
        speak(response);
        print(response);
      });

      // String answer = "Answer";

      // for (var question in _questions) {
      //   if (question != null &&
      //       question.question.toLowerCase() == _lastWords.toLowerCase()) {
      //     answer = question.answer;
      //     break;
      //   }
      // }

      // if (answer == "Answer") {
      //   answer = 'Sorry, I did not understand that.';
      // }

      // speak(answer);
      // print(answer);
    }
  }
  // *** END: Speech related methods

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(
      isShowingFAB: true,
      iconFAB:
          _speechEnabled
              ? _speechToText.isListening || _isSpeaking
                  ? Icons.stop
                  : Icons.mic
              : Icons.play_arrow,
      onFABPressed: () {
        if (!_speechEnabled) {
          _initSpeech();
        } else {
          if (_speechToText.isListening) {
            _stopListening();
          } else if (_isSpeaking) {
            flutterTts.stop();
            setState(() {
              _isSpeaking = false;
              _message = "Stopped Speaking ...";
            });
          } else {
            _startListening();
          }
        }
      },
      child: Stack(
        children: [
          ARKitSceneView(
            configuration: ARKitConfiguration.worldTracking,
            onARKitViewCreated: (ARKitController arKitController) {
              _arKitController = arKitController;
            },
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity - 300,
            child: Flutter3DViewer(
              src: widget.models[widget.selectedModelIndex].path,
              controller: controller(),
            ),
          ),
        ],
      ),
    );
  }

  Flutter3DController controller() {
    _3DController = Flutter3DController();

    try {
      _3DController.onModelLoaded.addListener(() {
        _3DController.getAvailableTextures().then((textures) {
          if (textures.isNotEmpty) {
            final textureName = textures.first;
            print('Available texture: $textureName');
            _3DController.setTexture(textureName: textureName);
          } else {
            print('No textures available.');
          }
        });
        _3DController.getAvailableAnimations().then((animations) {
          if (animations.isNotEmpty) {
            final animationName = animations.first;
            print('Available animation: $animationName');
            _3DController.playAnimation(
              animationName: animationName,
              loopCount: 0,
            );
          } else {
            print('No animations available.');
          }
        });
        _3DController.playAnimation(animationName: "Animation", loopCount: 0);

        if (!_speechEnabled) {
          _initSpeech();
        }

        _aiService = AiService();
      });
    } catch (e) {
      print(e);
    }

    return _3DController;
  }
}
