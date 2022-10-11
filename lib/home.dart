import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_sum/constants/theme_data.dart';
import 'package:recipe_sum/controllers/search_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Home extends GetView<StateController> {
  Home({Key? key}) : super(key: key);

  List<Widget> _buildScreens() {
    return [
      Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: SingleChildScrollView(
            child: Container(
          child: Text('123'),
          color: Colors.red,
        )),
      ),
      Container()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  final TextEditingController _searchController = TextEditingController();
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(StateController());
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Container(
            margin: const EdgeInsetsDirectional.all(24),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  storeController.setSearching(false);
                } else {
                  storeController.setSearching(true);
                }
              },
              style: TextStyle(color: black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Obx(() => Visibility(
                    visible: storeController.searching.value,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => {
                        storeController.setSearching(false),
                        searchController.clear()
                      },
                    ))),
                filled: true,
                fillColor: white,
                focusedBorder: whiteBorder,
                enabledBorder: whiteBorder,
                hintText: 'Search Recipe',
              ),
            ),
          ),
          SingleChildScrollView(
            child: Row(children: [
              for (var i = 0; i < 5; ++i)
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.red,
                )
            ]),
          )
        ],
      ))),
    );
    // PersistentTabView(
    //   context,
    //   controller: _controller,
    //   screens: _buildScreens(),
    //   items: _navBarsItems(),
    //   confineInSafeArea: true,
    //   backgroundColor: Colors.white, // Default is Colors.white.
    //   handleAndroidBackButtonPress: true, // Default is true.
    //   resizeToAvoidBottomInset:
    //       true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
    //   stateManagement: true, // Default is true.
    //   hideNavigationBarWhenKeyboardShows:
    //       true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
    //   decoration: NavBarDecoration(
    //     borderRadius: BorderRadius.circular(10.0),
    //     colorBehindNavBar: Colors.white,
    //   ),
    //   popAllScreensOnTapOfSelectedTab: true,
    //   popActionScreens: PopActionScreensType.all,
    //   itemAnimationProperties: ItemAnimationProperties(
    //     // Navigation Bar's items animation properties.
    //     duration: Duration(milliseconds: 200),
    //     curve: Curves.ease,
    //   ),
    //   screenTransitionAnimation: ScreenTransitionAnimation(
    //     // Screen transition animation on change of selected tab.
    //     animateTabTransition: true,
    //     curve: Curves.ease,
    //     duration: Duration(milliseconds: 200),
    //   ),
    //   navBarStyle:
    //       NavBarStyle.style1, // Choose the nav bar style with this property.
    // );
  }
}
