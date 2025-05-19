import 'package:flutter/material.dart';

class ModelTile extends StatelessWidget {
  final String modelName;
  final Function(int index)? onClick;
  final int index;
  const ModelTile({
    super.key,
    required this.index,
    required this.modelName,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick!(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          style: ListTileStyle.list,
          title: Text(modelName, style: TextStyle(fontSize: 18)),
          subtitle: const Text('Reveal360 - 3D Model'),
          leading: const Icon(Icons.emoji_objects),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              if (onClick != null) {
                onClick!(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
