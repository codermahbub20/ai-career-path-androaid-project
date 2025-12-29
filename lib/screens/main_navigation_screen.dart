import 'package:flutter/material.dart'; // <--- This was likely missing
import '../constants/app_colors.dart';
import 'home/home_screen.dart';
import 'jobs/jobs_screen.dart';
import 'learning/learning_screen.dart';
import 'profile/profile_screen.dart';
import 'skill_gap/skill_gap_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // This list must be INSIDE the class but OUTSIDE any function
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    JobsScreen(),
    SkillGapScreen(), // Using SkillGap as the middle button
    LearningScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Use try/catch or safe indexing to prevent crashes during development
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              // The center prominent button
              icon: CircleAvatar(
                  backgroundColor: AppColors.primaryGreen,
                  radius: 22,
                  child: Icon(Icons.smart_toy, color: Colors.black)),
              label: 'CareerBot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Resources',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.iconGrey,
          backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
