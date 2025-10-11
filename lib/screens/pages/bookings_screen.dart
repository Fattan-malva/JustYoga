import 'package:flutter/material.dart';
import '../../models/schedule_item.dart';

class BookingsScreen extends StatefulWidget {
  final ScheduleItem schedule;

  const BookingsScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // Dummy seat data: true = available, false = taken
  final List<_Seat> seats = [
    _Seat('A1', true),
    _Seat('A2', false),
    _Seat('A3', true),
    _Seat('A4', false),
    _Seat('A5', true),
    _Seat('A6', true),
    _Seat('B1', false),
    _Seat('B2', true),
    _Seat('B3', true),
    _Seat('B4', false),
    _Seat('B5', true),
    _Seat('B6', true),
  ];

  String? selectedSeatId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timeAndClass = '${widget.schedule.timeCls} - ${widget.schedule.className}';
    final roomAndTrainer = 'Room: ${widget.schedule.roomName ?? 'N/A'}\n'
        'Trainer: ${widget.schedule.teacher1 ?? 'N/A'}'
        '${widget.schedule.teacher2 != null ? ', ${widget.schedule.teacher2}' : ''}';
    final studioName = widget.schedule.studioName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: Stack(
        children: [
          // ===== Scrollable content (berjarak dari header sticky) =====
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Legend
                  Row(
                    children: [
                      _legendDot(color: Colors.green),
                      const SizedBox(width: 6),
                      const Text('Kosong'),
                      const SizedBox(width: 16),
                      _legendDot(color: Colors.red),
                      const SizedBox(width: 6),
                      const Text('Terisi'),
                      const SizedBox(width: 16),
                      _legendDot(color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      const Text('Dipilih'),
                    ],
                  ),
                  const SizedBox(height: 12),

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
                          : Colors.grey.shade300;

                      final Color tileColor = isSelected
                          ? theme.colorScheme.primary.withOpacity(0.10)
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
                          leading: Icon(Icons.event_seat, color: seatIconColor),
                          title: Text(
                            'Kursi ${seat.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            seat.isAvailable ? 'Kosong' : 'Terisi',
                            style: TextStyle(
                              color: seat.isAvailable ? Colors.green : Colors.red,
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
                                      onPressed: _onConfirmPressed, // gunakan selectedSeatId
                                      icon: const Icon(Icons.check_circle, size: 18),
                                      label: const Text(
                                        'Konfirmasi',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
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
                                  content: Text('Kursi ini tidak tersedia. Silakan pilih kursi lain.'),
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

          // ===== Sticky header (info forward) =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _infoBlock('Waktu & Nama Kelas', timeAndClass)),
                  const SizedBox(width: 12),
                  Expanded(child: _infoBlock('Nama Room & Trainer', roomAndTrainer)),
                  const SizedBox(width: 12),
                  Expanded(child: _infoBlock('Nama Studio', studioName)),
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

  Widget _infoBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
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
    final timeAndClass = '${widget.schedule.timeCls} - ${widget.schedule.className}';
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
          TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
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
