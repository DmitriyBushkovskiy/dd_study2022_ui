import 'dart:io';

import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();
  final AuthService _authService = AuthService();

  final BuildContext context;
  AccountViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      user = appmodel.user;
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
    _syncService.syncCurrentUser();

    imageCache.clear();
    imageCache.clearLiveImages();
    appModel.user = user;
  }

  void changeAvatarColor() async {
    var appModel = context.read<AppViewModel>();
    var newColor = await _authService.changeAvatarColor();
    user = user!.copyWith(colorAvatar: newColor);
    imageCache.clear();
    imageCache.clearLiveImages();
    appModel.user = user;
    await _syncService.syncCurrentUser();
    notifyListeners();
  }

  void showAccountDatePicker() {
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