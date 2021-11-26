import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/screens/faavorite_screen/favorite.dart';
import 'package:moviedb/screens/home_screen/home_screen.dart';
import 'package:moviedb/screens/search_screen/search_screen.dart';

import 'home_screen/bloc/fetch_home_bloc.dart';

class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late PersistentTabController _controller;

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) => FetchHomeBloc(),
      child: HomeScreen(),
    ),
    SearchPage(),
    ActivityTab(),
  ];
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 24,
        icon: Icon(
          Icons.home,
        ),
        activeColorPrimary: Colors.cyanAccent,
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 24,
        icon: Icon(
          Icons.search,
        ),
        activeColorPrimary: Colors.cyanAccent,
        title: ("Search"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        icon: Icon(
          Icons.favorite,
        ),
        iconSize: 24,
        activeColorPrimary: Colors.cyanAccent,
        title: ("Activity"),
      ),
      // PersistentBottomNavBarItem(
      //   inactiveColorPrimary: Colors.grey,
      //   icon: Icon(
      //     Icons.list,
      //   ),
      //   iconSize: 24,
      //   activeColorPrimary: Colors.cyanAccent,
      //   title: ("More"),
      // ),
    ];
  }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
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
        backgroundColor: Colors.black,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
