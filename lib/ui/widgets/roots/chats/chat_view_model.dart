import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/chat_request.dart';
import 'package:dd_study2022_ui/domain/models/create_message_model.dart';
import 'package:dd_study2022_ui/domain/models/message_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/add_users_to_group_chat_widget.dart';
import 'package:flutter/material.dart';

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
      if (current < 0 && !isUpdating) {
        isUpdating = true;
        asyncInit();
      }
      if (current >= 0.0) {
        isUpdating = false;
      }
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!isLoading) {
          isLoading = true;
          var newMessages = <MessageModel>[];
          _authService
              .getChat(ChatRequest(
                  chatId: chatId!, skip: messages!.length, take: 10))
              .then((value) => newMessages = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            messages = <MessageModel>[...messages!, ...newMessages];
            isLoading = false;
          });
        }
      }
    });
  }

  ChatModel? _chat;
  ChatModel? get chat => _chat;
  set chat(ChatModel? val) {
    _chat = val;
    notifyListeners();
  }

  bool isUpdating = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

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
    chat = await _authService.getChatData(chatId!);
  }

  void sendMessage() async {
    var newMessage = CreateMessageModel(chatId: chatId!, text: messageTec.text);
    await _authService.sendMessage(newMessage);
    messageTec.clear();
    asyncInit();
  }

  void addUsersToGroupChat() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddUsersToGroupChatWidget.create(arg: chatId)));
  }
}
