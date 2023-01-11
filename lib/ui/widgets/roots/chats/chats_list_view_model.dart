import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

class ChatsListViewModel extends ChangeNotifier {
  BuildContext context;
  final lvc = ScrollController();
  var chatNameTec = TextEditingController();

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
              .getChats(chats!.length, 10)
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

  void toChat(String chatId) {
    AppNavigator.toChat(chatId).then((value) => asyncInit());
  }

  void createGroupChat() async {
    final AuthService _authService = AuthService();
    var result = await _authService.createGroupChat(chatNameTec.text);
    // var targetUserId = usersList[listIndex].id;
    // var result = await _authService.getIdOrCreatePrivateChat(targetUserId);
    chatNameTec.clear();
    Navigator.of(context).pop();
    AppNavigator.toChat(result);
  }

  void showModal() {
    var ctx = AppNavigator.key.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 170,
              color: Colors.grey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Enter group chat name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: chatNameTec,
                      style: const TextStyle(fontSize: 15),
                      maxLength: 30,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autovalidateMode: AutovalidateMode.always,
                      // validator: (value) {
                      //   RegExp range1 = RegExp(r'^[a-zA-Z0-9._]+$');
                      //   if (value == "") {
                      //     viewModel.validUsername = false;
                      //     return "";
                      //   } else if (range1.hasMatch(value!)) {
                      //     viewModel.validUsername = true;
                      //     return null;
                      //   } else {
                      //     viewModel.validUsername = false;
                      //     return "Wrong format!";
                      //   }
                      // },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {} //viewModel.showModal,
                            ,
                            child: const Icon(
                              Icons.question_mark_rounded,
                              color: Colors.black,
                              size: 18,
                            )),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(6),
                        //hintText: "enter username",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 212, 212, 212),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 212, 212, 212),
                          ),
                        ),
                      ),
                      showCursor: true,
                      cursorColor: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: chatNameTec.text != "" ? createGroupChat : null,
                    child: Text("Create group chat"),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
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
