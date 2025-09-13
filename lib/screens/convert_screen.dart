import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({Key? key}) : super(key: key);

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  String fromCurrency = 'USDT';
  String toCurrency = 'BTC';
  double availableFromBalance = 0.0;
  double availableToBalance = 0.00000009;
  double conversionRate = 0.000015; // Default BTC/USDT rate
  TextEditingController amountController = TextEditingController();
  Timer? _timer;
  String convertedAmount = '0.00000000';
  bool isLoading = false;

  // Simple crypto data
  final Map<String, Color> cryptoColors = {
    'USDT': Colors.green,
    'BTC': const Color(0xFFF7931A),
    'ETH': const Color(0x627EEA),
    'BNB': const Color(0xFFF0B90B),
  };

  final List<String> availableCurrencies = ['USDT', 'BTC', 'ETH', 'BNB'];

  @override
  void initState() {
    super.initState();
    calculateConversion();
    // Fetch rates less frequently to avoid lag
    fetchConversionRate();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) fetchConversionRate();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    amountController.dispose();
    super.dispose();
  }

  Future<void> fetchConversionRate() async {
    if (!mounted) return;
    
    try {
      // Simplified API call
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,tether&vs_currencies=usd'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        if (data['bitcoin'] != null && data['tether'] != null) {
          setState(() {
            if (fromCurrency == 'USDT' && toCurrency == 'BTC') {
              conversionRate = 1 / data['bitcoin']['usd'];
            } else if (fromCurrency == 'BTC' && toCurrency == 'USDT') {
              conversionRate = data['bitcoin']['usd'].toDouble();
            } else {
              conversionRate = 0.000015; // fallback
            }
            calculateConversion();
          });
        }
      }
    } catch (e) {
      print('API Error: $e');
      // Use fallback rates
      if (mounted) {
        setState(() {
          conversionRate = fromCurrency == 'USDT' ? 0.000015 : 65000.0;
          calculateConversion();
        });
      }
    }
  }

  void calculateConversion() {
    if (amountController.text.isEmpty) {
      setState(() => convertedAmount = '0.00000000');
      return;
    }
    
    double amount = double.tryParse(amountController.text) ?? 0;
    double result = amount * conversionRate;
    
    setState(() {
      convertedAmount = toCurrency == 'BTC' 
          ? result.toStringAsFixed(8)
          : result.toStringAsFixed(2);
    });
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      
      double tempBalance = availableFromBalance;
      availableFromBalance = availableToBalance;
      availableToBalance = tempBalance;
      
      conversionRate = 1 / conversionRate;
      calculateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;
    
    // Responsive padding
    final horizontalPadding = isDesktop ? 55.0 : (isTablet ? 24.0 : 16.0);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Convert',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rewards Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isDesktop ? 24 : 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2D1B69), Color(0xFF1E3A8A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Accumulate ETH to Share 16,500 USDC in Rewards!',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: isMobile ? 14 : 16, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Container(
                        width: isMobile ? 36 : 40,
                        height: isMobile ? 36 : 40,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 122, 79, 223),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star, 
                          color: Colors.black, 
                          size: isMobile ? 18 : 20
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isDesktop ? 40 : 32),
                
                // Tabs
                _buildTabsSection(isMobile, isTablet),
                
                SizedBox(height: isDesktop ? 40 : 32),

                // From Currency
                _buildCurrencyContainer(
                  title: 'From',
                  currency: fromCurrency,
                  balance: availableFromBalance,
                  isFrom: true,
                  isMobile: isMobile,
                  isDesktop: isDesktop,
                ),
                
                SizedBox(height: isDesktop ? 20 : 16),
                
                // Swap Button
                Center(
                  child: GestureDetector(
                    onTap: swapCurrencies,
                    child: Container(
                      width: isMobile ? 44 : 40,
                      height: isMobile ? 44 : 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2F36),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFF3B4048)),
                      ),
                      child: Icon(
                        Icons.swap_vert, 
                        color: Colors.white,
                        size: isMobile ? 24 : 20,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isDesktop ? 20 : 16),

                // To Currency
                _buildCurrencyContainer(
                  title: 'To',
                  currency: toCurrency,
                  balance: availableToBalance,
                  isFrom: false,
                  isMobile: isMobile,
                  isDesktop: isDesktop,
                ),
                
                SizedBox(height: isDesktop ? 48 : 40),
                
                // Convert Button
                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 56 : 50,
                  child: ElevatedButton(
                    onPressed: _canConvert() ? _showConvertDialog : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canConvert() 
                          ? const Color.fromARGB(255, 122, 79, 223) 
                          : const Color(0xFF3B4048),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 4)
                      ),
                    ),
                    child: Text(
                      amountController.text.isEmpty ? 'Enter an amount' : 'Preview Convert',
                      style: TextStyle(
                        color: _canConvert() ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 16 : 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsSection(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          // First row of tabs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Instant',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 16),
              const Text('Recurring', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 16),
              const Text('Limit', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          // Second row with chart toggle
          Row(
            children: [
              const Text('Chart', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color.fromARGB(255, 122, 79, 223),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Instant',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Recurring', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          const Text('Limit', style: TextStyle(color: Colors.grey)),
          const Spacer(),
          const Text('Chart', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: const Color.fromARGB(255, 122, 79, 223),
          ),
        ],
      );
    }
  }

  Widget _buildCurrencyContainer({
    required String title,
    required String currency,
    required double balance,
    required bool isFrom,
    required bool isMobile,
    required bool isDesktop,
  }) {
    final containerPadding = isDesktop ? 24.0 : (isMobile ? 16.0 : 20.0);
    
    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: const TextStyle(color: Colors.grey, fontSize: 14)
                ),
                const SizedBox(height: 4),
                Text(
                  'Available Balance ${balance.toStringAsFixed(isFrom ? 1 : 8)} $currency',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(
                  'Available Balance ${balance.toStringAsFixed(isFrom ? 1 : 8)} $currency',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          
          SizedBox(height: isMobile ? 20 : 16),
          
          // Currency selector and amount input
          if (isMobile && isFrom)
            Column(
              children: [
                // Currency selector (full width on mobile)
                _buildCurrencySelector(currency, isMobile),
                const SizedBox(height: 16),
                // Amount input
                Row(
                  children: [
                    const Text('>', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        onChanged: (value) => calculateConversion(),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const InputDecoration(
                          hintText: '0.01',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildMaxButton(),
                  ],
                ),
              ],
            )
          else if (isMobile && !isFrom)
            Column(
              children: [
                // Currency selector (full width on mobile)
                _buildCurrencySelector(currency, isMobile),
                const SizedBox(height: 16),
                // Converted amount display
                Row(
                  children: [
                    const Text('>', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        convertedAmount,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            // Desktop/Tablet layout (horizontal)
            Row(
              children: [
                _buildCurrencySelector(currency, isMobile),
                const Spacer(),
                const Text('>', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                if (isFrom) 
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      onChanged: (value) => calculateConversion(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: '0.01',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                    ),
                  )
                else
                  Text(
                    convertedAmount,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                if (isFrom) ...[
                  const SizedBox(width: 16),
                  _buildMaxButton(),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(String currency, bool isMobile) {
    return GestureDetector(
      onTap: () => _showCurrencyPicker(currency == fromCurrency),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 12, 
          vertical: isMobile ? 12 : 8
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2F36),
          borderRadius: BorderRadius.circular(isMobile ? 8 : 20),
        ),
        child: Row(
          mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Container(
              width: isMobile ? 24 : 20,
              height: isMobile ? 24 : 20,
              decoration: BoxDecoration(
                color: cryptoColors[currency] ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 8),
            Text(
              currency, 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 16 : 14,
              )
            ),
            if (isMobile) const Spacer(),
            SizedBox(width: isMobile ? 0 : 4),
            Icon(
              Icons.expand_more, 
              color: Colors.white, 
              size: isMobile ? 20 : 16
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxButton() {
    return GestureDetector(
      onTap: () {
        amountController.text = availableFromBalance.toString();
        calculateConversion();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 122, 79, 223)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Max', 
          style: TextStyle(color: Color.fromARGB(255, 122, 79, 223))
        ),
      ),
    );
  }

  bool _canConvert() {
    if (amountController.text.isEmpty) return false;
    double? amount = double.tryParse(amountController.text);
    return amount != null && amount > 0;
  }

  void _showCurrencyPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2026),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Currency',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...availableCurrencies.map((currency) => ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: cryptoColors[currency] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(currency, style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    fromCurrency = currency;
                  } else {
                    toCurrency = currency;
                  }
                });
                fetchConversionRate();
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showConvertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2026),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Convert Confirmation', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${amountController.text} $fromCurrency', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('To: $convertedAmount $toCurrency', style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversion completed!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Convert', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}