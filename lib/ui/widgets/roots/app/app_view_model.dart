import 'package:dd_study2022_ui/domain/enums/tab_item.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;

  var _currentTab = TabEnums.defTab;
  TabItemEnum? beforeTab;
  TabItemEnum get currentTab => _currentTab;
  void selectTab(TabItemEnum tabItemEnum) {
    if (tabItemEnum == _currentTab) {
      navigationKeys[tabItemEnum]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      beforeTab = _currentTab;
      _currentTab = tabItemEnum;
      notifyListeners();
    }
  }

  final navigationKeys = {
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.newPost: GlobalKey<NavigatorState>(),
    TabItemEnum.favorites: GlobalKey<NavigatorState>(),
    TabItemEnum.profile: GlobalKey<NavigatorState>(),
  };

  AppViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    if (user!.avatarLink != null) {
      Image.network(
        "$baseUrl${user!.avatarLink}",
        key: ValueKey(const Uuid().v4()),
        fit: BoxFit.cover,
      );
    }
  }
}