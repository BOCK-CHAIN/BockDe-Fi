import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool twoFactorAuth = true;
  bool smsVerification = true;
  bool emailVerification = false;

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
          'Account Security',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSecurityItem(
            'Change Password',
            'Update your account password',
            Icons.lock,
            () {
              // Navigate to change password screen
            },
          ),
          _buildToggleItem(
            'Two-Factor Authentication',
            'Add an extra layer of security',
            Icons.security,
            twoFactorAuth,
            (value) {
              setState(() {
                twoFactorAuth = value;
              });
            },
          ),
          _buildToggleItem(
            'SMS Verification',
            'Verify transactions via SMS',
            Icons.sms,
            smsVerification,
            (value) {
              setState(() {
                smsVerification = value;
              });
            },
          ),
          _buildToggleItem(
            'Email Verification',
            'Verify transactions via email',
            Icons.email,
            emailVerification,
            (value) {
              setState(() {
                emailVerification = value;
              });
            },
          ),
          _buildSecurityItem(
            'Trusted Devices',
            'Manage your trusted devices',
            Icons.devices,
            () {
              // Navigate to trusted devices screen
            },
          ),
          _buildSecurityItem(
            'Login History',
            'View recent login activity',
            Icons.history,
            () {
              // Navigate to login history screen
            },
          ),
          _buildSecurityItem(
            'API Management',
            'Manage your API keys',
            Icons.api,
            () {
              // Navigate to API management screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildToggleItem(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
}