import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Find Your Ideal Trainer',
      'subtitle':
          'Explore professional trainer profiles with specializations that match your fitness goals.',
      'icon': Icons.person_search,
    },
    {
      'title': 'Schedule at Your Convenience',
      'subtitle':
          'Book training sessions anytime—whether in-studio or online—with your chosen trainer.',
      'icon': Icons.fact_check,
    },
    {
      'title': 'Achieve Your Fitness Goals with Experts',
      'subtitle':
          'Get personalized programs and progress tracking from experienced fitness professionals.',
      'icon': Icons.analytics,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pc.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pc,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(
                    title: page['title'],
                    subtitle: page['subtitle'],
                    icon: page['icon'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  _currentPage == _pages.length - 1
                      ? 'Start Living Healthy'
                      : 'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 92, color: AppColors.primary),
          const SizedBox(height: 28),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
