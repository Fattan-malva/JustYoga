import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/booking_list_item.dart';

class ListBookingsScreen extends StatefulWidget {
  @override
  _ListBookingsScreenState createState() => _ListBookingsScreenState();
}

class _ListBookingsScreenState extends State<ListBookingsScreen> {
  late Future<List<BookingListItem>> _bookingsFuture;
  final ApiService _apiService = ApiService(baseUrl: 'http://localhost:3000');

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;
    if (user != null && user.customerID != null) {
      _bookingsFuture = _apiService.fetchBookingsByCustomerId(user.customerID!);
    } else {
      _bookingsFuture = Future.value([]);
    }
  }

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

  // Function untuk format tanggal
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? theme.colorScheme.background : Colors.grey.shade50,
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
                  child: Icon(Icons.card_membership,
                      color: isDark ? theme.colorScheme.primary : Colors.blue),
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
                      color: isDark
                          ? Colors.green.shade300
                          : Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<BookingListItem>>(
                future: _bookingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading bookings: ${snapshot.error}',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No bookings found',
                        style: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    );
                  } else {
                    final bookings = snapshot.data!;
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return _buildBookingCard(booking, context);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingListItem booking, BuildContext context) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.className,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatDate(booking.classBookingDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status, context)
                        .withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(booking.status, context)
                          .withOpacity(isDark ? 0.4 : 0.3),
                    ),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: _getStatusColor(booking.status, context),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompactDetailRow(
                          'Studio', booking.studioName, context),
                      SizedBox(height: 16),
                      _buildCompactDetailRow(
                          'Trainer',
                          booking.teacher1Name.isNotEmpty
                              ? booking.teacher1Name
                              : 'N/A',
                          context),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                // Kolom kanan - Time, Room, dan Mat Number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompactDetailRow(
                          'Time',
                          '${booking.classBookingTime} - ${booking.timeClsEnd}',
                          context),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactDetailRow(
                                'Room', booking.roomName, context),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildCompactDetailRow('Mat',
                                'Mat ${booking.classMapNumber}', context),
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

  Widget _buildCompactDetailRow(
      String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
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
    );
  }
}
