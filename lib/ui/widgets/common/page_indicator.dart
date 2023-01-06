import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Stack(alignment: AlignmentDirectional.center, children: [
          if (i == (current ?? 0))
            const Icon(
              Icons.circle,
              color: Colors.white,
              size: 14,
            ),
          const Icon(
            Icons.circle,
            size: 10,
          ),
        ]),
      );
    }
    return count == 1
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...widgets],
          );
  }
}