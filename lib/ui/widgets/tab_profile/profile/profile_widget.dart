import 'package:dd_study2022_ui/ui/widgets/tab_home/post_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/ban_button_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/follow_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();
    var itemCount = viewModel.postFeed?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.targetUser == null
              ? ""
              : viewModel.targetUser!.username)),
      body: viewModel.user == null
          ? const SizedBox.shrink()
          : ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: viewModel.lvc, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserAvatarWidget(
                        user: viewModel.targetUser,
                        radius: 41,
                      ),
                      Center(
                        child: Column(
                          children: [
                            const Text('Posts'),
                            Text(
                              viewModel.targetUser?.postsAmount
                                      .toString() ??
                                  "no data",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => viewModel.toRelations(),
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
                        onTap: () => viewModel.toRelations(),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: viewModel.targetUserId != viewModel.user!.id
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FollowButtonWidget(
                                relationStateModel:
                                    viewModel.relationStateModel),
                            BanButtonWidget(
                                relationStateModel:
                                    viewModel.relationStateModel)
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: viewModel.toAccount,
                                child: const Text("Account")),
                          ],
                        ),
                ),
                viewModel.postFeed == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, listIndex) => PostWidget(
                          viewModel: viewModel,
                          listIndex: listIndex,
                        ),
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                        ),
                        itemCount: itemCount,
                      ),
                if (viewModel.isLoading) const LinearProgressIndicator(),
              ],
            ),
          ]),
    );
  }

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
