import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _currentPage = 0;

  // Data slide: title menggunakan '\n' supaya jadi dua baris seperti contoh
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Find Serenity in\nEvery Movement',
      'subtitle':
          'Embrace harmony of body and mind through thoughtfully designed yoga sessions for every level',
      'bg': const Color(0xFF5A5A5A), // abu gelap mirip contoh pertama
    },
    {
      'title': 'Your Yoga,\nYour Schedule',
      'subtitle':
          'Book classes that fit your lifestyle from energizing morning flows to soothing evening sessions',
      'bg': const Color(0xFFF7D6A1), // krem / peach
    },
    {
      'title': 'Grow with\nExpert Guidance',
      'subtitle':
          'Experience personal growth with one-on-one consultations and private sessions led by professional yoga teachers',
      'bg': const Color(0xFF9F0D0D), // merah gelap
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pc.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pc.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // supaya konten fullscreen dan aman di notch
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pc,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return _buildPage(
                  title: page['title'],
                  subtitle: page['subtitle'],
                  bgColor: page['bg'],
                  isLast: index == _pages.length - 1,
                );
              },
            ),

            // Top row: icon left, skip right
            Positioned(
              left: 20,
              right: 20,
              top: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon image kiri atas
                  Image.asset(
                    'assets/icons/JYicon.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                  ),

                  // Skip (tap -> goto login)
                  GestureDetector(
                    onTap: _skip,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom controls: back / dots / next or start
            Positioned(
              left: 20,
              right: 20,
              bottom: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row navigasi (kiri arrow, spacer, right/start)
                  Row(
                    children: [
                      // Back button (hanya tampil kalau currentPage > 0)
                      if (_currentPage > 0)
                        _circleIconButton(
                          icon: Icons.arrow_back,
                          onTap: _prevPage,
                        )
                      else
                        // agar spacing konsisten ketika tidak ada back, tampilkan placeholder kecil
                        const SizedBox(width: 56),

                      const Spacer(),

                      // Next or Start Now (slide terakhir -> Start Now style)
                      if (_currentPage < _pages.length - 1)
                        _circleIconButton(
                          icon: Icons.arrow_forward,
                          onTap: _nextPage,
                        )
                      else
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            // background color menyesuaikan, gunakan warna kontras
                          ),
                          child: const Text('Start Now'),
                        ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final bool active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: active ? 12 : 8,
                        height: active ? 12 : 8,
                        decoration: BoxDecoration(
                          color: active ? _indicatorColor(context, _pages[_currentPage]['bg']) : _mutedDotColor(context),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: build each page content
  Widget _buildPage({
    required String title,
    required String subtitle,
    required Color bgColor,
    required bool isLast,
  }) {
    // Warna teks disesuaikan dengan kecerahan background
    final bool isLightBg = bgColor.computeLuminance() > 0.5;
    final Color titleColor = isLightBg ? Colors.black : Colors.white;
    final Color subtitleColor = isLightBg ? Colors.black54 : Colors.white70;

    return Container(
      color: bgColor,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        children: [
          // spacer atas untuk membuat title berada di bagian bawah kiri (seperti contoh)
          const Spacer(flex: 3),

          // Title & subtitle aligned to start (left) and not centered horizontally
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 36,
                    height: 1.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // agar ada ruang di bawah sebelum kontrol bottom
          const Spacer(flex: 4),
        ],
      ),
    );
  }

  // Small helper untuk circle outlined icon button
  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white.withOpacity(0.9)),
        ),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }

  // warna dot aktif -> kalau background gelap: putih; kalau light: hitam
  Color _indicatorColor(BuildContext context, Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  // warna dot non aktif
  Color _mutedDotColor(BuildContext context) {
    return Colors.grey.shade400;
  }
}
