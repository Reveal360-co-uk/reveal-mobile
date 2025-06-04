import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/configs/types.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PreviewModel extends StatefulWidget {
  final int selectedModelIndex;
  final List<BuiltInModelFile> models = AppConstants.BUILT_IN_MODELS;

  PreviewModel({super.key, required this.selectedModelIndex});

  @override
  State<PreviewModel> createState() => _PreviewModelState();
}

class _PreviewModelState extends State<PreviewModel> {
  final FlutterTts flutterTts = FlutterTts();
  List<Questions> questions = AppConstants.QUESTIONS;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _message = '';
  late ARKitController arkitController;
  bool _hasSpoken = false;
  double _scale = 0.1;
  late ARKitGltfNode? _node;
  OperationType currentOperation = OperationType.none;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  void speak(String textToSpeak) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Here you can write your code

      setState(() {
        print(textToSpeak);
        // Here you can write your code for open new view
        String finalText = textToSpeak.replaceAll(
          "#name",
          widget.models[widget.selectedModelIndex].name,
        );
        _message = finalText;
        flutterTts.speak(finalText);
      });
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    if (Platform.isIOS) {
      await flutterTts.setVoice({
        "identifier": "com.apple.voice.compact.en-AU.Karen",
      });
    }
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
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
      _hasSpoken = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _message = "Analysis completed ...";
    });

    Questions? answer = questions.firstWhereOrNull(
      (element) => element.question == _lastWords.toLowerCase(),
    );

    _hasSpoken = false;

    if (result.finalResult) {
      print(_lastWords);
      if (answer != null) {
        print(answer.answer);
        speak(answer.answer);
      } else {
        speak('Sorry, I did not understand that.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(
      isShowingFAB: true,
      iconFAB: _speechToText.isListening ? Icons.stop : Icons.mic,
      onFABPressed: () {
        // if (_speechToText.isNotListening) _startListening();
        // _stopListening();
        if (_speechToText.isListening) {
          _stopListening();
        } else {
          _startListening();
        }
      },
      child: ARKitSceneView(
        showFeaturePoints: true,
        enableTapRecognizer: true,
        enablePinchRecognizer: true,
        enableRotationRecognizer: true,
        planeDetection: ARPlaneDetection.horizontalAndVertical,
        onARKitViewCreated: onARKitViewCreated,
      ),
      // child: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       SizedBox(
      //         height: 650,
      //         width: double.infinity,
      //         child: ARKitSceneView(
      //           showFeaturePoints: true,
      //           enableTapRecognizer: true,
      //           planeDetection: ARPlaneDetection.horizontalAndVertical,
      //           onARKitViewCreated: onARKitViewCreated,
      //         ),
      //       ),
      //       Text(
      //         // If listening is active show the recognized words
      //         _speechToText.isListening
      //             ? _lastWords
      //             // If listening isn't active but could be tell the user
      //             // how to start it, otherwise indicate that speech
      //             // recognition is not yet ready or not supported on
      //             // the target device
      //             : _speechEnabled
      //             ? 'Tap the microphone to start listening...'
      //             : 'Speech not available',
      //         style: const TextStyle(fontSize: 20),
      //       ),
      //       const SizedBox(height: 20),
      //       Text(_lastWords, style: const TextStyle(fontSize: 30)),
      //       const SizedBox(height: 20),
      //       Text(_message, style: const TextStyle(fontSize: 20)),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> animateNode(String nodeName) async {
    await arkitController.playAnimation(
      key: '',
      sceneName: nodeName,
      animationIdentifier: 'random',
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    this.arkitController.onNodeTap = (List<String> nodeNames) {
      if (nodeNames.isNotEmpty) {
        final tappedNodeName = nodeNames.first;

        // animateNode(tappedNodeName).then((_) {
        //   print('Animation completed for node: $tappedNodeName');
        // });

        print('Tapped node: $tappedNodeName');
      }
    };

    // _scale = scale;
    //         _node!.scale = vector.Vector3(_scale, _scale, _scale);
    //         print('Pinched node: ${node.name} with scale: $_scale');

    this.arkitController.onNodePinch = (List<ARKitNodePinchResult> results) {
      if (results.isNotEmpty && (currentOperation != OperationType.rotation)) {
        currentOperation = OperationType.pinch;
        final scale = results.first.scale;

        _scale = scale;
        _node!.scale = vector.Vector3.all(_scale);
        print('Pinched node: ${_node!.name} with scale: $_scale');
      }
    };

    this.arkitController.onNodeRotation = (
      List<ARKitNodeRotationResult> results,
    ) {
      if (results.isNotEmpty && (currentOperation != OperationType.pinch)) {
        currentOperation = OperationType.rotation;
        final rotation = results.first.rotation;
        _node!.rotation = vector.Matrix3.rotationY(rotation);
        print('Rotated node: ${_node!.name} with rotation: $rotation');
      }
    };

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
    try {
      //arkitController.remove(_node!.name);
      return;
    } catch (e) {
      print(e);
    }

    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    _node = _getNodeFromFlutterAsset(position);
    arkitController.add(_node!);
  }

  ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) =>
      ARKitGltfNode(
        assetType:
            widget.models[widget.selectedModelIndex].isAsset
                ? AssetType.flutterAsset
                : AssetType.documents,
        //url: 'assets/fox.glb',
        url: widget.models[widget.selectedModelIndex].path,
        scale: vector.Vector3(_scale, _scale, _scale),
        name:
            widget
                .models[widget.selectedModelIndex]
                .name, // Consistent naming for animation control
        position: position,
      );
}
