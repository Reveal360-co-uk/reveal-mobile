import 'package:flutter_gemini/flutter_gemini.dart';

class AiService {
  final String _apiKey = "AIzaSyBc_ijNVrUvz09xZloeYIUKbkpF6Ax5Ais";

  AiService() {
    Gemini.init(apiKey: _apiKey);
  }

  Future<String> generateResponse(String question) async {
    try {
      final response = await Gemini.instance.prompt(
        parts: [Part.text(question)],
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
