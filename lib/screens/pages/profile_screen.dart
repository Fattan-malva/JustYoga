import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isPersonalExpanded = false;
  bool isAccountExpanded = false;
  bool isPlanHistoryExpanded = false;
  bool isJustMeHistoryExpanded = false;

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
                      const SizedBox(height: 50),

                      // ===== SCROLL AREA (card-card + logout) =====
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if (user != null &&
                                  user.customerID.isNotEmpty) ...[
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
                                const SizedBox(height: 10),

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
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
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
              value.isNotEmpty ? value : '-',
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

  // ===== PLAN HISTORY ITEM =====
  Widget _buildPlanHistoryItem(plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.productName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Start Date', plan.startDate),
          _buildInfoRow('End Date', plan.endDate),
          _buildInfoRow('Transaction Date', plan.trxDate),
        ],
      ),
    );
  }

  // ===== JUST ME HISTORY ITEM =====
  Widget _buildJustMeHistoryItem(justMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            justMe.productName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Start Date', justMe.startDate),
          _buildInfoRow('End Date', justMe.endDate),
          _buildInfoRow('Remaining Sessions', justMe.remainSession.toString()),
        ],
      ),
    );
  }
}
