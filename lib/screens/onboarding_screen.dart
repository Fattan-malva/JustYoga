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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pc,
                children: [
                  _buildPage(title: 'Temukan kelas favorit', subtitle: 'Yoga, HIIT, Strength dan lainnya', icon: Icons.search),
                  _buildPage(title: 'Booking mudah & cepat', subtitle: 'Pesan kelas hanya dengan beberapa ketukan', icon: Icons.calendar_today),
                  _buildPage(title: 'Pelatih profesional', subtitle: 'Latih bersama pelatih berpengalaman', icon: Icons.person),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: AppColors.primary),
                child: Text('Mulai'),
                onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String subtitle, required IconData icon}) {
    return Padding(
      padding: EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 92, color: AppColors.primary),
          SizedBox(height: 28),
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          SizedBox(height: 12),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
