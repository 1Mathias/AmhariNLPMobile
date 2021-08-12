import 'package:flutter/material.dart';
import 'package:flutter_localization_master/pages/home_page.dart';
import 'package:flutter_localization_master/pages/listtile.dart';
import 'dart:async';

import 'package:flutter_localization_master/router/route_constants.dart';
import 'package:flutter_localization_master/services/postrequest.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void dispose() {
    indexcontroller.close();
    super.dispose();
  }

  PageController pageController = PageController(initialPage: 0);
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  int index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          indexcontroller.add(index);
        },
        controller: pageController,
        children: <Widget>[
          HomePage(),
          /* Center(
            child: Text('User'),
          ), */
          PostRequest(),
          ListTileExample(),
          Center(
            child: Text('Settings'),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<Object>(
        initialData: 0,
        stream: indexcontroller.stream,
        builder: (context, snapshot) {
          int cIndex = snapshot.data as int;
          return FancyBottomNavigation(
            currentIndex: cIndex,
            items: <FancyBottomNavigationItem>[
              FancyBottomNavigationItem(
                  icon: Icon(Icons.home), title: Text('Home')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.supervised_user_circle),
                  title: Text('Service')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.person), title: Text('About Us')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.settings), title: Text('Setting')),
            ],
            onItemSelected: (int value) {
              indexcontroller.add(value);
              pageController.jumpToPage(value);
            },
          );
        },
      ),
    );
  }
}

class FancyBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final List<FancyBottomNavigationItem> items;
  final ValueChanged<int> onItemSelected;

  FancyBottomNavigation(
      {Key key,
      this.currentIndex = 0,
      this.iconSize = 24,
      this.activeColor,
      this.inactiveColor,
      this.backgroundColor,
      this.items,
      this.onItemSelected}) {
    assert(items != null);
    assert(onItemSelected != null);
  }

  @override
  _FancyBottomNavigationState createState() {
    return _FancyBottomNavigationState(
        items: items,
        backgroundColor: backgroundColor,
        currentIndex: currentIndex,
        iconSize: iconSize,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onItemSelected: onItemSelected);
  }
}

class _FancyBottomNavigationState extends State<FancyBottomNavigation> {
  final int currentIndex;
  final double iconSize;
  Color activeColor;
  Color inactiveColor;
  Color backgroundColor;
  List<FancyBottomNavigationItem> items;
  int _selectedIndex;
  ValueChanged<int> onItemSelected;

  _FancyBottomNavigationState(
      {this.items,
      this.currentIndex,
      this.activeColor,
      this.inactiveColor = Colors.black,
      this.backgroundColor,
      this.iconSize,
      this.onItemSelected}) {
    _selectedIndex = currentIndex;
  }

  Widget _buildItem(FancyBottomNavigationItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 124 : 50,
      height: double.maxFinite,
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color: isSelected ? backgroundColor : inactiveColor),
                  child: item.icon,
                ),
              ),
              isSelected
                  ? DefaultTextStyle.merge(
                      style: TextStyle(color: backgroundColor),
                      child: item.title,
                    )
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeColor =
        (activeColor == null) ? Theme.of(context).accentColor : activeColor;

    backgroundColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56,
      padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var index = items.indexOf(item);
          return GestureDetector(
            onTap: () {
              onItemSelected(index);

              setState(() {
                _selectedIndex = index;
              });
            },
            child: _buildItem(item, _selectedIndex == index),
          );
        }).toList(),
      ),
    );
  }
}

class FancyBottomNavigationItem {
  final Icon icon;
  final Text title;

  FancyBottomNavigationItem({
    this.icon,
    this.title,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
