import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gym_class.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import '../constants/colors.dart';

class ClassDetailScreen extends StatelessWidget {
  static const routeName = '/class-detail';

  @override
  Widget build(BuildContext context) {
    final GymClass gymClass =
        ModalRoute.of(context)!.settings.arguments as GymClass;
    return Scaffold(
      appBar: AppBar(
        title: Text(gymClass.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'class_${gymClass.id}',
                    child: Image.network(gymClass.image,
                        fit: BoxFit.cover, height: 200),
                  ),
                  SizedBox(height: 16),
                  Text(gymClass.description),
                  SizedBox(height: 12),
                  Text('Jadwal', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text('Senin, Rabu, Jumat • 07:00 - 08:00'),
                  SizedBox(height: 18),
                  Text('Pelatih',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=32')),
                    title: Text('Ayu Santika'),
                    subtitle: Text('Yoga, Mindfulness'),
                    onTap: () => Navigator.pushNamed(context, '/trainer',
                        arguments: null),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14)),
                      child: Text('Pesan Sekarang'),
                      onPressed: () {
                        final bookingProv = Provider.of<BookingProvider>(
                            context,
                            listen: false);
                        final b = Booking(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          classId: gymClass.id,
                          userId: 'u1',
                          date: DateTime.now().add(Duration(days: 1)),
                          status: 'booked',
                        );
                        bookingProv.addBooking(b);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Berhasil booking!')));
                        // Kembali ke main layout setelah booking
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/main', (route) => false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
