import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/dummy_data.dart';

class BookingProvider extends ChangeNotifier {
  List<Booking> _bookings = demoBookings;
  List<Booking> get bookings => _bookings;

  void addBooking(Booking b) {
    _bookings.add(b);
    notifyListeners();
  }

  void cancelBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
