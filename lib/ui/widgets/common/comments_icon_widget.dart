import 'dart:math' as math;
import 'package:flutter/material.dart';

class CommentsIconWidget extends StatelessWidget {
  const CommentsIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: const Icon(Icons.mode_comment_outlined),
    );
  }
}
