import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.loadCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=12',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? 'Guest',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(user?.email ?? ''),
              const SizedBox(height: 16),

              if (user != null && user.customerID.isNotEmpty) ...[
                _buildReadOnlyField('Customer ID', user.customerID),
                _buildReadOnlyField('Name', user.name),
                _buildReadOnlyField('Email', user.email),
                _buildReadOnlyField('Birth Date', user.birthDate),
                _buildReadOnlyField('Phone', user.phone),
                _buildReadOnlyField('No Identity', user.noIdentity),
                _buildReadOnlyField('Last Contract ID', user.lastContractID),
                _buildReadOnlyField('To Studio ID', user.toStudioID),
                const SizedBox(height: 24),
              ],

              ElevatedButton(
                onPressed: () async {
                  await auth.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Logout'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
