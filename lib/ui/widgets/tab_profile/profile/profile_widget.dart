// ignore_for_file: depend_on_referenced_packages
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy");
    var viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.user == null ? "" : viewModel.user!.username)),
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
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          avatar: viewModel.avatar ??
                              Image.asset(
                                "assets/icons/default_avatar.png",
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
                              viewModel.user?.postsAmount.toString() ??
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
                              viewModel.user?.followersAmount.toString() ??
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
                              viewModel.user?.followedAmount.toString() ??
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
                ElevatedButton(onPressed: () => viewModel.toAccount() , child: Text("Account")),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      //create: (context) => ProfileViewModel(context: context),
      create: (context) {
        return ProfileViewModel(context: context);
      },
      child: const ProfileWidget(),
    );
  }
}
