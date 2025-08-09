import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool tradingAlerts = true;
  bool priceAlerts = true;
  bool securityAlerts = true;
  bool marketNews = false;
  bool depositWithdrawal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Notifications
          _buildSectionHeader('General Notifications'),
          _buildToggleItem(
            'Push Notifications',
            'Receive notifications on your device',
            pushNotifications,
            (value) {
              setState(() {
                pushNotifications = value;
              });
            },
          ),
          _buildToggleItem(
            'Email Notifications',
            'Receive notifications via email',
            emailNotifications,
            (value) {
              setState(() {
                emailNotifications = value;
              });
            },
          ),
          _buildToggleItem(
            'SMS Notifications',
            'Receive notifications via SMS',
            smsNotifications,
            (value) {
              setState(() {
                smsNotifications = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Trading Notifications
          _buildSectionHeader('Trading & Market'),
          _buildToggleItem(
            'Trading Alerts',
            'Order fills, trades, and account activity',
            tradingAlerts,
            (value) {
              setState(() {
                tradingAlerts = value;
              });
            },
          ),
          _buildToggleItem(
            'Price Alerts',
            'Price movements and watchlist alerts',
            priceAlerts,
            (value) {
              setState(() {
                priceAlerts = value;
              });
            },
          ),
          _buildToggleItem(
            'Market News',
            'Latest market news and updates',
            marketNews,
            (value) {
              setState(() {
                marketNews = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Security Notifications
          _buildSectionHeader('Security & Account'),
          _buildToggleItem(
            'Security Alerts',
            'Login attempts and security updates',
            securityAlerts,
            (value) {
              setState(() {
                securityAlerts = value;
              });
            },
          ),
          _buildToggleItem(
            'Deposit & Withdrawal',
            'Transaction confirmations and updates',
            depositWithdrawal,
            (value) {
              setState(() {
                depositWithdrawal = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Additional Settings
          _buildMenuItem(
            'Notification Schedule',
            'Set quiet hours and frequency',
            Icons.schedule,
            () {
              // Navigate to notification schedule screen
            },
          ),
          _buildMenuItem(
            'Sound & Vibration',
            'Customize notification sounds',
            Icons.volume_up,
            () {
              // Navigate to sound settings screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFF0B90B),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF2B2B2B),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFF0B90B),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF2B2B2B),
        leading: Icon(icon, color: const Color(0xFFF0B90B)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}