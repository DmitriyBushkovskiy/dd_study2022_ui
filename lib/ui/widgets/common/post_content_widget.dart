import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/ui/widgets/common/content_like_widget.dart';
import 'package:flutter/material.dart';

class PostContentWidget extends StatelessWidget {
  final bool likedByMe;
  final String contentLink;
  final int likesAmount;
  final Map<String, String> headers;

  const PostContentWidget(
      {super.key,
      required this.likedByMe,
      required this.likesAmount,
      required this.contentLink,
      required this.headers});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.grey,
          backgroundBlendMode:
              (likedByMe ? BlendMode.dstATop : BlendMode.saturation),
        ),
        width: size.width,
        height: size.width,
        child: Image(
          fit: BoxFit.cover,
          image: NetworkImage("$baseUrl${contentLink}", headers: headers),
        ),
      ),
      ContentLikeCounter(likedByMe: likedByMe, likesAmount: likesAmount),
    ]);
  }
}