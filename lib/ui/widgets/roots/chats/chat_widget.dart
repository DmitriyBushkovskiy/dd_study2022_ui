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
        title: viewModel.participants?.length == 2
            ? Text(viewModel.participants
                    ?.firstWhere((element) => element.id != viewModel.user?.id)
                    .username ??
                "")
            : const Text("Group chat"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: viewModel.lvc,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageWidget(
                    message: viewModel.messages![index],
                  );
                },
                reverse: true,
                itemCount: itemCount,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(2),
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: viewModel.messageTec,
                  decoration: const InputDecoration(
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
              IconButton(
                onPressed: viewModel.sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: Bottom(),
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
