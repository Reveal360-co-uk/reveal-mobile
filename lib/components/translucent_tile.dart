import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslucentTile extends StatelessWidget {
  final String title;
  const TranslucentTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlurryContainer(
        //padding: EdgeInsets.all(16),
        blur: 5,
        elevation: 0,
        color: Colors.white38,
        width: double.infinity,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: ListTile(
          title: Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, size: 24),
        ),
      ),
    );
  }
}
