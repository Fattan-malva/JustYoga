import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';
import '../../models/schedule_item.dart';
import '../../models/studio.dart';
import '../../services/api_service.dart';

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

  List<Studio> studios = [];
  Studio? selectedStudio;
  bool isLoadingStudios = false;
  String? studioError;

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
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final dateStr = '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
      List<ScheduleItem> fetchedSchedules;
      if (selectedStudio != null) {
        fetchedSchedules = await apiService.fetchSchedulesByDateAndStudio(
            dateStr, selectedStudio!.studioID);
      } else {
        fetchedSchedules = await apiService.fetchSchedulesByDate(dateStr);
      }
      setState(() {
        schedules = fetchedSchedules;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        schedules = [];
      });
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
          if (isLoadingStudios)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (studioError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Text(
                  'Error loading studios: $studioError',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<Studio>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Select Studio',
                  border: OutlineInputBorder(),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Schedule for ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Text(
                          'Error: $error',
                          style: TextStyle(color: Colors.red),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: schedules.length,
                            itemBuilder: (_, i) {
                              final s = schedules[i];
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
                                    child: Icon(Icons.schedule,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    '${s.timeCls} - ${s.className}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${s.studioName}\nTrainer: ${s.teacher1}' +
                                        (s.teacher2 != null
                                            ? ', ${s.teacher2}'
                                            : ''),
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
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
