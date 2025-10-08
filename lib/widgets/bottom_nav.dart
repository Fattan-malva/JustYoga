import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isDarkMode ? Colors.red : Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          title: const Text("Home"),
          selectedColor: Colors.red,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            'assets/icons/schedule.svg',
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              isDarkMode ? Colors.red : Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          title: const Text("Schedule"),
          selectedColor: Colors.red,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            'assets/icons/just-me.svg',
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              isDarkMode ? Colors.red : Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          title: const Text("Just Me"),
          selectedColor: Colors.red,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            'assets/icons/membership.svg',
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              isDarkMode ? Colors.amber : Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          title: const Text("Membership"),
          selectedColor: Colors.amber,
        ),
      ],
    );
  }
}
