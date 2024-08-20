import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/Cameras/camera.dart';


class MyTabBar extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int _selectedIndex = 0;
  int _selectedTabs = 0;

  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Information'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Picture'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            // Add more ListTile widgets for additional categories here
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2, // Two main tabs: Information and Picture
        child: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.pets),
                    onPressed: () {},
                  ),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Information'),
                    Tab(text: 'Picture'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Information Tab
              DefaultTabController(
                length: 1, // One tab for Information
                child: Scaffold(
                  appBar: TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Details'), // Only one tab
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      Center(
                        child: Icon(Icons.info, color: Colors.blue, size: 100),
                      ),
                    ],
                  ),
                ),
              ),
              // Picture Tab
              DefaultTabController(
                length: 5, // Five tabs for Picture
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align tabs to the start
                      children: [
                        Flexible(child: _tabBarForPicture()),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Center(
                        child: CameraWidget(),
                      ),
                      Center(
                        child:
                            Icon(Icons.image, color: Colors.green, size: 100),
                      ),
                      Center(
                        child: Icon(Icons.image, color: Colors.red, size: 100),
                      ),
                      Center(
                        child:
                            Icon(Icons.image, color: Colors.orange, size: 100),
                      ),
                      Center(
                        child:
                            Icon(Icons.image, color: Colors.purple, size: 100),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBarForPicture() {
    return TabBar(
      indicatorWeight: BorderSide.strokeAlignCenter,
      dragStartBehavior: DragStartBehavior.start,
      controller: _tabController,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      automaticIndicatorColorAdjustment: true,
      indicator: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(40),
        backgroundBlendMode: BlendMode.colorBurn,
      ),
      splashBorderRadius: BorderRadius.circular(40),
      tabs: [
        Tab(
          text: 'Camera Front',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.camera_front),
        ),
        Tab(
          text: 'Container 2',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.abc),
        ),
        Tab(
          text: 'Container 3',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.abc),
        ),
        Tab(
          text: 'Container 4',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.abc),
        ),
        Tab(
          text: 'Container 5',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.abc),
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedTabs = index;
        });
      },
    );
  }
}
