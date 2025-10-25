import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ListBookingsScreen extends StatelessWidget {
  // Data dummy untuk booking list
  final List<Map<String, String>> dummyBookings = [
    {
      'className': 'Hot Yoga Flow',
      'studio': 'Yoga Studio Central',
      'trainer': 'Sarah Johnson',
      'time': '07:00 - 08:30',
      'room': 'Room A',
      'matNumber': 'Mat 12',
      'status': 'Confirmed'
    },
    {
      'className': 'Vinyasa Power',
      'studio': 'Sunrise Yoga Studio',
      'trainer': 'Mike Chen',
      'time': '09:00 - 10:15',
      'room': 'Room B',
      'matNumber': 'Mat 08',
      'status': 'Confirmed'
    },
    {
      'className': 'Gentle Hatha',
      'studio': 'Peaceful Minds Studio',
      'trainer': 'Emma Wilson',
      'time': '14:00 - 15:00',
      'room': 'Room C',
      'matNumber': 'Mat 15',
      'status': 'Pending'
    },
    {
      'className': 'Ashtanga Primary',
      'studio': 'Yoga Studio Central',
      'trainer': 'David Lee',
      'time': '17:30 - 19:00',
      'room': 'Room A',
      'matNumber': 'Mat 05',
      'status': 'Confirmed'
    },
    {
      'className': 'Yin & Meditation',
      'studio': 'Zen Yoga Space',
      'trainer': 'Lisa Park',
      'time': '20:00 - 21:00',
      'room': 'Room D',
      'matNumber': 'Mat 11',
      'status': 'Cancelled'
    },
  ];

  // Function untuk mendapatkan warna status
  Color _getStatusColor(String status, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status.toLowerCase()) {
      case 'confirmed':
        return isDark ? Colors.green.shade300 : Colors.green;
      case 'pending':
        return isDark ? Colors.orange.shade300 : Colors.orange;
      case 'cancelled':
        return isDark ? Colors.red.shade300 : Colors.red;
      default:
        return isDark ? Colors.grey.shade400 : Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.background : Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Booking List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your upcoming and past yoga sessions',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            Card(
              elevation: isDark ? 4 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDark ? theme.cardColor : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDark 
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : Colors.blue.shade50,
                  child: Icon(
                    Icons.card_membership, 
                    color: isDark ? theme.colorScheme.primary : Colors.blue
                  ),
                ),
                title: Text(
                  'Status Membership',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  user?.name ?? 'Guest',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark 
                        ? Colors.green.shade300.withOpacity(0.3)
                        : Colors.green.shade100,
                    ),
                  ),
                  child: Text(
                    'Aktif',
                    style: TextStyle(
                      color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: dummyBookings.length,
                itemBuilder: (context, index) {
                  final booking = dummyBookings[index];
                  return _buildBookingCard(booking, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, String> booking, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Header dengan title dan status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['className']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking['status']!, context).withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(booking['status']!, context).withOpacity(isDark ? 0.4 : 0.3),
                    ),
                  ),
                  child: Text(
                    booking['status']!,
                    style: TextStyle(
                      color: _getStatusColor(booking['status']!, context),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Garis pemisah
            Divider(
              color: isDark 
                ? theme.colorScheme.outline.withOpacity(0.3)
                : Colors.grey.shade200,
              height: 1,
            ),
            SizedBox(height: 12),
            // Detail booking dalam grid 2 kolom
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom kiri - Studio dan Trainer
                Expanded(
                  child: Column(
                    children: [
                      _buildCompactDetailRow(Icons.business, 'Studio', booking['studio']!, context),
                      SizedBox(height: 12),
                      _buildCompactDetailRow(Icons.person, 'Trainer', booking['trainer']!, context),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Kolom kanan - Time, Room, dan Mat Number
                Expanded(
                  child: Column(
                    children: [
                      _buildCompactDetailRow(Icons.access_time, 'Time', booking['time']!, context),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactDetailRow(Icons.room, 'Room', booking['room']!, context),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildCompactDetailRow(Icons.weekend, 'Mat', booking['matNumber']!, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDetailRow(IconData icon, String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark 
            ? theme.colorScheme.onSurface.withOpacity(0.6)
            : Colors.grey.shade600,
        ),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark 
                    ? theme.colorScheme.onSurface.withOpacity(0.5)
                    : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}