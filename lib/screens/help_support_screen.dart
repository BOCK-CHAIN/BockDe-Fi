import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Help & Support',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for help...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2B2B2B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Quick Actions
          _buildSectionHeader('Quick Actions'),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Live Chat',
                  Icons.chat,
                  () {
                    // Open live chat
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Submit Ticket',
                  Icons.support_agent,
                  () {
                    // Open ticket submission
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // FAQ Section
          _buildSectionHeader('Frequently Asked Questions'),
          _buildFAQItem(
            'How to buy cryptocurrency?',
            'Learn the step-by-step process to purchase crypto',
            () {
              // Navigate to FAQ detail
            },
          ),
          _buildFAQItem(
            'How to withdraw funds?',
            'Guide on withdrawing your funds safely',
            () {
              // Navigate to FAQ detail
            },
          ),
          _buildFAQItem(
            'Trading fees explained',
            'Understanding our fee structure',
            () {
              // Navigate to FAQ detail
            },
          ),
          _buildFAQItem(
            'Security best practices',
            'Keep your account secure',
            () {
              // Navigate to FAQ detail
            },
          ),
          
          const SizedBox(height: 20),
          
          // Support Categories
          _buildSectionHeader('Support Categories'),
          _buildSupportCategory(
            'Account Issues',
            'Login problems, verification, account recovery',
            Icons.account_circle,
            () {
              // Navigate to account issues
            },
          ),
          _buildSupportCategory(
            'Trading Support',
            'Order issues, trading features, market data',
            Icons.trending_up,
            () {
              // Navigate to trading support
            },
          ),
          _buildSupportCategory(
            'Deposits & Withdrawals',
            'Payment issues, transaction status, limits',
            Icons.account_balance_wallet,
            () {
              // Navigate to payment support
            },
          ),
          _buildSupportCategory(
            'Technical Issues',
            'App problems, connectivity, bug reports',
            Icons.bug_report,
            () {
              // Navigate to technical support
            },
          ),
          
          const SizedBox(height: 20),
          
          // Contact Information
          _buildSectionHeader('Contact Us'),
          _buildContactItem(
            'Email Support',
            'support@binance.com',
            Icons.email,
            () {
              // Open email client
            },
          ),
          _buildContactItem(
            'Phone Support',
            '+1 (555) 123-4567',
            Icons.phone,
            () {
              // Make phone call
            },
          ),
          _buildContactItem(
            'Community Forum',
            'Join our community discussions',
            Icons.forum,
            () {
              // Open community forum
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

  Widget _buildQuickActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF0B90B).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFFF0B90B),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String description, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF2B2B2B),
        leading: const Icon(
          Icons.help_outline,
          color: Color(0xFFF0B90B),
        ),
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
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

  Widget _buildSupportCategory(String title, String description, IconData icon, VoidCallback onTap) {
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
          description,
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

  Widget _buildContactItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
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