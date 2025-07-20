import 'package:flutter/material.dart';
import 'package:reveal/components/simple_input_box.dart';
import 'package:reveal/configs/constants.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/services/ai_service.dart';
import 'package:reveal/services/voice_service.dart';

class AITestPage extends StatefulWidget {
  const AITestPage({super.key});

  @override
  State<AITestPage> createState() => _AITestPageState();
}

class _AITestPageState extends State<AITestPage> {
  final AiService _aiService = AiService();
  final VoiceService _voiceService = VoiceService();
  late String _question = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleInputBox(
              placeholder: "Question",
              onChange: (value) {
                setState(() {
                  _question = value;
                });
              },
              onComplete: (value) {
                setState(() {
                  _question = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _aiService
                    .generateResponse(
                      _question,
                      language: VoiceLanguages.english,
                    )
                    .then((response) {
                      _voiceService.speak(response);
                    });
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
