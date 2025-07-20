import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:reveal/configs/constants.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speechToText = SpeechToText();
  bool hasListeningStopped = false;

  VoiceService() {
    print("Initializing speech to text");
    speechToText.initialize();
  }

  Future<void> speak(
    String textToSpeak, {
    VoiceLanguages language = VoiceLanguages.english,
    VoiceGender gender = VoiceGender.female,
    Function? onComplete,
  }) async {
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
    );

    switch (language) {
      case VoiceLanguages.hindi:
        await flutterTts.setPitch(0.8);
        await flutterTts.setSpeechRate(0.4);
        await flutterTts.setVoice(
          gender == VoiceGender.female
              ? {"identifier": "com.apple.ttsbundle.Lekha-compact"}
              : {"identifier": "com.apple.ttsbundle.Rishi-compact"},
        );
        break;

      default:
        await flutterTts.setVoice(
          gender == VoiceGender.female
              ? {"identifier": "com.apple.ttsbundle.siri_female_en-US_compact"}
              : {"identifier": "com.apple.ttsbundle.Daniel-compact"},
        );
        break;
    }

    return await Future.delayed(const Duration(milliseconds: 1000), () async {
      // Here you can write your code
      flutterTts.completionHandler = () async {
        flutterTts.stop();
        print("Completed speaking");
        if (onComplete != null) {
          onComplete();
        }
      };

      await flutterTts.speak(textToSpeak).then((_) {
        // if (onComplete != null) {
        //   onComplete();
        // }
      });
    });
  }

  Future<void> listen(Function(String value) onSpeech) async {
    if (hasListeningStopped) {
      return;
    }

    String lastSpokenWords = "";
    String lastAnalysedWords = "";
    String allRecognizedWords = "";
    // Future.delayed(Duration(seconds: 10)).then((dynamic value) {
    //   print("Ending the listening cycle");
    //   _endListening();
    // });

    speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        print("Analysing words");
        //print(result.recognizedWords);

        lastAnalysedWords = result.recognizedWords;
        if (result.finalResult) {
          hasListeningStopped = true;
          lastAnalysedWords = lastSpokenWords = "";
          onSpeech(result.recognizedWords);
        }
      },
    );

    Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      if (hasListeningStopped) return;

      if ((lastSpokenWords == lastAnalysedWords) && (lastAnalysedWords != "")) {
        print("Last Analysed words: $lastAnalysedWords");
        print("Silence detected");
        speechToText.stop();
        //onSpeech(lastSpokenWords.replaceAll(allRecognizedWords, ""));
        allRecognizedWords = lastAnalysedWords;
        lastAnalysedWords = lastSpokenWords = "";
      } else {
        lastSpokenWords = lastAnalysedWords;
      }
    });
  }

  void startListening(Function(String value) onSpeech) async {
    hasListeningStopped = false;
    await listen(onSpeech);
  }

  void stopListening() async {
    await speechToText.stop();
    hasListeningStopped = true;
  }
}
