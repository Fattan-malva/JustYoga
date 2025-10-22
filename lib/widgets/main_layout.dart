import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav.dart';
import '../screens/pages/home_screen.dart';
import '../screens/pages/schedule_screen.dart';
import '../screens/pages/justme_screen.dart';
import '../screens/pages/membership_screen.dart';
import '../screens/pages/profile_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomeScreen(),
    ScheduleScreen(),
    JustMeScreen(),
    MembershipScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 0,
        toolbarHeight: 50, // DIKURANGI dari default (biasanya 56-64)
        title: Row(
          children: [
            const SizedBox(width: 6), // DIKURANGI dari 8
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                _pageController.animateToPage(
                  4,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: CircleAvatar(
                radius: 16, // DIKURANGI dari 18
                backgroundColor: Colors.white.withOpacity(0.15),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20, // DIKURANGI dari 22
                ),
              ),
            ),
            const SizedBox(width: 8), // DIKURANGI dari 10
            Text(
              'Hi, ${user?.name?.split(' ').first ?? 'Guest'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16, // DIKURANGI dari default
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: 22, // DIKURANGI dari default
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                padding: const EdgeInsets.all(4), // DIKURANGI
                constraints: const BoxConstraints(
                  minWidth: 36, // DIKURANGI
                  minHeight: 36, // DIKURANGI
                ),
              );
            },
          ),
          const SizedBox(width: 6), // DIKURANGI dari 8
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}