import 'package:flutter/material.dart';
import 'package:reveal/configs/layout.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class STTTestPage extends StatefulWidget {
  const STTTestPage({super.key});

  @override
  State<STTTestPage> createState() => _STTTestPageState();
}

class _STTTestPageState extends State<STTTestPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _message = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _message = "Listening ...";
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
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _message = "Analysis completed ...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // If listening is active show the recognized words
            _speechToText.isListening
                ? _lastWords
                // If listening isn't active but could be tell the user
                // how to start it, otherwise indicate that speech
                // recognition is not yet ready or not supported on
                // the target device
                : _speechEnabled
                ? 'Tap the microphone to start listening...'
                : 'Speech not available',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(_lastWords, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          Text(_message, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
