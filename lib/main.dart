import 'package:flutter/material.dart';
import 'package:reveal/built_in_models.dart';
import 'package:reveal/configs/theme.dart';
import 'package:reveal/services/file_service.dart';
import 'package:reveal/test_stt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Reveal 360',
      home: STTTestPage(),
    );
  }
}
