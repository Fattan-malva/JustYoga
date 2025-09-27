import 'package:flutter/material.dart';
import '../../widgets/search_bar.dart' as custom_search;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/images/banner.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black
                        .withOpacity(0.3), // ubah opacity sesuai kebutuhan
                    BlendMode.darken, // bikin gambar jadi lebih gelap
                  ),
                ),
              ),
            ),
          ),

          // Logo
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "assets/icons/logo.png",
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Search Bar
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: custom_search.SearchBar(
              controller: searchController,
            ),
          ),

          // Floating Categories
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 110,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // biar konten ngepas, bukan full width
                  children: [
                    _categoryCard(context, "Live", Icons.live_tv),
                    _categoryCard(context, "Video", Icons.play_circle_fill),
                    _categoryCard(context, "Workshop", Icons.school),
                    _categoryCard(context, "Packages", Icons.card_giftcard),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Content starting directly below categories
          Positioned.fill(
            top: 290,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Live Classes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Live Classes",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (_, i) => _liveClassCard(context),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Membership Banner
                  Container(
                    width: double.infinity, // 👉 biar full lebar layar
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Text(
                      "🔥 Membership Discount\nFree access to all classes!",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Workshops
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Workshops",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: 4,
                      itemBuilder: (_, i) => _workshopCard(context),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category Card
  Widget _categoryCard(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 100,
      height: 90,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colorScheme.secondary, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Live Class Card
  Widget _liveClassCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              "assets/images/banner.jpg",
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Yoga Class",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Live Now", style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  // Workshop Card
  Widget _workshopCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                "assets/images/banner.jpg",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Workshop Class",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
