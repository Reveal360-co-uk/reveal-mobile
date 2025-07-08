import 'package:flutter/material.dart';

class SimpleInputBox extends StatefulWidget {
  final String placeholder;
  final Function(String value)? onChange;
  final Function(String value)? onComplete;
  const SimpleInputBox({
    super.key,
    required this.placeholder,
    this.onChange,
    this.onComplete,
  });

  @override
  State<SimpleInputBox> createState() => _SimpleInputBoxState();
}

class _SimpleInputBoxState extends State<SimpleInputBox> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(labelText: widget.placeholder),
      onChanged: (value) {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
      onEditingComplete: () {
        if (widget.onComplete != null) {
          widget.onComplete!(textEditingController.text);
        }
      },
    );
  }
}
