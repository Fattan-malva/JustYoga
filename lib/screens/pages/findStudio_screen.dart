import 'package:flutter/material.dart';

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
    final double overlap = 30.0; // jarak overlap antara header dan body

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

/// Screen (Stateless) yang menggunakan FindStudioLayout
class FindStudioScreen extends StatelessWidget {
  static const routeName = '/find-studio';

  const FindStudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FindStudioLayout(
      headerBackgroundColor: Theme.of(context).colorScheme.primary,
      headerHeight: 260, // contoh, bisa disesuaikan
      headerContent: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // 🔹 bikin teks mepet kiri
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Find Your\nStudios',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.left, // 🔹 pastikan teks rata kiri
          ),
          const SizedBox(height: 10),
          Text(
            'Discover Just Yoga studios near you\ncalm, inspiring, and ready to welcome your practice',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  // 🔹 lebih kecil
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4, // 🔹 jarak antar baris biar lebih enak dibaca
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
              child: ListView.builder(
                itemCount: 5, // placeholder
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Consultant ${index + 1}'),
                      subtitle: Text('Specialist in area ${index + 1}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () {
                          // aksi chat placeholder
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
