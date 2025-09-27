import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileBuyScreen extends StatefulWidget {
  const MobileBuyScreen({Key? key}) : super(key: key);

  @override
  State<MobileBuyScreen> createState() => _MobileBuyScreenState();
}

class _MobileBuyScreenState extends State<MobileBuyScreen> {
  bool isBuySelected = true;
  String selectedCurrency = 'INR';
  String selectedCrypto = 'USDT';
  String selectedPaymentMethod = 'Card (VISA/Mastercard)';
  TextEditingController amountController = TextEditingController();
  double minAmount = 4000;
  double maxAmount = 100000;
  String displayAmount = '₹4,000';

  final List<String> currencies = ['INR', 'USD', 'EUR', 'GBP'];
  final List<String> cryptos = ['USDT', 'BTC', 'ETH', 'BNB'];
  final List<String> paymentMethods = [
    'Card (VISA/Mastercard)',
    'UPI',
    'Bank Transfer',
    'Wallet'
  ];

  @override
  void initState() {
    super.initState();
    amountController.text = '4000';
  }

  void updateAmount(String digit) {
    setState(() {
      if (amountController.text == '0') {
        amountController.text = digit;
      } else {
        amountController.text += digit;
      }
      _updateDisplayAmount();
    });
  }

  void deleteDigit() {
    setState(() {
      if (amountController.text.isNotEmpty) {
        amountController.text = amountController.text.substring(0, amountController.text.length - 1);
        if (amountController.text.isEmpty) {
          amountController.text = '0';
        }
      }
      _updateDisplayAmount();
    });
  }

  void _updateDisplayAmount() {
    double amount = double.tryParse(amountController.text) ?? 0;
    displayAmount = '₹${_formatNumber(amount)}';
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number ~/ 1000)},${(number % 1000).toInt().toString().padLeft(3, '0')}';
    }
    return number.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        /*title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 20),
            _buildTabButton('Convert', false),
            _buildTabButton('Spot', false),
            _buildTabButton('Margin', false),
            _buildTabButton('Buy/Sell', true),
            _buildTabButton('P2P', false),
            _buildTabButton('Alpha', false),
          ],
        ),*/
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),*/
      body: Column(
        children: [
          // Buy/Sell Toggle
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildToggleButton('Buy', isBuySelected, () {
                  setState(() {
                    isBuySelected = true;
                  });
                }),
                const SizedBox(width: 10),
                _buildToggleButton('Sell', !isBuySelected, () {
                  setState(() {
                    isBuySelected = false;
                  });
                }),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bookmark_border, size: 20),
                ),
              ],
            ),
          ),

          // Amount Display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedCurrency,
                      underline: Container(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency, style: const TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurrency = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Balance Display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.swap_vert, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  '0 USDT',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Crypto Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSelectionTile(
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF26A69A),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '₮',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: 'Buy',
              subtitle: selectedCrypto,
              onTap: () => _showCryptoSelection(),
            ),
          ),

          const SizedBox(height: 15),

          // Payment Method Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSelectionTile(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 20,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              title: 'Pay With',
              subtitle: selectedPaymentMethod,
              onTap: () => _showPaymentMethodSelection(),
            ),
          ),

          const SizedBox(height: 30),

          // Amount Range
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Min',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${_formatNumber(minAmount)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          displayAmount,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Max',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${_formatNumber(maxAmount)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Number Pad
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildNumberButton('.'),
                    _buildNumberButton('0'),
                    _buildDeleteButton(),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Navigation
          /*Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(Icons.home_outlined, 'Home'),
                _buildBottomNavItem(Icons.show_chart, 'Markets'),
                _buildBottomNavItem(Icons.swap_horiz, 'Trade', isSelected: true),
                _buildBottomNavItem(Icons.trending_up, 'Futures'),
                _buildBottomNavItem(Icons.account_balance_wallet_outlined, 'Assets'),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required Widget icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: GestureDetector(
        onTap: () => updateAmount(number),
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: GestureDetector(
        onTap: deleteDigit,
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.orange : Colors.grey.shade600,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.grey.shade600,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showCryptoSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Cryptocurrency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...cryptos.map((crypto) => ListTile(
                title: Text(crypto),
                onTap: () {
                  setState(() {
                    selectedCrypto = crypto;
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...paymentMethods.map((method) => ListTile(
                title: Text(method),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = method;
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}