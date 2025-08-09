import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0B90B),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Binance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version 2.1.0 (Build 2100)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The world\'s leading cryptocurrency exchange platform',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // App Information
          _buildInfoItem(
            'Version',
            '2.1.0',
            Icons.info_outline,
            () {},
          ),
          _buildInfoItem(
            'Build Number',
            '2100',
            Icons.build,
            () {},
          ),
          _buildInfoItem(
            'Last Updated',
            'January 15, 2025',
            Icons.update,
            () {},
          ),
          _buildInfoItem(
            'App Size',
            '145.2 MB',
            Icons.storage,
            () {},
          ),
          
          const SizedBox(height: 20),
          
          // Legal & Policies
          _buildSectionHeader('Legal & Policies'),
          _buildMenuItem(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description,
            () {
              // Navigate to terms of service
            },
          ),
          _buildMenuItem(
            'Privacy Policy',
            'Learn about our privacy practices',
            Icons.privacy_tip,
            () {
              // Navigate to privacy policy
            },
          ),
          _buildMenuItem(
            'Risk Disclosure',
            'Important trading risk information',
            Icons.warning,
            () {
              // Navigate to risk disclosure
            },
          ),
          _buildMenuItem(
            'Licenses',
            'Third-party licenses and attributions',
            Icons.copyright,
            () {
              // Navigate to licenses
            },
          ),
          
          const SizedBox(height: 20),
          
          // Company Information
          _buildSectionHeader('Company'),
          _buildMenuItem(
            'About Binance',
            'Learn more about our company',
            Icons.business,
            () {
              // Navigate to company info
            },
          ),
          _buildMenuItem(
            'Careers',
            'Join our team',
            Icons.work,
            () {
              // Navigate to careers
            },
          ),
          _buildMenuItem(
            'Contact Us',
            'Get in touch with us',
            Icons.contact_support,
            () {
              // Navigate to contact
            },
          ),
          
          const SizedBox(height: 20),
          
          // Social Media & Links
          _buildSectionHeader('Connect With Us'),
          _buildMenuItem(
            'Website',
            'Visit our official website',
            Icons.language,
            () {
              // Open website
            },
          ),
          _buildMenuItem(
            'Twitter',
            '@binance',
            Icons.link,
            () {
              // Open Twitter
            },
          ),
          _buildMenuItem(
            'Telegram',
            'Join our Telegram channel',
            Icons.send,
            () {
              // Open Telegram
            },
          ),
          _buildMenuItem(
            'Reddit',
            'r/binance',
            Icons.forum,
            () {
              // Open Reddit
            },
          ),
          
          const SizedBox(height: 20),
          
          // Developer Options (Hidden/Debug)
          _buildMenuItem(
            'System Information',
            'View device and app information',
            Icons.phone_android,
            () {
              _showSystemInfo(context);
            },
          ),
          
          const SizedBox(height: 30),
          
          // Copyright
          const Center(
            child: Text(
              '© 2025 Binance. All rights reserved.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          const Center(
            child: Text(
              'Made with ❤️ for crypto enthusiasts',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
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

  Widget _buildInfoItem(String title, String value, IconData icon, VoidCallback onTap) {
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
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
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

  void _showSystemInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2B2B2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSystemInfoRow('Platform', 'Android 14'),
              _buildSystemInfoRow('Device Model', 'Pixel 8 Pro'),
              _buildSystemInfoRow('App Version', '2.1.0+2100'),
              _buildSystemInfoRow('Flutter Version', '3.16.0'),
              _buildSystemInfoRow('Dart Version', '3.2.0'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Copy system info to clipboard
                    const systemInfo = '''
Platform: Android 14
Device Model: Pixel 8 Pro
App Version: 2.1.0+2100
Flutter Version: 3.16.0
Dart Version: 3.2.0
                    ''';
                    Clipboard.setData(const ClipboardData(text: systemInfo));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('System info copied to clipboard'),
                        backgroundColor: Color(0xFFF0B90B),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0B90B),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Copy to Clipboard'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}