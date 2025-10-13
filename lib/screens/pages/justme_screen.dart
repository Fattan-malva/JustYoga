import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';
import '../../models/schedule_item.dart';
import '../../models/studio.dart';
import '../../models/room_type.dart';
import '../../services/api_service.dart';

class JustMeScreen extends StatefulWidget {
  @override
  _JustMeScreenState createState() => _JustMeScreenState();
}

class _JustMeScreenState extends State<JustMeScreen> {
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
  // Note: For Flutter web, ensure your backend API has CORS enabled (e.g., app.use(cors()) in Express).
  // Alternatively, run the app on an Android/iOS emulator or device, where localhost works without CORS issues.

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

  @override
  Widget build(BuildContext context) {
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
          preferredSize: Size.fromHeight(100),
          child: SizedBox(
            height: 100,
            child: CalendarSlider(
              initialDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              locale: 'en',
              monthYearTextColor: Colors.transparent,
              monthYearButtonBackgroundColor: Colors.transparent,
              selectedDateColor: Color(0xFFFFD700),
              selectedTileBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              tileHeight: 70,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                _fetchSchedules();
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 8, top: 16, bottom: 8),
                  child: isLoadingStudios
                      ? Center(child: CircularProgressIndicator())
                      : studioError != null
                          ? Center(
                              child: Text(
                                'Error loading studios: $studioError',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : DropdownButtonFormField<Studio>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Studio',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              value: selectedStudio,
                              items: studios.map((studio) {
                                return DropdownMenuItem<Studio>(
                                  value: studio,
                                  child: Text(
                                    '${studio.name} - ${studio.address}',
                                    overflow: TextOverflow.ellipsis,
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
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 16, top: 16, bottom: 8),
                  child: isLoadingRoomTypes
                      ? Center(child: CircularProgressIndicator())
                      : roomTypeError != null
                          ? Center(
                              child: Text(
                                'Error loading room types: $roomTypeError',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : DropdownButtonFormField<RoomType>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Room',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.meeting_room),
                              ),
                              value: selectedRoomType,
                              items: roomTypes.map((roomType) {
                                return DropdownMenuItem<RoomType>(
                                  value: roomType,
                                  child: Text(
                                    '${roomType.roomName}',
                                    overflow: TextOverflow.ellipsis,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Just Me Class for ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
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
                            SizedBox(height: 16),
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
                                SizedBox(height: 16),
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
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: schedules.length,
                                itemBuilder: (_, i) {
                                  final s = schedules[i];
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
                                              // Judul Kelas & Jam
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    child: Icon(Icons.schedule,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      '${s.timeCls} - ${s.className}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),

                                              // Detail Room & Trainer
                                              Text(
                                                'Room: ${s.roomName ?? 'N/A'}\nTrainer: ${s.teacher1 ?? 'N/A'}' +
                                                    (s.teacher2 != null
                                                        ? ', ${s.teacher2}'
                                                        : ''),
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Lokasi di kanan atas
                                        Positioned(
                                          right: 12,
                                          top: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.location_on,
                                                    color: Colors.red,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  s.studioName,
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
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
