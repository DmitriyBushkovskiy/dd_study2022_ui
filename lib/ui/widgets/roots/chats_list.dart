import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final AuthService _authService = AuthService();

  _ViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<ChatModel>? _chats;
  List<ChatModel>? get chats => _chats;
  set chats(List<ChatModel>? val) {
    _chats = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    chats = await _authService.getChats(0, 10);
    var r = 1;
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var itemCount = viewModel.chats?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
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
      create: (BuildContext context) => _ViewModel(context: context),
      child: const ChatsList(),
    );
  }
}

class ChatPreview extends StatelessWidget {
  final int index;
  final ChatModel chat;

  const ChatPreview(this.index, {Key? key, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return GestureDetector(
      onTap: () {
        AppNavigator.toChat(chat.id);
      },
      child: Container(
        height: 86,
        color: Colors.grey,
        padding: const EdgeInsets.all( 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatarWidget(user: chat.lastMessage?.author, radius: 33),
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
                      chat.lastMessage?.author.username ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      chat.lastMessage?.text ?? "",
                      style: TextStyle(
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
            //Expanded(child: Container(width: double.infinity, height: 50 , color: Colors.green,)),
            Container(
              child: chat.lastMessage != null
                  ? Text(
                      DateFormat("H:m dd.MM.yy")
                          .format(DateTime.parse(chat.lastMessage!.created)
                              .toLocal())
                          .toString(),
                      style: TextStyle(
                        fontSize: 12,
                        //backgroundColor: Colors.red,
                      ),
                    )
                  : Text("no data"),
            ),
          ],
        ),
      ),
    );
  }
}
