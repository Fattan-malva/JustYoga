import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  CustomAppBar({this.title = '', this.trailing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (trailing != null) Padding(padding: EdgeInsets.only(right: 12), child: trailing),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
