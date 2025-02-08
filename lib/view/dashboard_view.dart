import 'package:Smart_Attendance/core/config.dart';
import 'package:Smart_Attendance/view/attendance_view.dart';
import 'package:Smart_Attendance/view/home_view.dart';
import 'package:Smart_Attendance/view/notification_page.dart';
import 'package:Smart_Attendance/view/settings_page.dart';
import 'package:flutter/material.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  int bottomNavIndex = 0;
  final GlobalKey<HomePageViewState> homePageKey =
      GlobalKey<HomePageViewState>();

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    if (index == 0 && !Config.getFirstLoad()) {
      homePageKey.currentState?.injectHomeButtonScript();

      setState(() {
        bottomNavIndex = 0;
      });

      return;
    }

    if (index == 4) {
      setState(() {
        bottomNavIndex = index;
      });

      homePageKey.currentState?.injectProfileButtonScript();

      return;
    }

    setState(() {
      bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: bottomNavIndex == 4 ? 0 : bottomNavIndex,
        children: [
          HomePageView(
            key: homePageKey,
            tempUrl: "${Config.getHomeUrl()}/dashboard",
            goingTO: Config.getFirstLoad() ? '' : 'home',
          ),
          WebAttendanceView(
            selectedIndex: bottomNavIndex,
          ),
          const NotificationsPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: onTabTapped,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: bottomNavIndex,
      ),
    );
  }
}
