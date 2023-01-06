import 'package:flutter/material.dart';

class ChangedLabelWidget extends StatelessWidget {
  final bool changed;
  const ChangedLabelWidget({super.key, required this.changed});

  @override
  Widget build(BuildContext context) {
    return changed
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text("changed",
                style: TextStyle(fontSize: 10, color: Colors.grey[800])),
          )
        : const SizedBox.shrink();
  }
}