import 'package:dd_study2022_ui/domain/enums/relation_state.dart';
import 'package:dd_study2022_ui/domain/models/relation_state_model.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowButtonWidget extends StatelessWidget {
  final RelationStateModel? relationStateModel;

  const FollowButtonWidget({
    Key? key,
    required this.relationStateModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();
    String buttonText = "";
    VoidCallback? buttonFunction;

    if (relationStateModel != null) {
      switch (relationStateModel!.relationAsFollower) {
        case RelationStateEnum.banned:
          buttonText = "You are banned!";
          break;
        case RelationStateEnum.follower:
          buttonText = "UnFollow";
          buttonFunction = viewModel.follow;
          break;
        case RelationStateEnum.notstate:
          buttonText = "Follow";
          buttonFunction = viewModel.follow;
          break;
        case RelationStateEnum.request:
          buttonText = "Cancel the request";
          buttonFunction = viewModel.follow;
          break;
        default:
          throw Exception("Wrong format");
      }
    }
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(170, 40)),
      ),
      onPressed: buttonFunction,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
      ),
    );
  }
}