import 'package:flutter/material.dart';
import 'package:reveal/configs/layout.dart';

class Test2HomePage extends StatefulWidget {
  const Test2HomePage({super.key});

  @override
  State<Test2HomePage> createState() => _Test2HomePageState();
}

class _Test2HomePageState extends State<Test2HomePage> {
  @override
  Widget build(BuildContext context) {
    return ARAppLayout(children: [const Placeholder()]);
  }
}
