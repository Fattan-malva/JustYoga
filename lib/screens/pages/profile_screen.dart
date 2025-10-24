import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isPersonalExpanded = true;
  bool isAccountExpanded = true;
  bool isPlanHistoryExpanded = true;
  bool isJustMeHistoryExpanded = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.loadCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Stack(
        children: [
          // ===== BODY (container bawah dengan radius) =====
          Positioned.fill(
            top: 110,
            child: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 200),

                      // ===== SCROLL AREA (card-card + logout) =====
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if (user != null &&
                                  user.customerID.isNotEmpty) ...[
                                // === PLAN HISTORY CARD ===
                                _buildExpandableCard(
                                  theme: theme,
                                  title: 'Plan History',
                                  isExpanded: isPlanHistoryExpanded,
                                  onTap: () {
                                    setState(() {
                                      isPlanHistoryExpanded =
                                          !isPlanHistoryExpanded;
                                    });
                                  },
                                  children: auth.planHistory != null &&
                                          auth.planHistory!.isNotEmpty
                                      ? auth.planHistory!
                                          .map((plan) =>
                                              _buildPlanHistoryItem(plan))
                                          .toList()
                                      : [
                                          _buildInfoRow('No Data',
                                              'No plan history available')
                                        ],
                                ),
                                const SizedBox(height: 10),

                                // === JUST ME HISTORY CARD ===
                                _buildExpandableCard(
                                  theme: theme,
                                  title: 'Just Me History',
                                  isExpanded: isJustMeHistoryExpanded,
                                  onTap: () {
                                    setState(() {
                                      isJustMeHistoryExpanded =
                                          !isJustMeHistoryExpanded;
                                    });
                                  },
                                  children: auth.justMeHistory != null &&
                                          auth.justMeHistory!.isNotEmpty
                                      ? auth.justMeHistory!
                                          .map((justMe) =>
                                              _buildJustMeHistoryItem(justMe))
                                          .toList()
                                      : [
                                          _buildInfoRow('No Data',
                                              'No just me history available')
                                        ],
                                ),
                                const SizedBox(height: 10),

                                // === PERSONAL INFO CARD ===
                                _buildExpandableCard(
                                  theme: theme,
                                  title: 'Personal Information',
                                  isExpanded: isPersonalExpanded,
                                  onTap: () {
                                    setState(() {
                                      isPersonalExpanded = !isPersonalExpanded;
                                    });
                                  },
                                  children: [
                                    _buildInfoRow(
                                        'Customer ID', user.customerID),
                                    _buildInfoRow('Full Name', user.name),
                                    _buildInfoRow('Birth Date', user.birthDate),
                                    _buildInfoRow('Phone', user.phone),
                                    _buildInfoRow(
                                        'Identity Number', user.noIdentity),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // === ACCOUNT DETAILS CARD ===
                                _buildExpandableCard(
                                  theme: theme,
                                  title: 'Account Details',
                                  isExpanded: isAccountExpanded,
                                  onTap: () {
                                    setState(() {
                                      isAccountExpanded = !isAccountExpanded;
                                    });
                                  },
                                  children: [
                                    _buildInfoRow('Email', user.email),
                                    _buildInfoRow(
                                        'Last Contract', user.lastContractID),
                                    _buildInfoRow('Studio ID', user.toStudioID),
                                  ],
                                ),
                              ] else ...[
                                _buildProfileCard(
                                  theme: theme,
                                  title: 'Account Information',
                                  children: [
                                    _buildInfoRow('Status', 'Guest User'),
                                    _buildInfoRow(
                                      'Message',
                                      'Please login to view full profile details',
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 32),

                              // ===== LOGOUT BUTTON =====
                              ElevatedButton(
                                onPressed: () async {
                                  await auth.logout();
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===== AVATAR MELAYANG =====
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  // === AVATAR ===
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=12',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // === NAMA ===
                  Text(
                    user?.name ?? 'Guest',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // === EMAIL ===
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== CARD ACTIVE PLAN =====
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA50F0F), // 🔴 merah gelap
                          Color.fromARGB(255, 249, 63, 63), // 🟡 merah sedang
                          Color.fromARGB(255, 255, 169, 159), // 🟨 gold terang
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 252, 238, 195)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // === Isi utama card ===
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // === Header: Icon + Active Plan ===
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/membership.svg',
                                  height: 24,
                                  width: 24,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Active Plan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // === Garis penuh ===
                            Container(
                              height: 2,
                              width: double.infinity,
                              color: Colors.black.withOpacity(0.25),
                            ),

                            const SizedBox(height: 12),

                            // === Product Name ===
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Premium Yoga Mat Plan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            // === Start & End Date ===
                            const Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  '12 Oct 2025',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  '12 Dec 2025',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // === Badge "Active" di kanan atas ===
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
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
        ],
      ),
    );
  }

  // ===== EXPANDABLE CARD =====
  Widget _buildExpandableCard({
    required ThemeData theme,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: isExpanded ? 20 : 12, // 🔹 lebih kecil saat belum dibuka
        ),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER TITLE + CHEVRON ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0, // rotate chevron
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 26,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            // === ANIMATED EXPAND CONTENT ===
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(children: children),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  // ===== STATIC CARD (untuk guest) =====
  Widget _buildProfileCard({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // ===== INFO ROW =====
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? _formatDate(value) : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== FORMAT DATE =====
  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  // ===== PLAN HISTORY ITEM =====
  Widget _buildPlanHistoryItem(plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF9B63F), // gold gelap sedikit
            Color(0xFFFFC94D), // gold sedang
            Color(0xFFFFE39F), // gold terang
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3), // soft golden shadow
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description, // ikon "data history"
                color: Color(0xFF333333),
                size: 20,
              ),
              const SizedBox(width: 6), // jarak antara ikon dan teks
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    plan.productName,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 360 ? 12 : 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black.withOpacity(0.1),
            thickness: 1,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _formatDate(plan.startDate),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(plan.endDate),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== PLAN HISTORY INFO ROW =====
  Widget _buildPlanHistoryInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  // ===== JUST ME HISTORY ITEM =====
  Widget _buildJustMeHistoryItem(justMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB8B8B8), // silver gelap
            Color(0xFFD9D9D9), // silver sedang
            Color(0xFFF2F2F2), // silver terang
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // soft silver shadow
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group, // ikon "data history"
                color: Color(0xFF333333),
                size: 20,
              ),
              const SizedBox(width: 6), // jarak antara ikon dan teks
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    justMe.productName,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 360 ? 12 : 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
          const SizedBox(height: 8),

          // 🔹 Ganti dari Center() ke Align kiri
          Text(
            'Remaining Sessions: ${justMe.remainSession ?? 0}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _formatDate(justMe.startDate),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(justMe.endDate),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
