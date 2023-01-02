// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

import 'package:dd_study2022_ui/domain/enums/relation_state.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/home.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy");
    var viewModel = context.watch<ProfileViewModel>();
    var itemCount = viewModel.postFeed?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.targetUser == null
              ? ""
              : viewModel.targetUser!.username)),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            //padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            viewModel.changePhoto();
                          },
                          onLongPress: () {
                            viewModel.colorAvatar;
                            viewModel.changeText("longpress");
                          },
                          child: AvatarWidget(
                            avatar: viewModel.targetUser!.avatarLink == null
                                ? Image.asset("assets/icons/default_avatar.png")
                                : Image.network(
                                    "$baseUrl${viewModel.targetUser!.avatarLink}",
                                    key: ValueKey(const Uuid().v4()),
                                    fit: BoxFit.cover,
                                  ),
                            radius: 41,
                            colorAvatar: false, // TODO: viewmodel.user
                          )),
                      GestureDetector(
                        onTap: () {
                          viewModel.changeText("Posts");
                        },
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Posts'),
                              Text(
                                viewModel.targetUser?.postsAmount.toString() ??
                                    "no data",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewModel.changeText("Followers");
                        },
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Followers'),
                              Text(
                                viewModel.targetUser?.followersAmount
                                        .toString() ??
                                    "no data",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewModel.changeText("Followed");
                        },
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Followed'),
                              Text(
                                viewModel.targetUser?.followedAmount
                                        .toString() ??
                                    "no data",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(viewModel.targetUserId.toString()),
                Text("myRelation ${viewModel.myRelationState.toString()}"),
                Text("RelationToMe ${viewModel.myRelationState.toString()}"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: viewModel.targetUserId != viewModel.user!.id
                      ? Row(
                          children: [
                            FollowButtonWidget(
                                relationState: viewModel.myRelationState!),
                            BanButtonWidget(relationToMeState: viewModel.relationToMeState!)
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () => viewModel.toAccount(),
                                child: Text("Account")),
                          ],
                        ),
                ),
                Expanded(
                  child: viewModel.postFeed == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          controller: viewModel.lvc,
                          itemBuilder: (_, listIndex) => PostInFeedWidget(
                            viewModel: viewModel,
                            listIndex: listIndex,
                          ),
                          separatorBuilder: (context, index) => Container(
                            height: 20,
                            color: Colors.green,
                          ),
                          itemCount: itemCount,
                        ),
                ),
                Container(
                  color: Colors.red,
                  height: 120,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // static create() {
  //   return ChangeNotifierProvider(
  //     //create: (context) => ProfileViewModel(context: context),
  //     create: (context) {
  //       return ProfileViewModel(context: context);
  //     },
  //     child: const ProfileWidget(),
  //   );
  // }

  static create({BuildContext? bc, Object? arg}) {
    String? targetUserId;
    if (arg != null && arg is String) targetUserId = arg;
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(
            context: bc ?? context, targetUserId: targetUserId);
      },
      child: const ProfileWidget(),
    );
  }
}

class FollowButtonWidget extends StatelessWidget {
  final RelationStateEnum
      relationState; //TODO:remove and use field frow viewModel

  const FollowButtonWidget({Key? key, required this.relationState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();

    switch (relationState) {
      case RelationStateEnum.banned:
        return const Text("You are banned!");
      case RelationStateEnum.follower:
        return ElevatedButton(
          onPressed: viewModel.follow,
          child: const Text("UnFollow"),
        );
      case RelationStateEnum.notstate:
        return ElevatedButton(
          onPressed: viewModel.follow,
          child: const Text("Follow"),
        );
      case RelationStateEnum.request:
        return const Text("You have sent a request");
      default:
        throw Exception("Wrong format");
    }
  }
}

class BanButtonWidget extends StatelessWidget {
  final RelationStateEnum relationToMeState;

  const BanButtonWidget({Key? key, required this.relationToMeState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();

    return relationToMeState == RelationStateEnum.banned
        ? ElevatedButton(onPressed: viewModel.unban, child: Text("UnBan"))
        : ElevatedButton(onPressed: viewModel.ban, child: Text("Ban"));
  }
}

// class BanButton extends StatefulWidget {
//   const BanButton({super.key});

//   @override
//   State<BanButton> createState() => _BanButtonState();
// }

// class _BanButtonState extends State<BanButton> {


//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
