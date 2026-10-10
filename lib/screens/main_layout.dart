import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/learn_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LearnScreen(),
    const PracticeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a wide screen (desktop/web)
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              extended: MediaQuery.of(context).size.width >= 1000,
              minExtendedWidth: 200,
              selectedIconTheme: const IconThemeData(color: AppColors.teal),
              selectedLabelTextStyle: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: Text('Curriculum'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.code),
                  selectedIcon: Icon(Icons.code),
                  label: Text('Practice Lab'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile & Stats'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // The main content area
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000), // Prevent infinite stretching!
                  child: _screens[_currentIndex],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Layout
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.code),
            selectedIcon: Icon(Icons.code),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
