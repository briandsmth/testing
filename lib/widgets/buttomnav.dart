import 'package:flutter/material.dart';
import 'package:mini_app/method/auth_method.dart';
import 'package:mini_app/screens/add_task.dart';
import 'package:mini_app/screens/home.dart';
import 'package:mini_app/widgets/button_login.dart';

class ButtomBar extends StatefulWidget {
  ButtomBar({Key? key}) : super(key: key);

  @override
  State<ButtomBar> createState() => _ButtomBarState();
}

class _ButtomBarState extends State<ButtomBar> {
  int _page = 0;
  double iconBarWidth = 42;
  double iconBorderWidth = 5;

  List<Widget> pages = [
    HomeScreen(),
    AddTask(),
    Center(
      child: Button(text: 'Sign Out', onPress: AuthMethod().signOut),
    ),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                width: iconBarWidth,
                child: const Icon(
                  Icons.list_outlined,
                ),
              ),
              label: 'Task'),
          BottomNavigationBarItem(
              icon: Container(
                width: iconBarWidth,
                child: const Icon(
                  Icons.add_box_rounded,
                  size: 50,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Container(
                width: iconBarWidth,
                child: const Icon(
                  Icons.settings,
                ),
              ),
              label: 'Settings'),
        ],
      ),
    );
  }
}
