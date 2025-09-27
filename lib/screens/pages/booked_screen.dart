import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import '../../providers/classes_provider.dart';

class BookedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    final classesProv = Provider.of<ClassesProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelas yang Dipesan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: bookingProv.bookings.length,
              itemBuilder: (_, i) {
                final Booking b = bookingProv.bookings[i];
                final c = classesProv.findById(b.classId);
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.fitness_center)),
                    title: Text(c?.title ?? 'Kelas'),
                    subtitle: Text('${b.date.toLocal()}'.split(' ')[0]),
                    trailing: TextButton(
                        onPressed: () => bookingProv.cancelBooking(b.id),
                        child: Text('Batal')),
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
