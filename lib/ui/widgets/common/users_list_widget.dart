import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:flutter/material.dart';

class UsersListWidget extends StatefulWidget {
  final dynamic relationsViewModel;
  final List<User> usersList;
  final ScrollController controller;

  const UsersListWidget({
    super.key,
    required this.relationsViewModel,
    required this.usersList,
    required this.controller,
  });

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  @override
  Widget build(BuildContext context) {
    var itemCount = widget.usersList.length;

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      controller: widget.controller,
      itemBuilder: (_, listIndex) => GestureDetector(
        onTap: () => widget.relationsViewModel
            .toProfile(context, widget.usersList[listIndex].id),
        child: AvatarWithNameWidget(
          avatarRadius: 30,
          user: widget.usersList[listIndex],
        ),
      ),
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black,
        height: 0,
      ),
      itemCount: itemCount,
    );
  }
}