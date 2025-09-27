import 'package:flutter/material.dart';

class MobileProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFF0B90B),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'john.doe@email.com',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 30),
          _buildProfileOption(Icons.account_balance_wallet, 'Wallet'),
          _buildProfileOption(Icons.history, 'Transaction History'),
          _buildProfileOption(Icons.security, 'Security'),
          _buildProfileOption(Icons.notifications, 'Notifications'),
          _buildProfileOption(Icons.help, 'Help & Support'),
          _buildProfileOption(Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFF0B90B)),
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}