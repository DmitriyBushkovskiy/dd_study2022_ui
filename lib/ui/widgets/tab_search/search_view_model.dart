import 'dart:async';

import 'package:dd_study2022_ui/domain/models/search_users_request.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final lvc = ScrollController();
  var searchTec = TextEditingController();
  Timer? countDownTimer;

  void startTimer() {
    countDownTimer = Timer(
      const Duration(seconds: 1),
      sendQuery,
    );
  }

  final BuildContext context;
  SearchViewModel({
    required this.context,
  }) {
    asyncInit();
    searchTec.addListener(() {
      if (countDownTimer != null) {
        countDownTimer!.cancel();
      }
      startTimer();
    });

    lvc.addListener(() {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!isLoading) {
          isLoading = true;
          var newUsersList = <User>[];
          _authService
              .searchUsers(SearchUserRequest(
                username: searchTec.text,
                skip: users!.length,
                take: 10,
              ))
              .then((value) => newUsersList = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            users = <User>[...users!, ...newUsersList];
            isLoading = false;
          });
        }
      }
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool val) {
    _isSearching = val;
    notifyListeners();
  }

  String _searchField = "";
  String get searchField => _searchField;
  set searchField(String val) {
    _searchField = val;
    notifyListeners();
  }

  List<User>? _users;
  List<User>? get users => _users;
  set users(List<User>? val) {
    _users = val;
    notifyListeners();
  }

  void showSearchField() {
    isSearching = true;
  }

  void hideSearchField() {
    isSearching = false;
    searchTec.clear();
  }

  void sendQuery() async {
    users = await _authService.searchUsers(
        SearchUserRequest(username: searchTec.text, skip: 0, take: 10));
  }

  void asyncInit() async {
    users = await _authService.searchUsers(
        SearchUserRequest(username: searchField, skip: 0, take: 10));
  }

  void toProfile(BuildContext bc, String userId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (__) => ProfileWidget.create(bc: bc, arg: userId)));
  }
}