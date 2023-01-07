import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/home/home_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dd_study2022_ui/domain/enums/popup_menu_values.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    var itemCount = viewModel.postFeed?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leadingWidth: 200,
        leading: PopupMenuButton<PopUpMenuValues>(
          onSelected: (value) {
            switch (value) {
              case PopUpMenuValues.logout:
                viewModel.logout();
                break;
            }
          },
          color: Colors.grey,
          position: PopupMenuPosition.under,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              value: PopUpMenuValues.logout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("logout"),
                  Icon(Icons.exit_to_app),
                ],
              ),
            ),
          ],
          child: TextButton(
            onPressed: null,
            child: Row(
              children: const [
                Text(
                  'Sadgram',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: "Fontspring",
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: viewModel.postFeed == null
                ? const Center(child: CircularProgressIndicator(color: Colors.black,))
                : ListView.separated(
                    controller: viewModel.lvc,
                    itemBuilder: (_, listIndex) {
                      if (listIndex == 0) {
                        return GestureDetector(
                          onTap: () =>
                              viewModel.toProfile(context, viewModel.user!.id),
                          child: AvatarWithNameWidget(
                            avatarRadius: 34,
                            user: viewModel.user,
                          ),
                        );
                      } else {
                        return PostWidget(
                          viewModel: viewModel,
                          listIndex: listIndex,
                        );
                      }
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    itemCount: itemCount,
                  ),
          ),
          if (viewModel.isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel(context: context),
      child: const HomeWidget(),
    );
  }
}