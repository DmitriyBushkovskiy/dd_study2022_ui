import 'package:dd_study2022_ui/domain/enums/tab_item.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomTabs extends StatelessWidget {
  final TabItemEnum currentTab;
  final ValueChanged<TabItemEnum> onSelectTab;
  const BottomTabs(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appModel = context.watch<AppViewModel>();
    return BottomNavigationBar(
      selectedFontSize: 1,
      unselectedFontSize: 1,
      //iconSize: 33,
      backgroundColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      currentIndex: TabItemEnum.values.indexOf(currentTab),
      items: TabItemEnum.values.map((e) => _buildItem(e, appModel)).toList(),
      onTap: (value) {
        FocusScope.of(context).unfocus();
        onSelectTab(TabItemEnum.values[value]);
      },
    );
  }

  BottomNavigationBarItem _buildItem(
      TabItemEnum tabItem, AppViewModel appmodel) {
    var isCurrent = currentTab == tabItem;
    var color =
        isCurrent ? const Color.fromARGB(255, 212, 212, 212) : Colors.black;
    Widget icon = Icon(
      TabEnums.tabIcon[tabItem],
      color: color,
      size: isCurrent ? 35 : 30,
    );
    if (tabItem == TabItemEnum.profile) {
      icon = AvatarWidget(
        avatar: appmodel.avatar ?? Image.asset("assets/icons/default_avatar.png", fit: BoxFit.cover,),
        radius: isCurrent ? 17 : 15,
        colorAvatar: false, // TODO: viewmodel.user
      );

      // CircleAvatar(
      //   maxRadius: isCurrent ? 17 : 15,
      //   backgroundImage: appmodel.avatar?.image,
      // );
    }
    return BottomNavigationBarItem(label: tabItem.name, icon: icon);
  }
}