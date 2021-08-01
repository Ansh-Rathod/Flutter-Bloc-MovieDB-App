import 'package:amd/screeens/home/bloc/home_bloc.dart';
import 'package:amd/screeens/home/home.dart';
import 'package:amd/screeens/more/more_page.dart';
import 'package:amd/screeens/search_page/search_page.dart';
import 'package:amd/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bottom_nav_bar/persistent-tab-view.dart';

import 'favorite/favorite.dart';

class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomePage()),
      child: Home(),
    ),
    SearchPage(),
    ActivityTab(),
    More(),
  ];
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 26,
        textStyle: normalText.copyWith(fontSize: 10),
        icon: Icon(
          Icons.home,
        ),
        activeColorPrimary: Colors.cyanAccent,
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 28,
        icon: Icon(
          Icons.search,
        ),
        textStyle: normalText.copyWith(fontSize: 10),
        activeColorPrimary: Colors.cyanAccent,
        title: ("Search"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        icon: Icon(
          Icons.favorite,
        ),
        iconSize: 26,
        textStyle: normalText.copyWith(fontSize: 10),
        activeColorPrimary: Colors.cyanAccent,
        title: ("Activity"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        icon: Icon(
          Icons.list,
        ),
        iconSize: 26,
        textStyle: normalText.copyWith(fontSize: 10),
        activeColorPrimary: Colors.cyanAccent,
        title: ("More"),
      ),
    ];
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        this.context,
        controller: _controller,
        screens: _widgetOptions,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: scaffoldColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
