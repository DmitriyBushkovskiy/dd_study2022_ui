import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
import 'package:dd_study2022_ui/ui/widgets/post/create_post_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/auth.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chat.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats_list.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/loader.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/account/account.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/registration/registration_widget.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const createPost = "/createPost";
  static const registerUser = "/registerUser";
  static const chatsList = "/chatsList";
  static const chat = "/chat";
  // static const account = "/account";
  static const profile = "/profile";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return await key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static Future toAuth() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static Future toHome() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static Future toCreatePostPage() async {
    return await key.currentState?.pushNamed(NavigationRoutes.createPost);
  }

  static Future toChatsList() async {
    return await key.currentState?.pushNamed(NavigationRoutes.chatsList);
  }

  static Future toChat() async {
    return await key.currentState?.pushNamed(NavigationRoutes.chat);
  }

  // static Future toAccount() async {
  //   return await key.currentState?.pushNamed(NavigationRoutes.account);
  // }
  static Future toProfile(String userId) async {
    return await key.currentState?.pushNamed(NavigationRoutes.profile, arguments: userId);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoaderWidget.create());

      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => Auth.create());

      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => App.create());

      case NavigationRoutes.createPost:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => CreatePostWidget.create());

      case NavigationRoutes.chatsList:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ChatsList.create(),
          transitionsBuilder: (_, a, __, c) => SlideTransition(
              position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                  .animate(a),
              child: c),
        );

      case NavigationRoutes.chat:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => Chat.create(),
          transitionsBuilder: (_, a, __, c) => SlideTransition(
              position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                  .animate(a),
              child: c),
        );

      // case NavigationRoutes.profile:
      // final arguments = (ModalRoute.of(context)?.settings.arguments) as String;
      //   return PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => ProfileWidget.create(arg: arguments));

      // case NavigationRoutes.account:
      //   return PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => AccountWidget.create());
    }
    return null;
  }
}
