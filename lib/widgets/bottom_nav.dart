import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../constants/colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: AppColors.primary,
        ),
        SalomonBottomBarItem(
          icon: const Icon(FontAwesomeIcons.calendar),
          title: const Text("Schedule"),
          selectedColor: AppColors.primary,
        ),
        SalomonBottomBarItem(
          icon: const Icon(FontAwesomeIcons.checkCircle),
          title: const Text("Booked"),
          selectedColor: AppColors.primary,
        ),
        SalomonBottomBarItem(
          icon: const Icon(FontAwesomeIcons.idCard),
          title: const Text("Membership"),
          selectedColor: AppColors.primary,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          selectedColor: AppColors.primary,
        ),
      ],
    );
  }
}
