import 'package:flutter/material.dart';
import '../models/trainer.dart';
import '../services/dummy_data.dart';

class TrainerProfileScreen extends StatelessWidget {
  static const routeName = '/trainer';
  @override
  Widget build(BuildContext context) {
    final Trainer? trainer =
        ModalRoute.of(context)!.settings.arguments as Trainer?;
    final t = trainer ?? demoTrainers.first;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pelatih'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 54, backgroundImage: NetworkImage(t.avatar)),
            SizedBox(height: 12),
            Text(t.name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            SizedBox(height: 8),
            Text(t.bio),
            SizedBox(height: 12),
            Wrap(
                spacing: 8,
                children:
                    t.specialties.map((s) => Chip(label: Text(s))).toList()),
            SizedBox(height: 16),
            Text('Kelas yang diajarkan',
                style: TextStyle(fontWeight: FontWeight.w700)),
            // For demo, no dynamic mapping here.
          ],
        ),
      ),
    );
  }
}
