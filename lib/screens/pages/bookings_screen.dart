import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_item.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';

class BookingsScreen extends StatefulWidget {
  final ScheduleItem schedule;
  final DateTime selectedDate;

  const BookingsScreen(
      {Key? key, required this.schedule, required this.selectedDate})
      : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<_Seat> seats = [];
  bool isLoading = true;
  String? selectedSeatId;
  int totalBooked = 0;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => isLoading = true);
    try {
      final apiService = ApiService(baseUrl: 'http://localhost:3000');
      final bookings =
          await apiService.fetchBookingsByUniqCode(widget.schedule.uniqCode);
      final takenSeats = bookings.map((b) => b.classMapNumber).toSet();

      setState(() {
        seats = List.generate(widget.schedule.totalMap, (index) {
          final seatNumber = index + 1;
          return _Seat(seatNumber.toString(), !takenSeats.contains(seatNumber));
        });
        totalBooked = takenSeats.length;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        seats = List.generate(widget.schedule.totalMap, (index) {
          final seatNumber = index + 1;
          return _Seat(seatNumber.toString(), true);
        });
        totalBooked = 0;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = const Color.fromARGB(255, 67, 4, 27);

    final timeStr =
        '${widget.schedule.timeCls} - ${widget.schedule.timeClsEnd}';
    final className = widget.schedule.className;
    final roomName = widget.schedule.roomName ?? 'N/A';
    final trainerName = '${widget.schedule.teacher1 ?? 'N/A'}'
        '${widget.schedule.teacher2 != null ? ', ${widget.schedule.teacher2}' : ''}';
    final studioName = widget.schedule.studioName;
    final mapInfo = 'Mat: $totalBooked/${widget.schedule.totalMap}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // ===== Sticky header =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Find Your Space',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Discover Just Yoga studios near you',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'calm, inspiring, and ready to welcome your practice',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ======== Header Keterangan Statis ========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          'Time & Class',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Room & Teacher',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Studio & Map',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ======== Baris Data Dinamis ========
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kolom 1: Time & Class
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.schedule,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              className,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kolom 2: Room & Trainer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.meeting_room,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  roomName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trainerName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kolom 3: Studio & Map
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    studioName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mapInfo,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ===== Legend (Available / Booked / Selected) =====
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _legendDot(color: Colors.green),
                        const SizedBox(width: 6),
                        const Text('Available',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 16),
                        _legendDot(color: Colors.red),
                        const SizedBox(width: 6),
                        const Text('Booked',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 16),
                        _legendDot(color: selectedColor),
                        const SizedBox(width: 6),
                        const Text('Selected',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ===== Body dengan border radius =====
          Positioned.fill(
            top: 210,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Loading indicator =====
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        // ===== Grid View untuk kursi dengan card yang rapat =====
                        GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 1.8,
                          ),
                          itemCount: seats.length,
                          itemBuilder: (context, index) {
                            final seat = seats[index];
                            final bool isSelected = selectedSeatId == seat.id;

                            final String status;
                            final Color statusColor;
                            if (isSelected) {
                              status = 'Selected';
                              statusColor =
                                  const Color.fromARGB(255, 67, 4, 27);
                            } else if (seat.isAvailable) {
                              status = 'Available';
                              statusColor = Colors.green;
                            } else {
                              status = 'Booked';
                              statusColor = Colors.red;
                            }

                            final Color tileColor = isSelected
                                ? theme.colorScheme.primary.withOpacity(0.10)
                                : isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey.shade100;

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: tileColor,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  if (!seat.isAvailable) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Mat tidak tersedia'),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() => selectedSeatId = seat.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Baris pertama: Icon dan Nomor Mat dengan font BESAR
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/mat.svg',
                                            width: 22,
                                            height: 22,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              'Mat ${seat.id}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isSelected
                                                    ? theme.colorScheme.primary
                                                    : isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),

                                      // Baris kedua: Status dengan font BESAR
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            status,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Tombol Confirm (diperbaiki ukurannya)
                                      if (isSelected) ...[
                                        const SizedBox(height: 6),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: 100, // ← LEBAR DIPERKECIL
                                            child: ElevatedButton(
                                              onPressed: _onConfirmPressed,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    theme.colorScheme.primary,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      12, // ← DIPERKECIL
                                                  vertical: 8, // ← DITINGGIKAN
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                minimumSize: const Size(0,
                                                    36), // ← TINGGI DITAMBAH (dari 28)
                                              ),
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Helpers UI =====
  Widget _legendDot({required Color color}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black12),
      ),
    );
  }

  // ===== Logic konfirmasi =====
  void _onConfirmPressed() {
    if (selectedSeatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih mat terlebih dahulu.')),
      );
      return;
    }
    _showConfirmDialog();
  }

  void _showConfirmDialog() {
    final timeAndClass =
        '${widget.schedule.timeCls} - ${widget.schedule.className}';
    final roomAndTrainer = 'Room: ${widget.schedule.roomName ?? 'N/A'}\n'
        'Trainer: ${widget.schedule.teacher1 ?? 'N/A'}'
        '${widget.schedule.teacher2 != null ? ', ${widget.schedule.teacher2}' : ''}';
    final studioName = widget.schedule.studioName;
    final dateStr =
        '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogRow('Tanggal', dateStr),
              const SizedBox(height: 8),
              _dialogRow('Waktu & Kelas', timeAndClass),
              const SizedBox(height: 8),
              _dialogRow('Room & Trainer', roomAndTrainer),
              const SizedBox(height: 8),
              _dialogRow('Studio', studioName),
              const SizedBox(height: 8),
              _dialogRow('Mat', selectedSeatId ?? '-'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _createBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Konfirmasi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogRow(String title, String value) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
        children: [
          TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Future<void> _createBooking() async {
    if (selectedSeatId == null) return;

    setState(() => isLoading = true);

    try {
      final apiService = ApiService(baseUrl: 'http://localhost:3000');
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final user = auth.user;

      final booking = BookingItem(
        studioID: (widget.schedule.studioID ?? 0).toString(),
        roomType: widget.schedule.roomType ?? 0,
        classID: widget.schedule.classID ?? 0,
        classBookingDate: DateTime(widget.selectedDate.year,
            widget.selectedDate.month, widget.selectedDate.day),
        classBookingTime: widget.schedule.timeCls,
        customerID: user?.customerID ?? "",
        contractID: user?.lastContractID ?? "",
        accessCardNumber: 0,
        isActive: true,
        isRelease: false,
        isConfirm: false,
        classMapNumber: int.parse(selectedSeatId!),
        createby: "000",
        createdate: DateTime.now(),
      );

      final response = await apiService.createBooking(booking);

      final message = response['message'] ?? 'Tidak ada pesan dari server';
      final success = response['success'] ?? false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (success) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}

// Model kursi sederhana (dummy)
class _Seat {
  final String id;
  final bool isAvailable;
  _Seat(this.id, this.isAvailable);
}
