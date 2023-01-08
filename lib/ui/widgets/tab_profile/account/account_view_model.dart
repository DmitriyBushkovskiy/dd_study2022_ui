import 'dart:async';
import 'dart:io';

import 'package:dd_study2022_ui/domain/models/change_user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

class AccountViewModelState {
  final DateTime birthdate;
  final String email;
  final String username;
  final String? phone;
  final String? fullname;
  final String? bio;
  final bool privateAccount;
  AccountViewModelState({
    required this.birthdate,
    required this.email,
    required this.username,
    this.phone,
    this.fullname,
    this.bio,
    required this.privateAccount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountViewModelState &&
        other.birthdate == birthdate &&
        other.email == email &&
        other.username == username &&
        other.phone == phone &&
        other.fullname == fullname &&
        other.bio == bio &&
        other.privateAccount == privateAccount;
  }

  @override
  int get hashCode {
    return birthdate.hashCode ^
        email.hashCode ^
        username.hashCode ^
        phone.hashCode ^
        fullname.hashCode ^
        bio.hashCode ^
        privateAccount.hashCode;
  }

  AccountViewModelState copyWith({
    DateTime? birthdate,
    String? email,
    String? username,
    String? phone,
    String? fullname,
    String? bio,
    bool? privateAccount,
  }) {
    return AccountViewModelState(
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      privateAccount: privateAccount ?? this.privateAccount,
    );
  }
}

class AccountViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();
  final AuthService _authService = AuthService();
  var emailTec = TextEditingController();
  var usernameTec = TextEditingController();
  var phoneTec = TextEditingController();
  var fullnameTec = TextEditingController();
  var bioTec = TextEditingController();

  Timer? countDownTimer;

  void startTimer(Function() function) {
    countDownTimer = Timer(
      const Duration(microseconds: 300),
      function,
    );
  }

  void _checkEmailIsNotTaken() async {
    emailIsNotTaken = await _authService.checkEmailIsNotTaken(emailTec.text);
  }

  void _checkUsernameIsNotTaken() async {
    usernameIsNotTaken =
        await _authService.checkUsernameIsNotTaken(usernameTec.text);
  }

  final BuildContext context;
  AccountViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      user = appmodel.user;
    });

    emailTec.addListener(() {
      currentState = currentState!.copyWith(email: emailTec.text);
      if (countDownTimer != null) {
        countDownTimer!.cancel();
      }
    });
    emailTec.addListener(() => startTimer(_checkEmailIsNotTaken));

    usernameTec.addListener(() {
      currentState = currentState!.copyWith(username: usernameTec.text);
      if (countDownTimer != null) {
        countDownTimer!.cancel();
      }
    });
    usernameTec.addListener(() => startTimer(_checkUsernameIsNotTaken));

    phoneTec.addListener(() {
      currentState = currentState!.copyWith(phone: phoneTec.text);
    });

    fullnameTec.addListener(() {
      currentState = currentState!.copyWith(fullname: fullnameTec.text);
    });

    bioTec.addListener(() {
      currentState = currentState!.copyWith(bio: bioTec.text);
    });
  }

  bool validUsername = false;
  bool validEmail = false;

  bool _emailIsNotTaken = false;
  bool get emailIsNotTaken => _emailIsNotTaken;
  set emailIsNotTaken(bool val) {
    _emailIsNotTaken = val;
    notifyListeners();
  }

  bool _usernameIsNotTaken = false;
  bool get usernameIsNotTaken => _usernameIsNotTaken;
  set usernameIsNotTaken(bool val) {
    _usernameIsNotTaken = val;
    notifyListeners();
  }

  AccountViewModelState? initialState;

  AccountViewModelState? _currentState;
  AccountViewModelState? get currentState => _currentState;
  set currentState(AccountViewModelState? val) {
    _currentState = val;
    notifyListeners();
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

  void onProfileStatusChanged(bool value) {
    {
      currentState = currentState!.copyWith(privateAccount: value);
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

    initialState = AccountViewModelState(
        birthdate: DateTime.parse(user!.birthDate),
        email: userProfile!.email,
        username: user!.username,
        privateAccount: user!.privateAccount,
        phone: userProfile!.phone,
        fullname: userProfile!.fullName,
        bio: userProfile!.bio);
    _currentState = initialState!.copyWith();

    emailTec.text = currentState!.email;
    usernameTec.text = currentState!.username;
    phoneTec.text = currentState!.phone ?? "";
    fullnameTec.text = currentState!.fullname ?? "";
    bioTec.text = currentState!.bio ?? "";
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

  Future changeBirthdate() async {
    DateTime currentDate = DateTime.now();
    await showDatePicker(
            context: context,
            initialDate: DateTime(currentState!.birthdate.year,
                currentState!.birthdate.month, currentState!.birthdate.day),
            firstDate: DateTime(1900),
            lastDate: DateTime(
                currentDate.year - 14, currentDate.month, currentDate.day))
        .then(
            (value) => currentState = currentState!.copyWith(birthdate: value));
  }

  void showModal() {
    var ctx = AppNavigator.key.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            //title: Text(title),
            content: const Text("Changes saved"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        },
      );
    }
  }

  Future changeUserData() async {
    var model = ChangeUserDataModel(
        birthDate: currentState!.birthdate.toUtc(),
        email: currentState!.email,
        username: currentState!.username,
        fullName: currentState!.fullname,
        bio: currentState!.bio,
        phone: currentState!.phone,
        privateAccount: currentState!.privateAccount);
    await _authService
        .changeUserData(model)
        .then((value) => asyncInit())
        .then((value) => showModal());
  }
}