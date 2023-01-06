import 'package:flutter/material.dart';

class LikeIconWidget extends StatelessWidget {
  const LikeIconWidget({super.key, required this.likedByMe});
  final bool likedByMe;

  @override
  Widget build(BuildContext context) {
    return Icon(
      likedByMe ? Icons.favorite : Icons.heart_broken,
      color: likedByMe ? Colors.black : Colors.grey[600],
    );
  }
}