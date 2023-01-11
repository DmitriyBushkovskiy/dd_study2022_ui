import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckBoxUsersListWidget extends StatefulWidget {
  final List<String>? currentParticipantsId;

  const CheckBoxUsersListWidget({super.key, this.currentParticipantsId});

  @override
  State<CheckBoxUsersListWidget> createState() =>
      _CheckBoxUsersListWidgetState();
}

class _CheckBoxUsersListWidgetState extends State<CheckBoxUsersListWidget> {
  void changeParticipantsList(String userId, bool state) {
    if (state) {
      widget.currentParticipantsId?.add(userId);
    } else {
      widget.currentParticipantsId?.remove(userId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();
    var itemCount = viewModel.users!.length;

    return ListView.separated(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      addAutomaticKeepAlives: true,
      controller: viewModel.lvc,
      itemBuilder: (_, listIndex) => CheckboxListTile(
        onChanged: (value) => {
          changeParticipantsList(viewModel.users![listIndex].id, value ?? false)
        },
        value: widget.currentParticipantsId
                ?.contains(viewModel.users![listIndex].id) ??
            false,
        contentPadding: const EdgeInsets.only(left: 0),
        title: AvatarWithNameWidget(
          avatarRadius: 30,
          user: viewModel.users![listIndex],
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