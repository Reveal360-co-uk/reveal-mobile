import 'package:flutter/material.dart';
import 'package:reveal/configs/theme.dart';
import 'package:reveal/services/naviagtion_service.dart';
import 'package:reveal/views/demo/page.dart';
//import 'package:reveal/views/home/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'Reveal 360',
      home: DemoPage(),
    );
  }
}
