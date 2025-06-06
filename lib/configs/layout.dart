// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:reveal/built_in_models.dart';
import 'package:reveal/test_stt.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final bool isShowingFAB;
  final IconData iconFAB;
  final Function? onFABPressed;
  final Function? onMicPressed;
  const AppLayout({
    super.key,
    required this.child,
    this.onFABPressed,
    this.onMicPressed,
    this.isShowingFAB = false,
    this.iconFAB = Icons.add,
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
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: () {
              // Handle settings action
              print('Mic clicked');
              if (widget.onMicPressed != null) {
                widget.onMicPressed!();
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => STTTestPage()),
              );
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
                child: Icon(widget.iconFAB),
              )
              : null,
    );
  }
}

class ARAppLayout extends StatefulWidget {
  final Widget child;
  final bool isShowingFAB;
  final IconData iconFAB;
  final Function? onFABPressed;
  final Function? onMicPressed;
  const ARAppLayout({
    super.key,
    required this.child,
    this.onFABPressed,
    this.onMicPressed,
    this.isShowingFAB = false,
    this.iconFAB = Icons.add,
  });

  @override
  State<ARAppLayout> createState() => _ARAppLayoutState();
}

class _ARAppLayoutState extends State<ARAppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton:
          widget.isShowingFAB
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => BuildInModels()),
                        (route) => false,
                      );
                    },
                    child: Icon(Icons.chevron_left),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () {
                      // Handle FAB action
                      if (widget.onFABPressed != null) {
                        widget.onFABPressed!();
                      }
                    },
                    child: Icon(widget.iconFAB),
                  ),
                ],
              )
              : null,
    );
  }
}
