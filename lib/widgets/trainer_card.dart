import 'package:flutter/material.dart';

class TrainerCard extends StatelessWidget {
  final String name;
  final String avatar;
  final VoidCallback? onTap;

  TrainerCard({required this.name, required this.avatar, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 36, backgroundImage: NetworkImage(avatar)),
          SizedBox(height: 8),
          Text(name),
        ],
      ),
    );
  }
}
