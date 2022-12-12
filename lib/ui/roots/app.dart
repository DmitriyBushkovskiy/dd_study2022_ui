import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../app_navigator.dart';

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

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leadingWidth: 200,
        leading: PopupMenuButton<_MenuValues>(
          onSelected: (value) {
            switch (value) {
              case _MenuValues.logout:
                viewModel._logout();
                break;
            }
          },
          color: Colors.grey,
          position: PopupMenuPosition.under,
          itemBuilder: (BuildContext context) => [
            // PopupMenuItem(
            //   padding: const EdgeInsets.symmetric(horizontal: 6),
            //   value: _MenuValues.refresh,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       Text("refresh"),
            //       Icon(Icons.refresh),
            //     ],
            //   ),
            // ),
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              value: _MenuValues.logout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("logout"),
                  Icon(Icons.exit_to_app),
                ],
              ),
            ),
          ],
          child: TextButton(
            onPressed: null,
            child: Row(
              children: const [
                Text(
                  'Sadgram',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: "Fontspring",
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: (viewModel.user != null && viewModel.headers != null)
                      ? CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 31,
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                              color: Colors.grey,
                              backgroundBlendMode: viewModel.user == null
                                  ? null
                                  : (viewModel.user!.colorAvatar ==1 //TODO: fix it!
                                      ? BlendMode.dstATop
                                      : BlendMode.saturation),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: viewModel.user == null
                                  ? null
                                  : NetworkImage(
                                      "$baseUrl${viewModel.user!.avatarLink}",
                                      headers: viewModel.headers),
                            ),
                          ),
                        )
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                      viewModel.user == null ? "Hi" : viewModel.user!.username),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomAppBar(),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const App(),
    );
  }
}

class AppBottomAppBar extends StatelessWidget {
  const AppBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              AppNavigator.toProfile();
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
    );
  }
}

enum _MenuValues {
  logout,
}
