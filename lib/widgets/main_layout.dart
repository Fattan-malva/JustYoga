import 'package:flutter/material.dart';
import 'package:gymbooking/screens/pages/list_bookings_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav.dart';
import '../screens/pages/home_screen.dart';
import '../screens/pages/schedule_screen.dart';
import '../screens/pages/findStudio_screen.dart';
import '../screens/pages/list_bookings_screen.dart';
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
    FindStudioScreen(),
    ListBookingsScreen(),
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    const double appBarHeight = 60;

    return Scaffold(
      extendBodyBehindAppBar: true, // biar body bisa di bawah AppBar tanpa celah
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ===== BODY =====
          Container(
            margin: const EdgeInsets.only(top: appBarHeight - 22), 
            // dikurangi sedikit biar body “menyatu” pas di bawah rounded AppBar
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: _pages,
            ),
          ),

          // ===== APPBAR =====
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Container(
              height: appBarHeight,
              color: Theme.of(context).colorScheme.primary,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    const SizedBox(width: 6),
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
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hi, ${user?.name?.split(' ').first ?? 'Guest'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return IconButton(
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => themeProvider.toggleTheme(),
                          tooltip: themeProvider.isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
