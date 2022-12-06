import 'package:dd_study2022_ui/ui/roots/app.dart';
import 'package:dd_study2022_ui/ui/roots/auth.dart';
import 'package:dd_study2022_ui/ui/roots/loader.dart';
import 'package:dd_study2022_ui/ui/roots/profile.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/profile";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static void toAuth() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static void toProfile() {
    key.currentState?.pushNamed(NavigationRoutes.profile);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => LoaderWidget.create()));
      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Auth.create()));
      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => App.create()));
      // case NavigationRoutes.profile:
      //   return PageRouteBuilder(pageBuilder: ((_, __, ___) => Profile.create()));

              case NavigationRoutes.profile:
        return PageRouteBuilder(
    pageBuilder: (_, __, ___) => Profile.create(),
    transitionsBuilder: (_, a, __, c) => SlideTransition(position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(a), child: c));
    }
    return null;
  }
}
