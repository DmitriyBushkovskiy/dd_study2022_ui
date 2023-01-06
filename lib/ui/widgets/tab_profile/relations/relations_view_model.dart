import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/domain/models/data_by_userid_request.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';

class RelationsViewModel extends ChangeNotifier {
  final followersController = ScrollController();
  final followedController = ScrollController();
  final bannedController = ScrollController();
  final requestsController = ScrollController();

  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

  bool _followersIsLoading = false;
  bool get followersIsLoading => _followersIsLoading;
  set followersIsLoading(bool val) {
    _followersIsLoading = val;
    notifyListeners();
  }

  bool _followedIsLoading = false;
  bool get followedIsLoading => _followedIsLoading;
  set followedIsLoading(bool val) {
    _followedIsLoading = val;
    notifyListeners();
  }

  bool _bannedIsLoading = false;
  bool get bannedIsLoading => _bannedIsLoading;
  set bannedIsLoading(bool val) {
    _bannedIsLoading = val;
    notifyListeners();
  }

  bool _requestsIsLoading = false;
  bool get requestsIsLoading => _requestsIsLoading;
  set requestsIsLoading(bool val) {
    _requestsIsLoading = val;
    notifyListeners();
  }

  List<User>? _followersList;
  List<User>? get followersList => _followersList;
  set followersList(List<User>? val) {
    _followersList = val;
    notifyListeners();
  }

  List<User>? _followedList;
  List<User>? get followedList => _followedList;
  set followedList(List<User>? val) {
    _followedList = val;
    notifyListeners();
  }

  List<User>? _bannedList;
  List<User>? get bannedList => _bannedList;
  set bannedList(List<User>? val) {
    _bannedList = val;
    notifyListeners();
  }

  List<User>? _requestsList;
  List<User>? get requestsList => _requestsList;
  set requestsList(List<User>? val) {
    _requestsList = val;
    notifyListeners();
  }

  User? _targetUser;
  User? get targetUser => _targetUser;
  set targetUser(User? val) {
    _targetUser = val;
    notifyListeners();
  }

  PageController? _pageController;
  PageController? get pageController => _pageController;
  set pageController(PageController? val) {
    _pageController = val;
    notifyListeners();
  }

  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  final BuildContext context;
  String? targetUserId;
  RelationsViewModel({required this.context, required this.targetUserId}) {
    asyncInit();

    followersController.addListener(() {
      var max = followersController.position.maxScrollExtent;
      var current = followersController.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!followersIsLoading) {
          followersIsLoading = true;
          var newUsersList = <User>[];
          _authService
              .getFollowers(DataByUserIdRequest(
                userId: targetUserId!,
                skip: followersList!.length,
                take: 10,
              ))
              .then((value) => newUsersList = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            followersList = <User>[...followersList!, ...newUsersList];
            followersIsLoading = false;
          });
        }
      }
    });

    followedController.addListener(() {
      var max = followedController.position.maxScrollExtent;
      var current = followedController.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!followedIsLoading) {
          followedIsLoading = true;
          var newUsersList = <User>[];
          _authService
              .getFollowed(DataByUserIdRequest(
                userId: targetUserId!,
                skip: followedList!.length,
                take: 10,
              ))
              .then((value) => newUsersList = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            followedList = <User>[...followedList!, ...newUsersList];
            followedIsLoading = false;
          });
        }
      }
    });

    bannedController.addListener(() {
      var max = bannedController.position.maxScrollExtent;
      var current = bannedController.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!bannedIsLoading) {
          bannedIsLoading = true;
          var newUsersList = <User>[];
          _authService
              .getBanned(DataByUserIdRequest(
                userId: targetUserId!,
                skip: bannedList!.length,
                take: 10,
              ))
              .then((value) => newUsersList = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            bannedList = <User>[...bannedList!, ...newUsersList];
            bannedIsLoading = false;
          });
        }
      }
    });

    requestsController.addListener(() {
      var max = requestsController.position.maxScrollExtent;
      var current = requestsController.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!requestsIsLoading) {
          requestsIsLoading = true;
          var newUsersList = <User>[];
          _authService
              .getFollowersRequests(DataByUserIdRequest(
                userId: targetUserId!,
                skip: requestsList!.length,
                take: 10,
              ))
              .then((value) => newUsersList = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            requestsList = <User>[...requestsList!, ...newUsersList];
            requestsIsLoading = false;
          });
        }
      }
    });
  }

  void toProfile(BuildContext bc, String userId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (__) => ProfileWidget.create(bc: bc, arg: userId)));
  }

  void asyncInit() async {
    pageController = PageController(initialPage: 0);
    user = await SharedPrefs.getStoredUser();
    targetUserId ??= user!.id;
    targetUser = await _dataService.getUser(targetUserId!);
    followersList = await _authService.getFollowers(
        DataByUserIdRequest(userId: targetUserId!, skip: 0, take: 10));
    followedList = await _authService.getFollowed(
        DataByUserIdRequest(userId: targetUserId!, skip: 0, take: 10));
    bannedList = await _authService
        .getBanned(DataByUserIdRequest(userId: user!.id, skip: 0, take: 10));
    requestsList = await _authService.getFollowersRequests(
        DataByUserIdRequest(userId: user!.id, skip: 0, take: 10));
  }
}
