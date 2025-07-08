import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:reveal/configs/constants.dart';

class AiService {
  final String _apiKey = "AIzaSyBc_ijNVrUvz09xZloeYIUKbkpF6Ax5Ais";

  AiService() {
    Gemini.init(apiKey: _apiKey);
  }

  Future<String> generateResponse(
    String question, {
    VoiceLanguages language = VoiceLanguages.english,
  }) async {
    String languagePrompt = "Give me response in english";

    switch (language) {
      case VoiceLanguages.hindi:
        languagePrompt = "Give me response in hindi";
        break;
      default:
        languagePrompt = "Give me response in english";
        break;
    }

    try {
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text("Please respond in 2 sentences"),
          Part.text(languagePrompt),
          Part.text(question),
        ],
      );

      if (response == null || response.output!.isEmpty) {
        return "Sorry, I couldn't process your request.";
      }

      return response.output!;
    } catch (e) {
      print("Error in AI service: $e");
      return "Sorry, I couldn't process your request.";
    }
  }
}
