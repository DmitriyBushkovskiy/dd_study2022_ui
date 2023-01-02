import 'dart:io';

import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class AccountViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

  final BuildContext context;
  AccountViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      avatar = appmodel.avatar;
      user = appmodel.user;
    });
    //avatar = appmodel.avatar;
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;
  set userProfile(UserProfile? val) {
    _userProfile = val;
    notifyListeners();
  }

  // Map<String, String>? headers;

  String? _imagePath;

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void asyncInit() async {
    // var token = await TokenStorage.getAccessToken();
    // headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    userProfile = await _api.getUserProfile();

    var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
        .load("$baseUrl${user!.avatarLink}?v=1");
    avatar = Image.memory(
      img.buffer.asUint8List(),
      fit: BoxFit.cover,
    );
  }

  Future changePhoto() async {
    var appModel = context.read<AppViewModel>();
    await Navigator.of(AppNavigator.key.currentState!.context)
        .push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: CamWidget(
            shape: CameraShape.circle,
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);
      }
    }

    var user = await _api.getCurrentUser();
    _syncService.syncCurrentUser(); //TODO:check it

    imageCache.clear();
    imageCache.clearLiveImages();
    appModel.user = user;
    // appModel.avatar = (user!.avatarLink == null)
    //     ? Image.asset("assets/images/sadgram-logo.gif")
    //     : Image.network(
    //         "$baseUrl${user.avatarLink}",
    //         key: ValueKey(const Uuid().v4()),
    //         fit: BoxFit.cover,
    //       );


    // var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
    //     .load("$baseUrl${user.avatarLink}?v=1");
    // appModel.avatar = Image.memory(
    //   img.buffer.asUint8List(),
    //   fit: BoxFit.cover,
    // );
  }

  // bool colorAvatar = false;

  void changeAvatarColor() async {
    var newColor = await _authService.changeAvatarColor();
    user = user!.copyWith(colorAvatar: newColor);
    await _syncService.syncCurrentUser();
    var appModel = context.read<AppViewModel>();
    appModel.user = user;
    notifyListeners();
  }

  void showDatePickerProfile() {
    DateTime currentDate = DateTime.now();
    showDatePicker(
        context: context,
        initialDate:
            DateTime(currentDate.year - 14, currentDate.month, currentDate.day),
        firstDate: DateTime(1900),
        lastDate: DateTime(
            currentDate.year - 14, currentDate.month, currentDate.day));
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy");
    var viewModel = context.watch<AccountViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.user == null ? "" : viewModel.user!.username)),
      body: GestureDetector(
        //TODO: сделать листание вкладок
        onHorizontalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            //Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      viewModel.changePhoto();
                    },
                    onLongPress: () {
                      viewModel.changeAvatarColor();
                    },
                    child: UserAvatarWidget(
                      user: viewModel.user,
                      radius: 41,
                    )
                    // AvatarWidget(
                    //   colorAvatar: viewModel.user?.colorAvatar ?? true,
                    //   avatar: viewModel.avatar ??
                    //       Image.asset(
                    //         "assets/icons/default_avatar.png",
                    //         fit: BoxFit.cover,
                    //       ),
                    //   radius: 41,
                    // )
                    ),
                    Text(viewModel.user?.colorAvatar.toString() ?? ""),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Table(
                    //border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(85),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            alignment: Alignment.centerRight,
                            child: const Text("Birthday"),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: GestureDetector(
                              onTap: () {
                                viewModel.showDatePickerProfile();
                              },
                              child: viewModel.user != null
                                  //? Text(DateFormat("yyyy-MM-dd")
                                  ? Text(dtf
                                      .format(DateTime.parse(
                                              viewModel.user!.birthDate)
                                          .toLocal())
                                      .toString())
                                  : const Text("no data"),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Email"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(
                                    viewModel.userProfile?.email ?? "no data"),
                                initialValue: viewModel.userProfile?.email,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  if (isEmail(value!)) {
                                    return null;
                                  } else {
                                    return "enter Email";
                                  }
                                },
                                style: const TextStyle(fontSize: 15),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  hintText: "Email",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                showCursor: true,
                                cursorColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Phone"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(
                                    viewModel.userProfile?.phone ?? "no data"),
                                initialValue: viewModel.userProfile?.phone,
                                style: const TextStyle(fontSize: 15),
                                //maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  hintText: "Phone",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                showCursor: true,
                                cursorColor: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Full Name"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(viewModel.userProfile?.fullName ??
                                    "no data"),
                                initialValue: viewModel.userProfile?.fullName,
                                style: const TextStyle(fontSize: 15),
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  hintText: "enter your name",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                showCursor: true,
                                cursorColor: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Bio"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                focusNode: FocusNode(),
                                key: Key(
                                    viewModel.userProfile?.bio ?? "no data"),
                                initialValue: viewModel.userProfile?.bio,
                                style: const TextStyle(fontSize: 15),
                                maxLength: 200,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                showCursor: true,
                                cursorColor: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                if (viewModel.userProfile != null)
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        if (viewModel.userProfile != null)
                          CheckboxListTile(
                            contentPadding: const EdgeInsets.only(left: 0),
                            title: const Text(
                              "Private Account",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: viewModel.user!.privateAccount,
                            onChanged: ((value) {}),
                          ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: viewModel.changePhoto,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.black)))),
                  child: const Text("Save changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) => AccountViewModel(context: context),
      child: const AccountWidget(),
    );
  }
}
