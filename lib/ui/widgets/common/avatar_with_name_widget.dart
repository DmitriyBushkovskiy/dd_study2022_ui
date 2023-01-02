import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:flutter/material.dart';

class AvatarWithNameWidget extends StatelessWidget {
  final dynamic viewModel;
  final User? user;
  final EdgeInsets padding;
  final double avatarRadius;

  const AvatarWithNameWidget({
    Key? key,
    required this.viewModel,
    required this.avatarRadius,
    required this.user,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: [
          Container(
            padding: padding,
            child: user != null
                ? UserAvatarWidget(user: user, radius: avatarRadius)
                : const CircularProgressIndicator(),
          ),
          user == null
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () => viewModel.toProfile(context, user!.id),
                  child:
                      Text(user!.username),
                )
        ],
      ),
    );
  }
}