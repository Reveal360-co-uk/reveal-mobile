// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final bool isShowingFAB;
  final Function? onFABPressed;
  const AppLayout({
    super.key,
    required this.child,
    this.onFABPressed,
    this.isShowingFAB = false,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reveal360'),
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    // Handle menu action
                    Navigator.pop(context);
                  },
                )
                : null,
        elevation: 1,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
              print('Settings clicked');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(10), child: widget.child),
      ),
      floatingActionButton:
          widget.isShowingFAB
              ? FloatingActionButton(
                onPressed: () {
                  // Handle FAB action
                  if (widget.onFABPressed != null) {
                    widget.onFABPressed!();
                  }
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
