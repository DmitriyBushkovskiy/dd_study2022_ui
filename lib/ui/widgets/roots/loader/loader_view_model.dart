import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

class LoaderViewModel extends ChangeNotifier {
  final _authService = AuthService();

  BuildContext context;
  LoaderViewModel({required this.context}) {
    _asyncInit();
  }

  void _asyncInit() async {
    if (await _authService.checkAuth()) {
      AppNavigator.toHome();
    } else {
      AppNavigator.toAuth();
    }
  }
}