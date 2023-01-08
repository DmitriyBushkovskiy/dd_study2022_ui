import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/chat_request.dart';
import 'package:dd_study2022_ui/domain/models/create_message_model.dart';
import 'package:dd_study2022_ui/domain/models/message_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatViewModel extends ChangeNotifier {
  BuildContext context;
  final String? chatId;
  final AuthService _authService = AuthService();
  var messageTec = TextEditingController();
  final lvc = ScrollController();

  ChatViewModel({required this.context, required this.chatId}) {
    asyncInit();
    lvc.addListener(() {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
      print(current);
      if (current < 0 && !isUpdating) {
        isUpdating = true;
        asyncInit();
      }
      if (current >= 0.0) {
        isUpdating = false;
      }
      // var distanceToEnd = max - current;
      // if (distanceToEnd < 1000) {
      //   if (!isLoading) {
      //     isLoading = true;
      //     var newPosts = <PostModel>[];
      //     _authService
      //         .getPostFeed(postFeed!.last.created)
      //         .then((value) => newPosts = value);
      //     Future.delayed(const Duration(seconds: 1)).then((value) {
      //       postFeed = <PostModel>[...postFeed!, ...newPosts];
      //       isLoading = false;
      //     });
      //   }
      // }
    });
  }

  bool isUpdating = false;

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<MessageModel>? _messages;
  List<MessageModel>? get messages => _messages;
  set messages(List<MessageModel>? val) {
    _messages = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    messages = await _authService
        .getChat(ChatRequest(chatId: chatId!, skip: 0, take: 10));
    var r = 1;
  }

  void sendMessage() async {
    var newMessage = CreateMessageModel(chatId: chatId!, text: messageTec.text);
    await _authService.sendMessage(newMessage);
    messageTec.clear();
    asyncInit();
  }

  // void _logout() async {
  //   await _authService.logout().then((value) => AppNavigator.toLoader());
  // }
}

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatViewModel>();
    var itemCount = viewModel.messages?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(viewModel._user?.username ?? "no data"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: viewModel.lvc,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageWidget(
                    message: viewModel.messages![index],
                  );
                },
                reverse: true,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Colors.black,
                ),
                itemCount: itemCount,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.messageTec,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: viewModel.sendMessage, icon: Icon(Icons.send)),
                ],
              ),
            )
            //SizedBox(height: 50, width: double.infinity, child: TextField()),
          ],
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
      child: const Chat(),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final MessageModel message;

  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChatViewModel>();


    return Container(
      // height: 106,
      // color: Colors.red,
      // padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 86,
        padding: const EdgeInsets.all(10),
        //color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatarWidget(user: message.author, radius: 33),
            // CircleAvatar(
            //   radius: 33,
            //   backgroundColor: Colors.black,
            //   child: (viewModel.user != null && viewModel.headers != null)
            //       ? CircleAvatar(
            //           radius: 32,
            //           backgroundImage: viewModel.user == null
            //               ? null
            //               : NetworkImage(
            //                   "$baseUrl${viewModel.user!.avatarLink}",
            //                   headers: viewModel.headers),
            //         )
            //       : null,
            // ),
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
                      message.author.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            //Expanded(child: Container(width: double.infinity, height: 50 , color: Colors.green,)),
            Container(
              child: viewModel.user != null
                  ? Text(
                      DateFormat("H:m dd.MM.yy")
                          .format(DateTime.parse(message.created).toLocal())
                          .toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : const Text("no data"),
            ),
          ],
        ),
      ),
    );
  }
}

// class Bottom extends StatelessWidget {
//   const Bottom({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: vu,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Icon(Icons.send),
//         ],
//       ),
//     );
//   }
// }
