import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/schedule_item.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';

class BookingsScreen extends StatefulWidget {
  final ScheduleItem schedule;

  const BookingsScreen({Key? key, required this.schedule}) : super(key: key);

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
    try {
      final apiService = ApiService(
          baseUrl: 'http://localhost:3000'); // Adjust baseUrl as needed
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

    final timeAndClass =
        '${widget.schedule.timeCls} - ${widget.schedule.timeClsEnd} - ${widget.schedule.className}';
    final roomAndTrainer = 'Room: ${widget.schedule.roomName ?? 'N/A'}\n'
        'Trainer: ${widget.schedule.teacher1 ?? 'N/A'}'
        '${widget.schedule.teacher2 != null ? ', ${widget.schedule.teacher2}' : ''}';
    final studioName = widget.schedule.studioName;
    final mapInfo = 'Mat: $totalBooked/${widget.schedule.totalMap}';

    // Define variables for header display
    final timeStr =
        '${widget.schedule.timeCls} - ${widget.schedule.timeClsEnd}';
    final className = widget.schedule.className;
    final roomName = widget.schedule.roomName ?? 'N/A';
    final trainerName = '${widget.schedule.teacher1 ?? 'N/A'}'
        '${widget.schedule.teacher2 != null ? ', ${widget.schedule.teacher2}' : ''}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // ===== Sticky header (info forward) =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
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
                        _legendDot(color: Color.fromARGB(255, 106, 15, 15)),
                        const SizedBox(width: 6),
                        const Text('Selected',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== Scrollable content =====
          Padding(
            padding: const EdgeInsets.only(
                top: 140), // Sesuaikan dengan tinggi header + legend
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Loading indicator =====
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    // ===== List kursi dengan tombol Konfirmasi per-item =====
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: seats.length,
                      itemBuilder: (context, index) {
                        final seat = seats[index];
                        final bool isSelected = selectedSeatId == seat.id;

                        final Color tileBorder = isSelected
                            ? theme.colorScheme.primary
                            : isDark
                                ? Colors.grey[700]!
                                : Colors.grey.shade300;

                        final Color tileColor = isSelected
                            ? theme.colorScheme.primary.withOpacity(0.10)
                            : isDark
                                ? Colors.grey[800]!
                                : Colors.grey.shade100;

                        final Color seatIconColor = !seat.isAvailable
                            ? Colors.red
                            : isSelected
                                ? theme.colorScheme.primary
                                : Colors.green;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: tileBorder, width: 1.2),
                            ),
                            tileColor: tileColor,
                            leading: SvgPicture.asset(
                              'assets/icons/mat.svg',
                              width: 30,
                              height: 30,

                            ),

                            title: Text(
                              'Mat ${seat.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : isDark
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              seat.isAvailable ? 'Available' : 'Booked',
                              style: TextStyle(
                                color: seat.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Tombol Konfirmasi muncul hanya saat kursi ini dipilih
                            trailing: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: isSelected
                                  ? SizedBox(
                                      key: ValueKey('confirm_${seat.id}'),
                                      width: 150,
                                      child: ElevatedButton.icon(
                                        onPressed: _onConfirmPressed,
                                        icon: const Icon(Icons.check_circle,
                                            size: 18),
                                        label: const Text(
                                          'Confirm',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      key: ValueKey('spacer'),
                                      width: 0,
                                      height: 0,
                                    ),
                            ),
                            onTap: () {
                              if (!seat.isAvailable) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Kursi ini tidak tersedia. Silakan pilih kursi lain.'),
                                  ),
                                );
                                return;
                              }
                              setState(() => selectedSeatId = seat.id);
                            },
                          ),
                        );
                      },
                    ),
                ],
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
        const SnackBar(content: Text('Silakan pilih kursi terlebih dahulu.')),
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
              _dialogRow('Waktu & Kelas', timeAndClass),
              const SizedBox(height: 8),
              _dialogRow('Room & Trainer', roomAndTrainer),
              const SizedBox(height: 8),
              _dialogRow('Studio', studioName),
              const SizedBox(height: 8),
              _dialogRow('Kursi', selectedSeatId ?? '-'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking berhasil divalidasi!')),
                );
                Navigator.of(context).pop(); // kembali ke screen sebelumnya
              },
              child: const Text('Yes'),
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
}

// Model kursi sederhana (dummy)
class _Seat {
  final String id;
  final bool isAvailable;
  _Seat(this.id, this.isAvailable);
}
