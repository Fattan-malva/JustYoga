import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/classes_provider.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classesProv = Provider.of<ClassesProvider>(context);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadwal Kelas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: classesProv.classes.length,
              itemBuilder: (_, i) {
                final c = classesProv.classes[i];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.fitness_center)),
                    title: Text(c.title),
                    subtitle: Text('Trainer: ${c.trainerId}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
