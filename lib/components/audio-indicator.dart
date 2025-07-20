import 'package:flutter/material.dart';
import 'package:reveal/components/tracker_container.dart';

class AudioIndicator extends StatelessWidget {
  final bool isTalking;
  const AudioIndicator({super.key, this.isTalking = false});

  @override
  Widget build(BuildContext context) {
    return TrackerContainer(
      child: Icon(
        isTalking ? Icons.multitrack_audio_rounded : Icons.mic,
        color: Colors.white,
      ),
    );
  }
}
