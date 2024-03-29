import 'package:dd_study2022_ui/domain/enums/tab_item.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_create_post/create_post_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app/app.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/auth/auth.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chats_list_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/loader/loader_widget.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const createPost = "/createPost";
  static const registerUser = "/registerUser";
  static const chatsList = "/chatsList";
  static const chat = "/chat";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static final navigationKeys = {
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.newPost: GlobalKey<NavigatorState>(),
    TabItemEnum.favorites: GlobalKey<NavigatorState>(),
    TabItemEnum.profile: GlobalKey<NavigatorState>(),
  };

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

  static Future toChat(Object? arg) async {
    return await key.currentState
        ?.pushNamed(NavigationRoutes.chat, arguments: arg);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context,
      {Object? arg}) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoaderWidget.create());

      case NavigationRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => AuthWidget.create());

      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => App.create());

      case NavigationRoutes.createPost:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => CreatePostWidget.create());

      case NavigationRoutes.chatsList:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ChatsListWidget.create(),
          transitionsBuilder: (_, a, __, c) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(a),
              child: c),
        );

      case NavigationRoutes.chat:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ChatWidget.create(arg),
          transitionsBuilder: (_, a, __, c) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(a),
              child: c),
        );
    }
    return null;
  }
}
