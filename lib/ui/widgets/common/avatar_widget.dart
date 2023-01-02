import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final User? user;
  final double radius;

  const UserAvatarWidget({Key? key, required this.user, required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: radius,
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.grey,
          backgroundBlendMode:
              (user?.colorAvatar ?? false ? BlendMode.dstATop : BlendMode.saturation),
        ),
        child: CircleAvatar(
          radius: radius - 1,
          backgroundImage: (user?.avatarLink == null)
              ? Image.asset("assets/icons/default_avatar.png").image
              : Image.network(
                  "$baseUrl${user!.avatarLink}",
                  fit: BoxFit.cover,
                ).image,
        ),
      ),
    );
  }
}
