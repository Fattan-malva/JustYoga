import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final double width; // ⬅️ Tambahkan parameter agar bisa adaptif

  const CategoryCard({
    Key? key,
    required this.label,
    required this.icon,
    this.onTap,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Skala responsif berdasarkan lebar card
    final iconSize = width * 0.32;
    final fontSize = width * 0.20;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 80,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right:5),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize.clamp(7, 10),
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
