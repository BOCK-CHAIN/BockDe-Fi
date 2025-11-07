import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileTradeScreen extends StatefulWidget {
  @override
  _MobileTradeScreenState createState() => _MobileTradeScreenState();
}

class _MobileTradeScreenState extends State<MobileTradeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _subTabController;
  
  // Current selections
  int _currentMainTab = 0;
  int _currentSubTab = 0;
  
  // Form controllers
  TextEditingController _fromAmountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  
  // Selected cryptocurrencies
  String _selectedFromCoin = 'BARD';
  String _selectedToCoin = 'USDT';
  
  // Available coins with real prices (simulated)
  final Map<String, Map<String, dynamic>> _coins = {
    'BARD': {'name': 'Bard', 'price': 0.011, 'icon': '🟢', 'balance': 0.0},
    'USDT': {'name': 'Tether', 'price': 1.0, 'icon': '🔵', 'balance': 0.0},
    'BTC': {'name': 'Bitcoin', 'price': 45000.0, 'icon': '🟠', 'balance': 0.0},
    'ETH': {'name': 'Ethereum', 'price': 2800.0, 'icon': '🔷', 'balance': 0.0},
    'BNB': {'name': 'Binance Coin', 'price': 320.0, 'icon': '🟡', 'balance': 0.0},
    'ADA': {'name': 'Cardano', 'price': 0.45, 'icon': '🔵', 'balance': 0.0},
    'SOL': {'name': 'Solana', 'price': 95.0, 'icon': '🟣', 'balance': 0.0},
    'DOT': {'name': 'Polkadot', 'price': 6.2, 'icon': '🔴', 'balance': 0.0},
    'MATIC': {'name': 'Polygon', 'price': 0.85, 'icon': '🟣', 'balance': 0.0},
    'LINK': {'name': 'Chainlink', 'price': 12.5, 'icon': '🔵', 'balance': 0.0},
  };
  
  // Timer for real-time updates
  Timer? _priceUpdateTimer;
  
  // Recurring plan settings
  String _frequency = 'Daily, 0.5:00 (UTC+5)';
  String _assetsDestination = 'Spot Account';
  double _recurringPercentage = 100.0;
  
  // Limit order settings
  String _orderExpiry = 'Expires in 30 days';

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 6, vsync: this);
    _subTabController = TabController(length: 3, vsync: this);
    
    // Listen to tab changes
    _mainTabController.addListener(() {
      setState(() {
        _currentMainTab = _mainTabController.index;
      });
    });
    
    _subTabController.addListener(() {
      setState(() {
        _currentSubTab = _subTabController.index;
      });
    });
    
    // Start real-time price updates
    _startPriceUpdates();
  }
  
  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Simulate price fluctuations
        _coins.forEach((key, value) {
          double basePrice = value['price'];
          double fluctuation = (Random().nextDouble() - 0.5) * 0.02; // ±1% change
          _coins[key]!['price'] = basePrice * (1 + fluctuation);
        });
        _updateConversion();
      });
    });
  }
  
  void _updateConversion() {
    if (_fromAmountController.text.isNotEmpty) {
      double fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
      double fromPrice = _coins[_selectedFromCoin]!['price'];
      double toPrice = _coins[_selectedToCoin]!['price'];
      double toAmount = (fromAmount * fromPrice) / toPrice;
      _toAmountController.text = toAmount.toStringAsFixed(6);
    }
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
    _priceUpdateTimer?.cancel();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),*/
      body:SafeArea(
        child: Column(
        children: [
          // Main Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _mainTabController,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              tabs: [
                Tab(text: 'Convert'),
                Tab(text: 'Spot'),
                Tab(text: 'Margin'),
                Tab(text: 'Buy/Sell'),
                Tab(text: 'P2P'),
                Tab(text: 'Alpha'),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                _buildConvertTab(),
                _buildSpotTab(),
                _buildMarginTab(),
                _buildBuySellTab(),
                _buildP2PTab(),
                _buildAlphaTab(),
              ],
            ),
          ),
          
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
      ),
    );
  }

  Widget _buildConvertTab() {
    return Column(
      children: [
        // Sub Tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _subTabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Instant'),
              Tab(text: 'Recurring'),
              Tab(text: 'Limit'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              _buildInstantTab(),
              _buildRecurringTab(),
              _buildLimitTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstantTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Row(
                children: [
                  Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${_coins[_selectedFromCoin]!['balance']} $_selectedFromCoin', 
                       style: TextStyle(color: Colors.black, fontSize: 12)),
                  SizedBox(width: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 12),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // From coin selection
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown(_selectedFromCoin, (value) {
                  setState(() {
                    _selectedFromCoin = value!;
                    _updateConversion();
                  });
                }),
                Expanded(
                  child: TextField(
                    controller: _fromAmountController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.011',
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onChanged: (value) => _updateConversion(),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Swap icon
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_vert, color: Colors.grey),
            ),
          ),
          
          SizedBox(height: 16),
          
          // To section
          Text('To', style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 8),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown(_selectedToCoin, (value) {
                  setState(() {
                    _selectedToCoin = value!;
                    _updateConversion();
                  });
                }),
                Expanded(
                  child: TextField(
                    controller: _toAmountController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.01',
                      contentPadding: EdgeInsets.all(16),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ),
          
          Spacer(),
          
          // Preview button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                _showPreviewDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Preview',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Row(
                children: [
                  Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('0 USDT', style: TextStyle(color: Colors.black, fontSize: 12)),
                  SizedBox(width: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 12),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // From USDT
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown('USDT', (value) {}),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.1 = 4900000',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // To section with percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('To (100%/100%)', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          SizedBox(height: 8),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown('BTC', (value) {}),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('100%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Frequency
          _buildSettingRow('Frequency', _frequency, () {
            _showFrequencyDialog();
          }),
          
          SizedBox(height: 16),
          
          // Assets Destination
          _buildSettingRow('Assets Destination', _assetsDestination, () {
            _showDestinationDialog();
          }),
          
          SizedBox(height: 16),
          
          // Advanced Options
          Row(
            children: [
              Text('Advanced Options', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          
          Spacer(),
          
          // Create a plan button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                _showCreatePlanDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Create a plan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Recurring Plan section
          Text('Recurring Plan (0)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLimitTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Row(
                children: [
                  Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('0 BARD', style: TextStyle(color: Colors.black, fontSize: 12)),
                  SizedBox(width: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 12),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // From BARD
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown('BARD', (value) {}),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.011 = 8600',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Swap icon
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_vert, color: Colors.grey),
            ),
          ),
          
          SizedBox(height: 16),
          
          // To section
          Text('To', style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 8),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown('BNB', (value) {}),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00001 = 8.1',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Price section
          Text('Price', style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 8),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCoinDropdown('BNB', (value) {}),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.000945',
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Expires in
          _buildSettingRow('Expires in', _orderExpiry, () {
            _showExpiryDialog();
          }),
          
          Spacer(),
          
          // Preview button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                _showLimitPreviewDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Preview',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Open Orders section
          Text('Open Orders (0)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCoinDropdown(String selectedCoin, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DropdownButton<String>(
        value: selectedCoin,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down),
        onChanged: onChanged,
        items: _coins.keys.map((String coin) {
          return DropdownMenuItem<String>(
            value: coin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_coins[coin]!['icon'], style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(coin, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingRow(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
          Row(
            children: [
              Text(value, style: TextStyle(color: Colors.black, fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpotTab() {
    // TODO: Replace with your SpotTradingScreen
    return MobileSpotScreen();
  }

  Widget _buildMarginTab() {
    // TODO: Replace with your MarginTradingScreen
    return MobileSpotScreen();
  }

  Widget _buildBuySellTab() {
    // TODO: Replace with your BuySellScreen
    return MobileBuyScreen();
  }

  Widget _buildP2PTab() {
    // TODO: Replace with your P2PScreen
    return MobileP2pScreen();
  }

  Widget _buildAlphaTab() {
    // TODO: Replace with your AlphaScreen
    return MobileAlphaScreen();
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      /*child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Trade tab is selected
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Futures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Assets',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation tap
          switch (index) {
            case 0:
              // Navigate to Home
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // Navigate to Markets
              Navigator.pushReplacementNamed(context, '/markets');
              break;
            case 2:
              // Already on Trade screen
              break;
            case 3:
              // Navigate to Futures
              Navigator.pushReplacementNamed(context, '/futures');
              break;
            case 4:
              // Navigate to Assets
              Navigator.pushReplacementNamed(context, '/assets');
              break;
          }
        },
      ),*/
    );
  }

  // Dialog methods
  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Convert Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${_fromAmountController.text} $_selectedFromCoin'),
            Text('To: ${_toAmountController.text} $_selectedToCoin'),
            Text('Rate: 1 $_selectedFromCoin = ${(_coins[_selectedFromCoin]!['price'] / _coins[_selectedToCoin]!['price']).toStringAsFixed(6)} $_selectedToCoin'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Conversion executed successfully!')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Recurring Plan'),
        content: Text('Your recurring plan will be created with the specified parameters.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recurring plan created successfully!')),
              );
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showLimitPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limit Order Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Type: Limit'),
            Text('Price: ${_priceController.text} BNB'),
            Text('Expires: $_orderExpiry'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Limit order placed successfully!')),
              );
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }

  void _showFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Daily, 0.5:00 (UTC+5)',
            'Weekly, Monday',
            'Monthly, 1st day',
          ].map((freq) => RadioListTile<String>(
            title: Text(freq),
            value: freq,
            groupValue: _frequency,
            onChanged: (value) {
              setState(() {
                _frequency = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDestinationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assets Destination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Spot Account',
            'Futures Account',
            'Margin Account',
          ].map((dest) => RadioListTile<String>(
            title: Text(dest),
            value: dest,
            groupValue: _assetsDestination,
            onChanged: (value) {
              setState(() {
                _assetsDestination = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showExpiryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Expiry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Expires in 1 day',
            'Expires in 7 days',
            'Expires in 30 days',
            'Good Till Cancelled',
          ].map((expiry) => RadioListTile<String>(
            title: Text(expiry),
            value: expiry,
            groupValue: _orderExpiry,
            onChanged: (value) {
              setState(() {
                _orderExpiry = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}