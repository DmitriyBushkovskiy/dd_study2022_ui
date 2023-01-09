import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:flutter/material.dart';

class ChatsListViewModel extends ChangeNotifier {
  BuildContext context;
  final lvc = ScrollController();

  final AuthService _authService = AuthService();

  ChatsListViewModel({required this.context}) {
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
          var newChats = <ChatModel>[];
          _authService
              .getChats(chats!.length, 10 )
              .then((value) => newChats = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            chats = <ChatModel>[...chats!, ...newChats];
            isLoading = false;
          });
        }
      }
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  bool isUpdating = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
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
  }
}