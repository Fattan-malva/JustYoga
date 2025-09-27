import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(
                  user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=12')),
          SizedBox(height: 12),
          Text(user?.name ?? 'Guest',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          SizedBox(height: 8),
          Text(user?.email ?? ''),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => auth.logout(),
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50)),
          )
        ],
      ),
    );
  }
}
