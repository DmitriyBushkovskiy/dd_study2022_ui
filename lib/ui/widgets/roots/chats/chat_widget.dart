import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatViewModel>();
    var itemCount = viewModel.messages?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: viewModel.chat?.isPrivate ?? false
            ? Text(viewModel.chat!.participants
                    .firstWhere((element) => element.id != viewModel.user?.id)
                    .username)
            : Text(viewModel.chat?.name ?? "Group chat"),
        actions: [
          if (!(viewModel.chat?.isPrivate ?? true))
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => viewModel.addUsersToGroupChat(),
              icon: const Icon(Icons.person_add_outlined),
            ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: viewModel.lvc,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  return MessageWidget(
                    message: viewModel.messages![index],
                  );
                },
                reverse: true,
                itemCount: itemCount,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(2),
                //width: double.infinity,
                //height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 42,
                          maxWidth: 320,
                          maxHeight: 150,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: viewModel.messageTec,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: viewModel.sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static create(Object? arg) {
    String? chatId;
    if (arg != null && arg is String) chatId = arg;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          ChatViewModel(context: context, chatId: chatId),
      child: const ChatWidget(),
    );
  }
}