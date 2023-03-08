import 'dart:convert';

import 'package:dd_study2022_ui/domain/enums/tab_item.dart';
import 'package:dd_study2022_ui/domain/models/custom_data.dart';
import 'package:dd_study2022_ui/internal/utils.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chats/chat_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/services/database.dart';
import '../firebase_options.dart';
import '../ui/navigation/app_navigator.dart';

void showModal(
  String title,
  String content,
) {
  var ctx = AppNavigator.key.currentContext;
  if (ctx != null) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("got it"))
          ],
        );
      },
    );
  }
}

void catchMessage(RemoteMessage message) {
  "Got a message whilst in the foreground!".console();
  'Message data: ${message.data}'.console();

  var r = message.data.values.first as String;
  final body = json.decode(r);
  var chatId = body['commandArg'];
  // var ctx2 = AppNavigator.key.currentContext;

  // var ctx = AppNavigator.navigationKeys[TabItemEnum.home]?.currentContext;

  // if (ctx != null) {
  //   var appviewModel = ctx.read<AppViewModel>();
  //   // Navigator.of(ctx)
  //   //     .pushNamed(TabNavigatorRoutes.postDetails, arguments: post);
  //   appviewModel.selectTab(TabItemEnum.home);
  // }
  //var ctx = AppNavigator.key.currentContext;
  // var appModel = ctx?.read<AppViewModel>();
  //var av = appModel!.avatar;
  AppNavigator.toChat(chatId);
  if (message.notification != null) {
    //showModal(message.notification!.title!, message.notification!.body!);
    var rr = 1;
    //var ctx = AppNavigator.
    // var ctx = AppNavigator.navigationKeys[TabItemEnum.home]?.currentContext;
    // if (ctx != null) {
    //   var appviewModel = ctx.read<AppViewModel>();
    //   Navigator.of(ctx)
    //       .pushNamed(TabNavigatorRoutes.postDetails, arguments: post);
    //   appviewModel.selectTab(TabItemEnum.home);
    // }
  }
}

Future Foo(RemoteMessage message) async {
  var r = 1;
}

Future initFareBase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  FirebaseMessaging.onMessage.listen(catchMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(catchMessage); //TODO
  try {
    ((await messaging.getToken()) ?? "no token").console();
  } catch (e) {
    e.toString().console();
  }
}

Future initApp() async {
  await initFareBase();
  await DB.instance.init();
}
