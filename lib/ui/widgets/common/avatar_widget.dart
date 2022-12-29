import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final Image avatar;
  final double? padding;
  final double radius;
  final bool colorAvatar;

  const AvatarWidget(
      {Key? key,
      required this.avatar,
      this.padding,
      required this.radius,
      required this.colorAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 0),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: radius,
        child: Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode:
                (colorAvatar ? BlendMode.dstATop : BlendMode.saturation),
          ),
          child: CircleAvatar(
            radius: radius - 1,
            backgroundImage: avatar.image,
          ),
        ),
      ),
    );
  }
}
