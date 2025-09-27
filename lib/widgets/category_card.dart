import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  CategoryCard({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
