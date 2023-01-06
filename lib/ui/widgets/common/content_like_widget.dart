import 'package:flutter/material.dart';

class ContentLikeCounter extends StatelessWidget {
  final bool likedByMe;
  final int likesAmount;

  const ContentLikeCounter({
    super.key,
    required this.likedByMe,
    required this.likesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          width: 35,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            const Icon(
              Icons.favorite_sharp,
              size: 30,
            ),
            Icon(
              likedByMe ? Icons.favorite_sharp : Icons.heart_broken_sharp,
              color: Colors.white,
            )
          ]),
        ),
        likesAmount == 0
            ? const SizedBox.shrink()
            : Stack(
                children: <Widget>[
                  Text(
                    likesAmount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    likesAmount.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
      ],
    );
  }
}