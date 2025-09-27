import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gym_class.dart';
import '../constants/colors.dart';

class ClassCard extends StatelessWidget {
  final GymClass gymClass;
  final VoidCallback? onTap;

  ClassCard({required this.gymClass, this.onTap});

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(gymClass.price * 1000);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'class_${gymClass.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(gymClass.image, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gymClass.title, style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Icon(Icons.star, size: 14, color: Colors.amber), SizedBox(width: 6), Text(gymClass.rating.toString())]),
                      Text(price, style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
