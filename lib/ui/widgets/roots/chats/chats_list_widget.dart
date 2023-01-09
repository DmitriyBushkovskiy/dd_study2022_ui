import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_preview_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chats_list_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/create_new_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsListWidget extends StatelessWidget {
  const ChatsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatsListViewModel>();
    var itemCount = viewModel.chats?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNewChatWidget.create()));}, //TODO: fix it?
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        controller: viewModel.lvc,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          return ChatPreview(
            index,
            chat: viewModel.chats![index],
          );
        },
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Colors.black,
        ),
        itemCount: itemCount,
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ChatsListViewModel(context: context),
      child: const ChatsListWidget(),
    );
  }
}
