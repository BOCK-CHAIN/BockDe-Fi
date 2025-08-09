import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

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
          'Payment Methods',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFF0B90B)),
            onPressed: () {
              _showAddPaymentDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Existing payment methods
          _buildPaymentMethodCard(
            'Bank Transfer',
            'Chase Bank ****1234',
            Icons.account_balance,
            true,
            () {},
          ),
          _buildPaymentMethodCard(
            'Credit Card',
            'Visa ****5678',
            Icons.credit_card,
            false,
            () {},
          ),
          _buildPaymentMethodCard(
            'PayPal',
            'john.doe@example.com',
            Icons.paypal,
            false,
            () {},
          ),
          
          const SizedBox(height: 20),
          
          // Add new payment method
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFF0B90B).withOpacity(0.3),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0B90B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFFF0B90B),
                ),
              ),
              title: const Text(
                'Add New Payment Method',
                style: TextStyle(
                  color: Color(0xFFF0B90B),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Add a bank account, card, or digital wallet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                _showAddPaymentDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String type,
    String details,
    IconData icon,
    bool isDefault,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF2B2B2B),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF0B90B).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFF0B90B)),
        ),
        title: Row(
          children: [
            Text(
              type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0B90B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          details,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          color: const Color(0xFF2B2B2B),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                // Handle edit
                break;
              case 'default':
                // Handle set as default
                break;
              case 'delete':
                // Handle delete
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit', style: TextStyle(color: Colors.white)),
            ),
            if (!isDefault)
              const PopupMenuItem<String>(
                value: 'default',
                child: Text('Set as Default', style: TextStyle(color: Colors.white)),
              ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
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
                'Add Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentOption('Bank Account', Icons.account_balance, () {
                Navigator.pop(context);
                // Navigate to add bank account screen
              }),
              _buildPaymentOption('Credit/Debit Card', Icons.credit_card, () {
                Navigator.pop(context);
                // Navigate to add card screen
              }),
              _buildPaymentOption('PayPal', Icons.paypal, () {
                Navigator.pop(context);
                // Navigate to add PayPal screen
              }),
              _buildPaymentOption('Apple Pay', Icons.apple, () {
                Navigator.pop(context);
                // Navigate to add Apple Pay screen
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: const Color(0xFFF0B90B)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}