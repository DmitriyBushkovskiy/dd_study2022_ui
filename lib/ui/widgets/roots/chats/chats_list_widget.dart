import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
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
            onPressed: () {
              viewModel.showModal();

              // return PageRouteBuilder(
              //   pageBuilder: (_, __, ___) => ChatsListWidget.create(),
              //   transitionsBuilder: (_, a, __, c) => SlideTransition(
              //       position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              //           .animate(a),
              //       child: c),
              // );

              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => GroupChatName(), transitionsBuilder: (_, a, __, c) => SlideTransition(
              // position: Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, -0.5))
              //     .animate(a),
              // child: c)));
            },
            icon: const Icon(Icons.group_add_outlined),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateNewChatWidget.create()));
            },
            icon: const Icon(Icons.person_add_alt),
          ),
        ],
      ),
      body: ListView.separated(
        controller: viewModel.lvc,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => viewModel.toChat(viewModel.chats![index].id),
            child: ChatPreview(
              index,
              chat: viewModel.chats![index],
            ),
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
