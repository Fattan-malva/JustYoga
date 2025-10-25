import 'package:flutter/material.dart';
import 'package:gymbooking/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/studio.dart';
import '../../services/api_service.dart';

/// Reusable layout (dulu namanya FindStudioScreen Stateful)
class FindStudioLayout extends StatefulWidget {
  final Widget headerContent;
  final Widget bodyContent;
  final Color? headerBackgroundColor;
  final double? headerHeight;
  final bool showBackButton;

  const FindStudioLayout({
    Key? key,
    required this.headerContent,
    required this.bodyContent,
    this.headerBackgroundColor,
    this.headerHeight,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<FindStudioLayout> createState() => _FindStudioLayoutState();
}

class _FindStudioLayoutState extends State<FindStudioLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor =
        widget.headerBackgroundColor ?? theme.colorScheme.primary;
    final double headerH = widget.headerHeight ?? 310.0;
    final double overlap = 50.0; // jarak overlap antara header dan body

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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

/// Screen (Stateful) yang menggunakan FindStudioLayout
class FindStudioScreen extends StatefulWidget {
  static const routeName = '/find-studio';

  const FindStudioScreen({Key? key}) : super(key: key);

  @override
  _FindStudioScreenState createState() => _FindStudioScreenState();
}

class _FindStudioScreenState extends State<FindStudioScreen> {
  List<Studio> studios = [];
  bool isLoading = false;
  String? error;

  final ApiService apiService =
      ApiService(baseUrl: 'http://192.168.234.182:3000');

  @override
  void initState() {
    super.initState();
    _fetchStudios();
  }

  Future<void> _fetchStudios() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final fetchedStudios = await apiService.fetchStudios();
      setState(() {
        studios = fetchedStudios;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, List<Studio>> _groupStudiosByCity() {
    final Map<String, List<Studio>> grouped = {};
    for (final studio in studios) {
      final city = studio.city;
      if (!grouped.containsKey(city)) {
        grouped[city] = [];
      }
      grouped[city]!.add(studio);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return FindStudioLayout(
      headerBackgroundColor: Theme.of(context).colorScheme.primary,
      headerHeight: 260,
      headerContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Find Your\nSpace',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Text(
            'Discover Just Yoga studios near you\ncalm, inspiring, and ready to welcome your practice',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(
                            child: Text(
                              'Error: $error',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : studios.isEmpty
                            ? const Center(
                                child: Text('No studios found.'),
                              )
                            : ListView(
                                children:
                                    _groupStudiosByCity().entries.map((entry) {
                                  final city = entry.key;
                                  final cityStudios = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // === JUDUL KOTA + GARIS ===
                                      Text(
                                        city,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        height: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 20),

                                      // === LIST STUDIO ===
                                      ...cityStudios.map((studio) => Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Card(
                                              elevation: 3,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: IntrinsicHeight(
                                                  // 👈 penting biar tinggi otomatis sejajar
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      // === GAMBAR MAP ===
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          'assets/icons/studios.png',
                                                          width: 120,
                                                          height:
                                                              120, // lebar fix
                                                          fit: BoxFit
                                                              .cover, // isi penuh tinggi card
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),

                                                      // === TEKS DAN TOMBOL ===
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              studio.name,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 6),
                                                            Text(
                                                              studio.address,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey[600],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.3,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height:
                                                                    6), // dorong tombol ke bawah
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  final Uri
                                                                      url =
                                                                      Uri.parse(
                                                                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(studio.address)}');
                                                                  if (await canLaunchUrl(
                                                                      url)) {
                                                                    await launchUrl(
                                                                        url);
                                                                  } else {
                                                                    // Handle error, maybe show a snackbar
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Could not open maps')),
                                                                    );
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .primary,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .location_on_outlined,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                    SizedBox(
                                                                        width:
                                                                            6),
                                                                    Text(
                                                                      'Maps',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }).toList(),
                              )),
          ],
        ),
      ),
    );
  }
}
