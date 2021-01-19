import 'package:flutter/material.dart';
import 'package:govy/screens/home_screen.dart';
import 'package:govy/screens/services.dart';

import '../consttants.dart';

class MainScreen extends StatefulWidget {
  final fullName;
  MainScreen({this.fullName});
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    HomePage(),
    ServicesScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: TextStyle(fontFamily: 'Avenir'),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text(
                  'Services',
                  style: TextStyle(fontFamily: 'Avenir'),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text(
                  'Profile',
                  style: TextStyle(fontFamily: 'Avenir'),
                )),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: colorPrimary,
          onTap: _onItemTapped,
        ),
      );
}
