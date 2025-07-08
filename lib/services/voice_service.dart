import 'package:flutter_tts/flutter_tts.dart';
import 'package:reveal/configs/constants.dart';

class VoiceService {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String textToSpeak, [VoiceLanguages? language]) async {
    if (language != null) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
      );
      await flutterTts.setPitch(0.8);
      await flutterTts.setSpeechRate(0.4);

      switch (language) {
        case VoiceLanguages.hindi:
          await flutterTts.setVoice({
            "identifier": "com.apple.ttsbundle.Lekha-compact",
          });
          break;

        default:
          await flutterTts.setVoice({
            "identifier": "com.apple.ttsbundle.Daniel-compact",
          });
          break;
      }
    }

    return await Future.delayed(const Duration(milliseconds: 1000), () {
      // Here you can write your code
      flutterTts.speak(textToSpeak).then((_) {});
    });
  }
}
