import 'package:flutter/material.dart';
import '../../widgets/search_bar.dart' as custom_search;
import '../../widgets/category_card.dart';

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
                  image: const AssetImage("assets/images/Banner.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black
                        .withOpacity(0.4), // ubah opacity sesuai kebutuhan
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
                //child: Image.asset(
                //  "assets/icons/logo.png",
                //  height: 80,
                //  fit: BoxFit.contain,
                //),
                ),
          ),

          // Search Bar
          //Positioned(
          //  top: 110,
          //  left: 16,
          //  right: 16,
          //  child: custom_search.SearchBar(
          //    controller: searchController,
          //  ),
          //),

          // Floating Categories
          Positioned(
            top: 180,
            left: 16,
            right: 16,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                const spacing = 12.0;
                final totalSpacing = spacing * 3;
                final cardWidth =
                    ((availableWidth - totalSpacing) / 4).clamp(50.0, 100.0);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryCard(
                        label: "Class",
                        iconPath: "assets/icons/class.svg",
                        width: cardWidth),
                    CategoryCard(
                        label: "Just Me",
                        iconPath: "assets/icons/just_me.svg",
                        width: cardWidth),
                    CategoryCard(
                        label: "Membership",
                        iconPath: "assets/icons/membership.svg",
                        width: cardWidth),
                    CategoryCard(
                        label: "Trainer",
                        iconPath: "assets/icons/trainers.svg",
                        width: cardWidth),
                  ],
                );
              },
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
                          "Our Trainer",
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
                      itemCount: 10,
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
                          "Our Studio",
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

  // Live Class Card
  // Live Class Card (ubah jadi gambar bulat + teks di bawah)
  Widget _liveClassCard(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = Colors.red.shade700; // ganti warna kalau mau

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle with border
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 6),
              // optional shadow:
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/images/trainerpp.png", // <-- ganti sesuai filemu
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Name / Title (mirip gambar)
          Text(
            "SINTA MANJA", // <-- ganti sesuai kebutuhan
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: borderColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 4),

          // Subtext (opsional)
          Text(
            "Trainer", // atau "Yoga Class" / keterangan lain
            style: theme.textTheme.bodySmall,
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
                "assets/images/studio.jpg",
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
