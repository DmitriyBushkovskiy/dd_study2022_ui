import 'dart:io';

import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/account/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();

  final BuildContext context;
  ProfileViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      avatar = appmodel.avatar;
    });
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

  Map<String, String>? headers;

  String? _imagePath;

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    userProfile = await _api.getUserProfile();

    // avatar = (user!.avatarLink == null)
    //     ? Image.asset("assets/images/sadgram-logo.gif")
    //     : Image.network(
    //         "$baseUrl${user!.avatarLink}",
    //         key: ValueKey(const Uuid().v4()),
    //         fit: BoxFit.cover,
    //       );
  }

  Future changePhoto() async {
    var appModel = context.read<AppViewModel>();
    await Navigator.of(context).push(MaterialPageRoute(
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

    var user = await _api.getUser();
    _syncService.syncUser(); //TODO:check it
    
    var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
        .load("$baseUrl${user.avatarLink}?v=1");
    appModel.avatar = Image.memory(
      img.buffer.asUint8List(), fit: BoxFit.cover,);

  }

  bool colorAvatar = false;

  void changeAvatarColor() {
    colorAvatar = !colorAvatar;
    notifyListeners();
  }

  String tapChecker = "tapChecker";

  void changeText(String value) {
    tapChecker = value;
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

      void toAccount() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => AccountWidget.create()));
  }
}
