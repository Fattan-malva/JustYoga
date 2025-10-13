# TODO: Update Booking Screen for Dynamic Seats

- [x] Update ScheduleItem.dart to include totalMap (int) and uniqCode (String)
- [x] Create BookingItem.dart model with fields from the API response (studioID, ClassMapNumber, etc.)
- [x] Update ApiService.dart to add fetchBookingsByUniqCode method
- [x] Modify BookingsScreen.dart: Add state for seats, fetch bookings in initState, generate seats, update UI to display uniqCode
