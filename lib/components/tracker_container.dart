import 'package:ai_glow/ai_glow.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TrackerContainer extends StatelessWidget {
  final Widget child;

  TrackerContainer({super.key, required this.child});

  final List<Color> _colorsIOS = [
    Color(0xFFD166D3),
    Color(0xFFF7BF69),
    Color(0xFFE2A0CB),
    Color(0xFFC982F7),
    Color(0xFFC580F3),
    Color(0xFFF1BFEB),
    Color(0xFF939AF9),
    Color(0xFFA97DF5),
  ];

  @override
  Widget build(BuildContext context) {
    return InnerAiGlowing(
      width: 50,
      height: 50,
      borderRadius: 50,
      glowWidth: 5,
      blure: 7,
      colors: _colorsIOS,
      child: Container(
        //width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 11, 11, 11),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color.fromARGB(60, 84, 23, 169)),
        ),
        child: InkWell(onTap: () {}, child: child),
      ),
    );
  }
}
