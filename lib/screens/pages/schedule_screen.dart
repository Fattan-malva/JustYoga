import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_slider/calendar_slider.dart';
import '../../providers/classes_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/gym_class.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  // Define first and last date for calendar bounds
  final DateTime firstDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  void _goToPreviousMonth() {
    setState(() {
      final prevMonth = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      if (prevMonth.isBefore(firstDate)) {
        selectedDate = firstDate;
      } else {
        selectedDate = prevMonth;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      final nextMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      if (nextMonth.isAfter(lastDate)) {
        selectedDate = lastDate;
      } else {
        selectedDate = nextMonth;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classesProv = Provider.of<ClassesProvider>(context);
    final bookingProv = Provider.of<BookingProvider>(context);

    // Filter bookings by selected date
    final bookingsForDate = bookingProv.bookings
        .where((b) =>
            b.date.year == selectedDate.year &&
            b.date.month == selectedDate.month &&
            b.date.day == selectedDate.day)
        .toList();

    // Get classes for the filtered bookings
    final classesForDate = bookingsForDate
        .map((b) => classesProv.findById(b.classId))
        .whereType<GymClass>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: _goToPreviousMonth,
            ),
            Text(
              '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100), // tinggi AppBar bottom
          child: SizedBox(
            height: 100, // samakan dengan preferredSize biar pas
            child: CalendarSlider(
              initialDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              locale: 'en',
              monthYearTextColor: Colors.transparent,
              monthYearButtonBackgroundColor: Colors.transparent,
              selectedDateColor: Color(0xFFFFD700), // gold
              selectedTileBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              tileHeight: 70,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Judul section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Jadwal Kelas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          /// Daftar kelas
          Expanded(
            child: classesForDate.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada kelas pada tanggal ini.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: classesForDate.length,
                    itemBuilder: (_, i) {
                      final c = classesForDate[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child:
                                Icon(Icons.fitness_center, color: Colors.white),
                          ),
                          title: Text(
                            c.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Trainer: ${c.trainerId}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: () {
                            // TODO: Arahkan ke detail kelas
                          },
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
