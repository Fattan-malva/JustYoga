import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class MembershipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Membership',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.card_membership)),
              title: Text('Status Membership'),
              subtitle: Text(user?.name ?? 'Guest'),
              trailing: Text('Aktif'),
            ),
          ),
        ],
      ),
    );
  }
}
