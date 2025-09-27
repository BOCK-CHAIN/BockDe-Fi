import 'dart:async';
import 'dart:convert';
import 'package:bockchain/mobile/screens/mobile_coin_screen.dart';
import 'package:bockchain/mobile/screens/mobile_options_screem.dart';
import 'package:bockchain/mobile/screens/mobile_smart_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MobileFuturesScreen extends StatefulWidget {
  const MobileFuturesScreen({Key? key}) : super(key: key);

  @override
  State<MobileFuturesScreen> createState() => _MobileFuturesScreenState();
}

class _MobileFuturesScreenState extends State<MobileFuturesScreen> {
  Timer? _priceUpdateTimer;
  double currentPrice = 115517.0;
  List<OrderBookEntry> orderBook = [];
  String selectedOrderType = 'Limit';
  String selectedLeverage = '20x';
  double orderPrice = 115517.2;
  int orderAmount = 25;
  String selectedTab = 'USD©-M';
  String selectedPair = 'BTCUSDT';
  double priceChange = -1.17;
  double fundingRate = -0.0008;
  String fundingCountdown = '03:06:31';

  @override
  void initState() {
    super.initState();
    _initializeOrderBook();
    _startPriceUpdates();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  void _initializeOrderBook() {
    // Initialize with sample order book data
    orderBook = [
      OrderBookEntry(115518.2, 0.014, false),
      OrderBookEntry(115518.1, 0.002, false),
      OrderBookEntry(115517.8, 0.006, false),
      OrderBookEntry(115517.6, 0.004, false),
      OrderBookEntry(115517.3, 0.004, false),
      OrderBookEntry(115517.1, 0.005, false),
      OrderBookEntry(115517.0, 0.384, false),
      // Current price marker
      OrderBookEntry(115516.9, 18.559, true),
      OrderBookEntry(115516.8, 0.220, true),
      OrderBookEntry(115516.7, 0.011, true),
      OrderBookEntry(115516.6, 0.005, true),
      OrderBookEntry(115516.5, 0.004, true),
      OrderBookEntry(115516.4, 0.009, true),
      OrderBookEntry(115516.3, 0.140, true),
    ];
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updatePrices();
    });
  }

  void _updatePrices() {
    setState(() {
      // Simulate real-time price updates
      double change = (DateTime.now().millisecondsSinceEpoch % 100 - 50) / 10.0;
      currentPrice += change;
      
      // Update order book prices
      for (int i = 0; i < orderBook.length; i++) {
        orderBook[i].price += change;
      }
      
      orderPrice = currentPrice + 0.2;
    });
  }

  void _navigateToTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
    
    // Navigate to respective screens
    switch (tab) {
  case 'COIN-M':
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileCoinScreen(),
      ),
    );
    break;
  case 'Options':
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileOptionsScreen(),
      ),
    );
    break;
  case 'Smart Money':
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileSmartScreen(),
      ),
    );
    break;
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPairInfo(),
            _buildFundingInfo(),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 1, child: _buildTradingPanel()),
                  Expanded(flex: 1, child: _buildOrderBook()),
                ],
              ),
            ),
            _buildPositionsSection(),
            //_buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTabButton('USD©-M', true),
          const SizedBox(width: 20),
          _buildTabButton('COIN-M', false),
          const SizedBox(width: 20),
          _buildTabButton('Options', false),
          const SizedBox(width: 20),
          _buildTabButton('Smart Money', false),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 41, 41, 41)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => _navigateToTab(title),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : const Color.fromARGB(255, 48, 47, 47),
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPairInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            selectedPair,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Perp',
            style: TextStyle(
              color: const Color.fromARGB(255, 53, 53, 53),
              fontSize: 14,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 53, 52, 52)),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.card_giftcard, color: Color.fromARGB(255, 122, 79, 223)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Color.fromARGB(255, 48, 47, 47)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.calculate, color: Color.fromARGB(255, 41, 41, 41)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Color.fromARGB(255, 122, 79, 223)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFundingInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '${priceChange.toStringAsFixed(2)}%',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            'Funding / Countdown',
            style: TextStyle(
              color: const Color.fromARGB(255, 48, 48, 48),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderTypeSelector(),
          const SizedBox(height: 16),
          _buildAvblSection(),
          const SizedBox(height: 16),
          _buildOrderForm(),
          const SizedBox(height: 16),
          _buildLeverageSlider(),
          const SizedBox(height: 16),
          _buildOrderOptions(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildOrderTypeSelector() {
    return Row(
      children: [
        _buildOrderTypeButton('Cross', false),
        const SizedBox(width: 8),
        _buildOrderTypeButton('20x', true),
        const SizedBox(width: 8),
        _buildOrderTypeButton('S', false),
      ],
    );
  }

  Widget _buildOrderTypeButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 161, 161, 161) : const Color.fromARGB(255, 204, 203, 203),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : const Color.fromARGB(255, 145, 145, 145)!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : const Color.fromARGB(255, 48, 47, 47),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAvblSection() {
    return Row(
      children: [
        Text(
          'Avbl',
          style: TextStyle(
            color: const Color.fromARGB(255, 53, 53, 53),
            fontSize: 12,
          ),
        ),
        const Spacer(),
        const Text(
          '--',
          style: TextStyle(
            color: Color.fromARGB(255, 59, 59, 59),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.autorenew,
          color: Color.fromARGB(255, 122, 79, 223),
          size: 16,
        ),
      ],
    );
  }

  Widget _buildOrderForm() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline, color: Color.fromARGB(255, 54, 54, 54), size: 16),
            const SizedBox(width: 8),
            Text(
              selectedOrderType,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 48, 47, 47)),
          ],
        ),
        const SizedBox(height: 16),
        _buildPriceInput(),
        const SizedBox(height: 12),
        _buildAmountInput(),
      ],
    );
  }

  Widget _buildPriceInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 199, 199, 199),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color.fromARGB(255, 161, 161, 161)!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price (USDT)',
                style: TextStyle(
                  color: const Color.fromARGB(255, 80, 80, 80),
                  fontSize: 10,
                ),
              ),
              Text(
                orderPrice.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Color.fromARGB(255, 71, 71, 71), size: 16),
                onPressed: () {
                  setState(() {
                    orderPrice += 0.1;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Color.fromARGB(255, 63, 63, 63), size: 16),
                onPressed: () {
                  setState(() {
                    orderPrice -= 0.1;
                  });
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 150, 149, 149),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'BBO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 172, 171, 171),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color.fromARGB(255, 153, 153, 153)!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount',
                style: TextStyle(
                  color: const Color.fromARGB(255, 94, 94, 94),
                  fontSize: 10,
                ),
              ),
              Text(
                '$orderAmount%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Color.fromARGB(255, 78, 78, 78), size: 16),
                onPressed: () {
                  setState(() {
                    orderAmount = (orderAmount + 5).clamp(0, 100);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Color.fromARGB(255, 78, 78, 78), size: 16),
                onPressed: () {
                  setState(() {
                    orderAmount = (orderAmount - 5).clamp(0, 100);
                  });
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 173, 173, 173),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'BTC',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLeverageSlider() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 141, 141, 141),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 145, 144, 144),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: orderAmount / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderOptions() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all(Colors.transparent),
              side: const BorderSide(color: Color.fromARGB(255, 83, 83, 83)),
            ),
            Text(
              'TP/SL',
              style: TextStyle(
                color: const Color.fromARGB(255, 82, 81, 81),
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 160, 160, 160),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Text(
                    'GTC',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 14),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all(Colors.transparent),
              side: const BorderSide(color: Color.fromARGB(255, 87, 86, 86)),
            ),
            Text(
              'Reduce Only',
              style: TextStyle(
                color: const Color.fromARGB(255, 78, 78, 78),
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Max\nCost',
              style: TextStyle(
                color: const Color.fromARGB(255, 83, 83, 83),
                fontSize: 10,
              ),
            ),
            const Spacer(),
            const Text(
              '0.000 BTC\n0.00 USDT',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Column(
            children: [
              Text(
                'Buy / Long',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '≈ 0.000 BTC',
                style: TextStyle(
                  color: Color.fromARGB(179, 26, 25, 25),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Max\nCost',
              style: TextStyle(
                color: const Color.fromARGB(255, 49, 49, 49),
                fontSize: 10,
              ),
            ),
            const Spacer(),
            const Text(
              '0.000 BTC\n0.00 USDT',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Column(
            children: [
              Text(
                'Sell / Short',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '≈ 0.000 BTC',
                style: TextStyle(
                  color: Color.fromARGB(179, 20, 20, 20),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderBook() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Funding / Countdown',
                style: TextStyle(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              Text(
                '$fundingRate%/$fundingCountdown',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Price\n(USDT)',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 37, 37, 37),
                    fontSize: 10,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount\n(BTC)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 41, 41, 41),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: orderBook.length,
              itemBuilder: (context, index) {
                final entry = orderBook[index];
                final isCurrentPrice = index == 7; // Middle entry
                
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.price.toStringAsFixed(1),
                          style: TextStyle(
                            color: isCurrentPrice 
                                ? Colors.green 
                                : (entry.isBid ? Colors.green : Colors.red),
                            fontSize: 11,
                            fontWeight: isCurrentPrice ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.amount.toStringAsFixed(3),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: isCurrentPrice ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              currentPrice.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '115,518.3',
            style: TextStyle(
              color: const Color.fromARGB(255, 56, 56, 56),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  '97.46%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  '2.54%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Text(
                      '0.1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 12),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 20,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 194, 193, 193),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(Icons.more_vert, color: Color.fromARGB(255, 58, 58, 58), size: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.card_giftcard, color: Color.fromARGB(255, 122, 79, 223), size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Open Account to Trade Futures Today',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Claim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 2),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color.fromARGB(255, 122, 79, 223), width: 2),
                  ),
                ),
                child: const Text(
                  'Positions (0)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Open Orders (0)',
                style: TextStyle(
                  color: const Color.fromARGB(255, 54, 54, 54),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Bots',
                style: TextStyle(
                  color: const Color.fromARGB(255, 48, 47, 47),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.grey, size: 16),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 48),
                const SizedBox(height: 8),
                const Text(
                  'BTCUSDT Perp Chart',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.trending_up, 'Markets', false),
          _buildNavItem(Icons.swap_horiz, 'Trade', false),
          _buildNavItem(Icons.article, 'Futures', true),
          _buildNavItem(Icons.account_balance_wallet, 'Assets', false),
        ],
      ),
    );
  }*/

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.orange : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class OrderBookEntry {
  double price;
  double amount;
  bool isBid;

  OrderBookEntry(this.price, this.amount, this.isBid);
}