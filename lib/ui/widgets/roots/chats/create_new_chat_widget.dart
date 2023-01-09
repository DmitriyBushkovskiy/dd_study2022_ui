import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewChatWidget extends StatelessWidget {
  const CreateNewChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(actions: <Widget>[
          const SizedBox(width: 40,),
          if (viewModel.isSearching)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          if (viewModel.isSearching)
            Expanded(
              child: TextFormField(
                controller: viewModel.searchTec,
              ),
            ),
          IconButton(
              onPressed: viewModel.isSearching
                  ? viewModel.hideSearchField
                  : viewModel.showSearchField,
              icon: Icon(viewModel.isSearching ? Icons.close : Icons.search))
        ]),
        body: Container(
            child: viewModel.users == null
                ? const Center(child: CircularProgressIndicator())
                : UsersListForChatWidget(
                    relationsViewModel: viewModel,
                    controller: viewModel.lvc,
                    usersList: viewModel.users!,
                  )));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(context: context),
      child: const CreateNewChatWidget(),
    );
  }
}

class UsersListForChatWidget extends StatefulWidget {
  final dynamic relationsViewModel;
  final List<User> usersList;
  final ScrollController controller;

  const UsersListForChatWidget({
    super.key,
    required this.relationsViewModel,
    required this.usersList,
    required this.controller,
  });

  void getChatId(int listIndex) async {
    final AuthService _authService = AuthService();
    var targetUserId = usersList[listIndex].id;
    var result = await _authService.getIdOrCreatePrivateChat(targetUserId);
    AppNavigator.toChat(result);
  }

  @override
  State<UsersListForChatWidget> createState() => _UsersListForChatWidgetState();
}

class _UsersListForChatWidgetState extends State<UsersListForChatWidget> {
  @override
  Widget build(BuildContext context) {
    var itemCount = widget.usersList.length;

    return ListView.separated(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      addAutomaticKeepAlives: true,
      controller: widget.controller,
      itemBuilder: (_, listIndex) => GestureDetector(
        onTap: () => widget.getChatId(listIndex),
        child:AvatarWithNameWidget(
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
