import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), () {
      setState(() => _opacity = 1.0);
    });
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Image.asset(
              'assets/icons/JYicon.png',
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            ),
              SizedBox(height: 12),
              Text('Just Yoga', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
