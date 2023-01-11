import 'package:dd_study2022_ui/domain/models/message_model.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;

  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatViewModel>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.author.id != viewModel.user?.id)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: UserAvatarWidget(user: message.author, radius: 15),
            ),
          Expanded(
            child: Align(
              alignment: message.author.id != viewModel.user?.id
                  ? Alignment.topLeft
                  : Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: message.author.id != viewModel.user?.id
                        ? Colors.grey[600]
                        : Colors.grey[400],
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 270),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        message.author.id != viewModel.user?.id
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  message.author.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              )
                            : const SizedBox.shrink(),
                        const Expanded(child: SizedBox.shrink()),
                        Text(
                          viewModel.user != null
                              ? DateFormat("H:mm dd.MM.yy")
                                  .format(
                                      DateTime.parse(message.created).toLocal())
                                  .toString()
                              : "",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    if (message.author.id == viewModel.user?.id) 
                    Container(
                        alignment: AlignmentDirectional.topEnd,
                        width: 270,
                        child: message.state
                            ? const Icon(Icons.done_all_outlined, size: 20,)
                            : const SizedBox.shrink())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
