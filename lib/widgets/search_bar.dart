import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  SearchBar({required this.controller, this.onTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Theme.of(context).hintColor),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                cursorColor: const Color(0xFFFFD700), // 👉 cursor warna gold
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari kelas atau pelatih...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // default
                  enabledBorder: InputBorder.none, // saat enabled
                  focusedBorder: InputBorder.none, // saat focus
                  errorBorder: InputBorder.none, // saat error
                  disabledBorder: InputBorder.none, // saat disabled
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
