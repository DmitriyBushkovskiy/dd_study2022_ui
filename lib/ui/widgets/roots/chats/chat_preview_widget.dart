import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chats_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPreview extends StatelessWidget {
  final int index;
  final ChatModel chat;

  const ChatPreview(this.index, {Key? key, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatsListViewModel>();
    return 
      Container(
        height: 86,
        color: Colors.grey,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chat.isPrivate
                ? UserAvatarWidget(
                    user: chat.participants.firstWhere(
                        (element) => element.id != viewModel.user?.id),
                    radius: 33)
                : const SizedBox.shrink(),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //color: Colors.yellow,
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      chat.isPrivate
                          ? chat.participants
                              .firstWhere(
                                  (element) => element.id != viewModel.user?.id)
                              .username
                          : chat.name ?? "Group chat",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      chat.lastMessage?.text ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: chat.lastMessage != null
                  ? Text(
                      DateFormat("H:mm dd.MM.yy")
                          .format(DateTime.parse(chat.lastMessage!.created)
                              .toLocal()
                              )
                          .toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        //backgroundColor: Colors.red,
                      ),
                    )
                  : const Text(""),
            ),
          ],
        ),
    );
  }
}