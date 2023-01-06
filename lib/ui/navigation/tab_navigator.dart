import 'package:dd_study2022_ui/domain/enums/tab_item.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/post_detail/post_detail.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/account/account_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/relations/relations_widget.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/app/';
  static const String postDetails = "/app/postDetails";
  static const String account = "/app/account";
  static const String relations = "/app/relations";
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItemEnum tabItem;
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
          {Object? arg}) =>
      {
        TabNavigatorRoutes.root: (context) =>
            TabEnums.tabRoots[tabItem] ??
            SafeArea(
              child: Text(tabItem.name),
            ),
        TabNavigatorRoutes.postDetails: (context) => PostDetail.create(arg),
        TabNavigatorRoutes.account: (context) => AccountWidget.create(),
        TabNavigatorRoutes.relations: (context) => RelationsWidget.create(arg),
      };

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        var rb = _routeBuilders(context, arg: settings.arguments);
        if (rb.containsKey(settings.name)) {
          return MaterialPageRoute(
              builder: (context) => rb[settings.name]!(context));
        }
        return null;
      },
    );
  }
}
