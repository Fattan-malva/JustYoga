import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';

import '../../models/justme_item.dart';
import '../../models/studio.dart';
import '../../services/api_service.dart';

/// Reusable layout (dulu namanya PrivateSessionScreen Stateful)
class PrivateSessionLayout extends StatefulWidget {
  final Widget headerContent;
  final Widget bodyContent;
  final Color? headerBackgroundColor;
  final double? headerHeight;
  final bool showBackButton;

  const PrivateSessionLayout({
    Key? key,
    required this.headerContent,
    required this.bodyContent,
    this.headerBackgroundColor,
    this.headerHeight,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<PrivateSessionLayout> createState() => _PrivateSessionLayoutState();
}

class _PrivateSessionLayoutState extends State<PrivateSessionLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor =
        widget.headerBackgroundColor ?? theme.colorScheme.primary;
    final double headerH = widget.headerHeight ?? 310.0;
    final double overlap = 150.0; // jarak overlap antara header dan body

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: widget.showBackButton
          ? AppBar(
              backgroundColor: headerColor,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0,
            )
          : null,
      body: Stack(
        children: [
          // Sticky Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: headerH,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: headerColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: widget.headerContent,
              ),
            ),
          ),

          // Body with rounded top corners
          Positioned.fill(
            top: headerH - overlap,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: widget.bodyContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivateSessionScreen extends StatefulWidget {
  static const routeName = '/private_session';

  const PrivateSessionScreen({Key? key}) : super(key: key);

  @override
  _PrivateSessionScreenState createState() => _PrivateSessionScreenState();
}

class _PrivateSessionScreenState extends State<PrivateSessionScreen> {
  DateTime selectedDate = DateTime.now();

  final DateTime firstDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

  List<JustMeItem> justmeItems = [];
  bool isLoading = false;
  String? error;
  String? noJustMeMessage;

  List<Studio> studios = [];
  Studio? selectedStudio;
  bool isLoadingStudios = false;
  String? studioError;

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
      _fetchJustMe();
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
      _fetchJustMe();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStudios();
    _fetchJustMe();
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

  Future<void> _fetchJustMe() async {
    setState(() {
      isLoading = true;
      error = null;
      noJustMeMessage = null;
    });
    try {
      final dateStr = '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
      List<JustMeItem> fetchedItems;
      if (selectedStudio != null) {
        fetchedItems = await apiService.fetchJustMeByDateAndStudio(
            dateStr, selectedStudio!.studioID.toString());
      } else {
        fetchedItems = await apiService.fetchJustMeByDate(dateStr);
      }
      setState(() {
        justmeItems = fetchedItems;
        noJustMeMessage = null;
      });
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('No justme found')) {
        setState(() {
          noJustMeMessage = errorMsg.replaceFirst('Exception: ', '');
          justmeItems = [];
        });
      } else {
        setState(() {
          error = errorMsg.replaceFirst('Exception: ', '');
          justmeItems = [];
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrivateSessionLayout(
      headerBackgroundColor: Theme.of(context).colorScheme.primary,
      headerHeight: 500, // increased to accommodate calendar and dropdown
      headerContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Book Your\nPrivate Session',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Text(
            'A one-on-one session with a professional teacher,\nfully personalized to your body’s needs and goals',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 20),
                onPressed: _goToPreviousMonth,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              Text(
                '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right,
                    color: Colors.white, size: 20),
                onPressed: _goToNextMonth,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(0.9),
              ),
              child: CalendarSlider(
                key: ValueKey(selectedDate),
                initialDate: selectedDate,
                firstDate: firstDate,
                lastDate: lastDate,
                locale: 'en',
                monthYearTextColor: Colors.transparent,
                monthYearButtonBackgroundColor: Colors.transparent,
                selectedDateColor: const Color(0xFFFFD700),
                selectedTileBackgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                selectedTileHeight: 60,
                tileHeight: 50,
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                  _fetchJustMe();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          isLoadingStudios
              ? const Center(child: CircularProgressIndicator())
              : studioError != null
                  ? Center(
                      child: Text(
                        'Error: $studioError',
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : DropdownButtonFormField<Studio>(
                      isExpanded: true,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black87
                            : Colors.black87,
                      ),
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[200]
                              : Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        labelText: selectedStudio == null ? 'Studio' : null,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[600]
                              : Colors.grey[700],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: selectedStudio != null
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    size: 18, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    selectedStudio = null;
                                  });
                                  _fetchJustMe();
                                },
                                padding: const EdgeInsets.all(4),
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                      ),
                      value: selectedStudio,
                      items: studios.map((studio) {
                        return DropdownMenuItem<Studio>(
                          value: studio,
                          child: Text(
                            '${studio.name} - ${studio.address}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Studio? newValue) {
                        setState(() {
                          selectedStudio = newValue;
                        });
                        _fetchJustMe();
                      },
                    ),
        ],
      ),

      bodyContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : noJustMeMessage != null
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
                              noJustMeMessage!,
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
                        : justmeItems.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada just me pada tanggal ini.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: justmeItems.length,
                                itemBuilder: (_, i) {
                                  final item = justmeItems[i];
                                  final timeRange =
                                      '${item.timeFrom} - ${item.timeTo}';

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
                                                    radius: 10,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    child: const Icon(
                                                      Icons.schedule,
                                                      color: Colors.white,
                                                      size: 12,
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
                                                ],
                                              ),

                                              const SizedBox(height: 2),

                                              // Trainer
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.school_rounded,
                                                    size: 15,
                                                    color: Colors.redAccent,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      item.employeeName,
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

                                        // Area kanan atas: chip studio
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
                                                    size: 12),
                                                const SizedBox(width: 4),
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 120),
                                                  child: Text(
                                                    item.studioName,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
