import 'package:flutter/material.dart';
import '../models/gym_class.dart';
import '../services/dummy_data.dart';

class ClassesProvider extends ChangeNotifier {
  List<GymClass> _classes = demoClasses;
  List<GymClass> get classes => _classes;

  List<GymClass> search(String q) {
    if (q.isEmpty) return _classes;
    return _classes.where((c) => c.title.toLowerCase().contains(q.toLowerCase())).toList();
  }

  GymClass? findById(String id) => _classes.firstWhere((c) => c.id == id, orElse: () => _classes.first);
}
