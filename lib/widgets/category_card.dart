import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ⬅️ Tambahkan ini

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData? icon;      // untuk Icon bawaan Material
  final String? iconPath;    // bisa file PNG/JPG/SVG
  final VoidCallback? onTap;
  final double width;

  const CategoryCard({
    Key? key,
    required this.label,
    this.icon,
    this.iconPath,
    this.onTap,
    required this.width,
  })  : assert(icon != null || iconPath != null,
            'Either icon or iconPath must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconSize = width * 0.32;
    final fontSize = width * 0.20;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildIcon() {
      // === Jika iconPath diberikan ===
      if (iconPath != null) {
        if (iconPath!.toLowerCase().endsWith('.svg')) {
          // === Gunakan flutter_svg untuk SVG ===
          return SvgPicture.asset(
            iconPath!,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.image,
              size: iconSize,
              color: colorScheme.onPrimary.withOpacity(0.5),
            ),
          );
        } else {
          // === Gunakan Image.asset untuk PNG/JPG ===
          return Image.asset(
            iconPath!,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                size: iconSize,
                color: colorScheme.onPrimary.withOpacity(0.6),
              );
            },
          );
        }
      }

      // === Jika tidak ada iconPath, pakai Icon bawaan ===
      return Icon(
        icon,
        size: iconSize,
        color: colorScheme.onPrimary,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 80,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 5),
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
            buildIcon(),
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
