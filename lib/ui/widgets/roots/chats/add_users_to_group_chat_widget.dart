import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/enums/search_selection.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/renew_users_in_chat_request.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/check_box_users_list_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUsersToGroupChatWidget extends StatelessWidget {
  final _authService = AuthService();
  final String? chatId;

  ChatModel? chatData;
  List<String>? initialParticipantsId;
  List<String>? currentParticipantsId;

  AddUsersToGroupChatWidget({super.key, this.chatId}) {
    asyncInit();
  }

  void asyncInit() async {
    chatData = await _authService.getChatData(chatId!);
    initialParticipantsId = chatData!.participants.map((e) => e.id).toList();
    currentParticipantsId = chatData!.participants.map((e) => e.id).toList();
  }

  void renewUsersInGroupChat() async {
    var model = RenewUsersInChatRequest(
        targetUsersId: currentParticipantsId!, chatId: chatId!);
    await _authService.renewGroupChatUsersList(model);
    showModal();
  }

  void showModal() {
    var ctx = AppNavigator.key.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            //title: Text(title),
            content: const Text("Changes saved"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: <Widget>[
          const SizedBox(
            width: 40,
          ),
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
        ],
      ),
      body: viewModel.users == null
          ? const Center(child: CircularProgressIndicator())
          : CheckBoxUsersListWidget(
              currentParticipantsId: currentParticipantsId,
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: IconButton(
          onPressed: renewUsersInGroupChat,
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }

  static create({Object? arg}) {
    String? chatId;
    if (arg != null && arg is String) chatId = arg;
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(
          context: context, selection: SearchSelectionEnum.avalable),
      child: AddUsersToGroupChatWidget(chatId: chatId),
    );
  }
}