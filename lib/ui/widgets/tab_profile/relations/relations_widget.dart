import 'package:dd_study2022_ui/domain/enums/relation_page_items.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/ui/widgets/common/users_list_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/relations/relations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RelationsWidget extends StatelessWidget {
  const RelationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    var viewModel = context.watch<RelationsViewModel>();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(viewModel.targetUser?.username ?? "no data"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: size.width /
                    size.height /
                    0.25 /
                    (viewModel.user?.id == viewModel.targetUserId ? 1 : 0.5),
                crossAxisCount:
                    viewModel.user?.id == viewModel.targetUserId ? 4 : 2,
              ),
              itemCount: viewModel.user?.id == viewModel.targetUserId ? 4 : 2,
              itemBuilder: (BuildContext ctx, index) {
                return TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero)),
                  onPressed: () => viewModel.pageController!.jumpToPage(index),
                  child: Text(
                    RelationPageNamesEnum
                        .pageName[RelationPageItemsEnum.values[index]]!,
                    style: TextStyle(
                        fontSize: viewModel.currentPage == index ? 16 : 10),
                  ),
                );
              },
            ),
          ),
           Expanded(
            child: PageView(
              controller: viewModel.pageController,
              onPageChanged: (value) => viewModel.currentPage = value,
              children: [
                UsersListWidget(
                  relationsViewModel: viewModel,
                  usersList: viewModel.followersList ?? <User>[],
                  controller: viewModel.followersController,
                ),
                UsersListWidget(
                  relationsViewModel: viewModel,
                  usersList: viewModel.followedList ?? <User>[],
                  controller: viewModel.followedController,
                ),
                if (viewModel.user?.id == viewModel.targetUserId)
                  UsersListWidget(
                    relationsViewModel: viewModel,
                    usersList: viewModel.bannedList ?? <User>[],
                    controller: viewModel.bannedController,
                  ),
                if (viewModel.user?.id == viewModel.targetUserId)
                  UsersListWidget(
                    relationsViewModel: viewModel,
                    usersList: viewModel.requestsList ?? <User>[],
                    controller: viewModel.requestsController,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static create(Object? arg) {
    String? targetUserId;
    if (arg != null && arg is String) targetUserId = arg;
    return ChangeNotifierProvider(
      create: (context) {
        return RelationsViewModel(context: context, targetUserId: targetUserId);
      },
      child: const RelationsWidget(),
    );
  }
}
