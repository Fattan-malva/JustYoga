import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';

import '../../models/schedule_item.dart';
import '../../models/studio.dart';
import '../../models/room_type.dart';
import '../../services/api_service.dart';
import '../pages/bookings_screen.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  final DateTime firstDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

  List<ScheduleItem> schedules = [];
  bool isLoading = false;
  String? error;
  String? noScheduleMessage;

  List<Studio> studios = [];
  Studio? selectedStudio;
  bool isLoadingStudios = false;
  String? studioError;

  List<RoomType> roomTypes = [];
  RoomType? selectedRoomType;
  bool isLoadingRoomTypes = false;
  String? roomTypeError;

  final ApiService apiService = ApiService(baseUrl: 'http://localhost:3000');
  // Catatan: Untuk Flutter web, pastikan API backend enable CORS.

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
      _fetchSchedules();
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
      _fetchSchedules();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStudios();
    _fetchRoomTypes();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      isLoading = true;
      error = null;
      noScheduleMessage = null;
    });
    try {
      final dateStr = '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
      List<ScheduleItem> fetchedSchedules;
      if (selectedStudio != null && selectedRoomType != null) {
        fetchedSchedules = await apiService.fetchSchedules(
          dateStr,
          studioID: selectedStudio!.studioID,
          roomType: selectedRoomType!.roomType,
        );
      } else if (selectedStudio != null) {
        fetchedSchedules = await apiService.fetchSchedulesByDateAndStudio(
            dateStr, selectedStudio!.studioID);
      } else if (selectedRoomType != null) {
        fetchedSchedules = await apiService.fetchSchedulesByDateAndRoomType(
            dateStr, selectedRoomType!.roomType);
      } else {
        fetchedSchedules = await apiService.fetchSchedulesByDate(dateStr);
      }
      setState(() {
        schedules = fetchedSchedules;
        noScheduleMessage = null;
      });
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('No schedule found')) {
        setState(() {
          noScheduleMessage = errorMsg.replaceFirst('Exception: ', '');
          schedules = [];
        });
      } else {
        setState(() {
          error = errorMsg.replaceFirst('Exception: ', '');
          schedules = [];
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchStudios() async {
    setState(() {
      isLoadingStudios = true;
      studioError = null;
    });
    try {
      final fetchedStudios = await apiService.fetchStudios();
      setState(() {
        studios = fetchedStudios;
      });
    } catch (e) {
      setState(() {
        studioError = e.toString();
      });
    } finally {
      setState(() {
        isLoadingStudios = false;
      });
    }
  }

  Future<void> _fetchRoomTypes() async {
    setState(() {
      isLoadingRoomTypes = true;
      roomTypeError = null;
    });
    try {
      final fetchedRoomTypes = await apiService.fetchRoomTypes();
      setState(() {
        roomTypes = fetchedRoomTypes;
      });
    } catch (e) {
      setState(() {
        roomTypeError = e.toString();
      });
    } finally {
      setState(() {
        isLoadingRoomTypes = false;
      });
    }
  }

  Color getRoomColor(String? roomName) {
    switch (roomName?.toUpperCase()) {
      case 'JADE':
        return Colors.amber.shade50;
      case 'RUBY':
        return Colors.purple.shade50;
      case 'SAPPHIRE JADE':
        return Colors.blue.shade50;
      case 'SAPPHIRE RUBY':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50; // default jika tidak cocok
    }
  }

  Color getRoomTextColor(String? roomName) {
    switch (roomName?.toUpperCase()) {
      case 'JADE':
        return Colors.amber.shade900;
      case 'RUBY':
        return Colors.purple.shade800;
      case 'SAPPHIRE JADE':
        return Colors.blue.shade800;
      case 'SAPPHIRE RUBY':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 4,
            backgroundColor: theme.colorScheme.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _goToPreviousMonth,
                ),
                Text(
                  '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SizedBox(
                  height: 80,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(0.85),
                    ),
                    child: CalendarSlider(
                      initialDate: selectedDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      locale: 'en',
                      monthYearTextColor: Colors.transparent,
                      monthYearButtonBackgroundColor: Colors.transparent,
                      selectedDateColor: const Color(0xFFFFD700),
                      selectedTileBackgroundColor:
                          theme.primaryColor.withOpacity(0.1),
                      selectedTileHeight: 60,
                      tileHeight: 50,
                      onDateSelected: (date) {
                        setState(() => selectedDate = date);
                        _fetchSchedules();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // === DROPDOWN STUDIO ===
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 8, top: 8, bottom: 4),
                  child: isLoadingStudios
                      ? const Center(child: CircularProgressIndicator())
                      : studioError != null
                          ? Center(
                              child: Text(
                                'Error loading studios: $studioError',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            )
                          : DropdownButtonFormField<Studio>(
                              isExpanded: true,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.1,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              dropdownColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Studio',
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                suffixIcon: selectedStudio != null
                                    ? IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            selectedStudio = null;
                                          });
                                          _fetchSchedules();
                                        },
                                      )
                                    : const Icon(Icons.arrow_drop_down),
                              ),
                              value: selectedStudio,
                              items: studios.map((studio) {
                                return DropdownMenuItem<Studio>(
                                  value: studio,
                                  child: Text(
                                    '${studio.name} - ${studio.address}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.1,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Studio? newValue) {
                                setState(() {
                                  selectedStudio = newValue;
                                });
                                _fetchSchedules();
                              },
                            ),
                ),
              ),

              // === DROPDOWN ROOM TYPE ===
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 16, top: 8, bottom: 4),
                  child: isLoadingRoomTypes
                      ? const Center(child: CircularProgressIndicator())
                      : roomTypeError != null
                          ? Center(
                              child: Text(
                                'Error loading room types: $roomTypeError',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            )
                          : DropdownButtonFormField<RoomType>(
                              isExpanded: true,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.1,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              dropdownColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Room',
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                prefixIcon: Icon(
                                  Icons.meeting_room,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                suffixIcon: selectedRoomType != null
                                    ? IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            selectedRoomType = null;
                                          });
                                          _fetchSchedules();
                                        },
                                      )
                                    : const Icon(Icons.arrow_drop_down),
                              ),
                              value: selectedRoomType,
                              items: roomTypes.map((roomType) {
                                return DropdownMenuItem<RoomType>(
                                  value: roomType,
                                  child: Text(
                                    roomType.roomName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.1,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (RoomType? newValue) {
                                setState(() {
                                  selectedRoomType = newValue;
                                });
                                _fetchSchedules();
                              },
                            ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Reguler Class for ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : noScheduleMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 64,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              noScheduleMessage!,
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied,
                                  size: 64,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$error',
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : schedules.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada kelas pada tanggal ini.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: schedules.length,
                                itemBuilder: (_, i) {
                                  final s = schedules[i];
                                  final timeRange =
                                      '${s.timeCls} - ${s.timeClsEnd ?? 'N/A'}';
                                  final trainer =
                                      'Trainer: ${s.teacher1 ?? 'N/A'}'
                                      '${s.teacher2 != null ? ', ${s.teacher2}' : ''}';

                                  // VALIDASI TOMBOL BOOKING
                                  bool isDisabled = false;
                                  // try {
                                  //   final timeParts = s.timeCls.split(':');
                                  //   final hour = int.parse(timeParts[0]);
                                  //   final minute = int.parse(timeParts[1]);
                                  //   final classStart = DateTime(
                                  //     selectedDate.year,
                                  //     selectedDate.month,
                                  //     selectedDate.day,
                                  //     hour,
                                  //     minute,
                                  //   );
                                  //   isDisabled =
                                  //       classStart.isBefore(DateTime.now());
                                  // } catch (e) {
                                  //   // If parsing fails, assume not disabled
                                  //   isDisabled = false;
                                  // }

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Jam
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius:
                                                        10, // 🔹 default = 20, jadi ini lebih kecil
                                                    backgroundColor: theme
                                                        .colorScheme.primary,
                                                    child: const Icon(
                                                      Icons.schedule,
                                                      color: Colors.white,
                                                      size:
                                                          12, // 🔹 default = 24, kecilkan agar pas dengan radius di atas
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    timeRange,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: getRoomColor(
                                                          s.roomName),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.meeting_room,
                                                          color:
                                                              getRoomTextColor(
                                                                  s.roomName),
                                                          size: 12,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxWidth:
                                                                      100),
                                                          child: Text(
                                                            s.roomName ?? 'N/A',
                                                            style: TextStyle(
                                                              color:
                                                                  getRoomTextColor(
                                                                      s.roomName),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 2),

                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .self_improvement, // 🧘 Ikon yoga / class
                                                    size: 20,
                                                    color: Colors
                                                        .deepPurple, // atau pakai theme color
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      s.className,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),

                                              // Trainer
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .school_rounded, // 🔹 Ganti sesuai ikon yang kamu mau
                                                    size: 15,
                                                    color: Colors.redAccent,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      '${s.teacher1 ?? 'N/A'}${s.teacher2 != null ? ', ${s.teacher2}' : ''}',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                        // Area kanan atas: chip studio + room + tombol Booking
                                        Positioned(
                                          right: 12,
                                          top: 12,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Studio name
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                        size: 12),
                                                    const SizedBox(width: 4),
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 120),
                                                      child: Text(
                                                        s.studioName,
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 25),

                                              // 🔹 Tombol Booking tetap di bawah
                                              SizedBox(
                                                height: 25,
                                                child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor: isDisabled
                                                        ? Colors.grey
                                                        : theme.colorScheme
                                                            .primary,
                                                    foregroundColor: isDisabled
                                                        ? Colors.grey[600]
                                                        : Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: isDisabled
                                                      ? null
                                                      : () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  BookingsScreen(
                                                                      schedule:
                                                                          s,
                                                                      selectedDate:
                                                                          selectedDate),
                                                            ),
                                                          );
                                                        },
                                                  icon: const Icon(
                                                      Icons.shopping_bag,
                                                      size: 12),
                                                  label: const Text(
                                                    'Booking',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
