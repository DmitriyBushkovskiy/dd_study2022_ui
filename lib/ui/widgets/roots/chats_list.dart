import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();

  _ViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;

  User? get user => _user;

  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        body: ListView.builder(itemBuilder: (context, index) {
          return ChatPreview(index);
        }));
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

  const ChatPreview(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Container(
      //height: 106,
      color: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 86,
        padding: EdgeInsets.all(10),
        //color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 33,
              backgroundColor: Colors.black,
              child: (viewModel.user != null && viewModel.headers != null)
                  ? CircleAvatar(
                      radius: 32,
                      backgroundImage: viewModel.user == null
                          ? null
                          : NetworkImage(
                              "$baseUrl${viewModel.user!.avatarLink}",
                              headers: viewModel.headers),
                    )
                  : null,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //color: Colors.yellow,
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Name ${index.toString()}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "О выводе российских войск с Украины до конца года «не может быть и речи», заявил пресс-секретарь президента России Дмитрий Песков, передает корреспондент РБК.",
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
              child: viewModel.user != null
                  ? Text(
                      DateFormat("dd.MM.yyyy")
                          .format(DateTime.parse(viewModel.user!.birthDate)
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
