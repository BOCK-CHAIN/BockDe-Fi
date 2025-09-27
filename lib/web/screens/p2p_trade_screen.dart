import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class P2PTradeScreen extends StatefulWidget {
  const P2PTradeScreen({Key? key}) : super(key: key);

  @override
  State<P2PTradeScreen> createState() => _P2PTradeScreenState();
}

class _P2PTradeScreenState extends State<P2PTradeScreen> {
  String selectedOrderType = 'Buy';
  String selectedCrypto = 'USDT';
  String selectedFiat = 'PLN';
  String selectedTransactionAmount = 'PLN';
  List<String> selectedPaymentMethods = ['All payment methods'];
  String sortBy = 'Price';
  int currentPage = 1;
  int totalPages = 2;
  bool isLoading = false;
  Timer? _refreshTimer;
  
  // Comprehensive currency list from Binance P2P
  final List<String> currencies = [
    'Search', 'INR', 'AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AZN', 'BAM', 'BDT', 'BGN', 'BHD', 'BIF', 'BND', 'BOB', 'BRL', 'BSD', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'GBP', 'GEL', 'GHS', 'GMD', 'GNF', 'GTQ', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'IQD', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MWK', 'MXN', 'MZN', 'NAD', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RWF', 'SAR', 'SCR', 'SDG', 'SEK', 'SLE', 'SOS', 'SYP', 'THB', 'TJS', 'TMT', 'TND', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'XAF', 'XOF', 'YER', 'ZAR', 'ZMW', 'ZWG'
  ];

  final Map<String, List<String>> paymentMethodCategories = {
    'All payment methods': ['All payment methods'],
    'Popular': ['Blik', 'PKO Bank', 'Santander Poland', 'Millennium', 'Bank Pekao'],
    'Others': ['BNP Paribas', 'mBank', 'ING', 'VeloBank', 'ZEN', 'Alior Bank', 'Credit Agricole (Card)', 'Bank Pocztowy', 'Nest Bank', 'Citi Handlowy', 'Skrill (Moneybookers)'],
    'Bank Transfer': ['Bank Transfer'],
  };

  List<P2POrder> currentOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    setState(() => isLoading = true);
    
    try {
      // Simulate real API call delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In production, replace this with actual Binance P2P API call
      final orders = await P2PApiService.fetchP2POrders(
        crypto: selectedCrypto,
        fiat: selectedFiat,
        tradeType: selectedOrderType.toLowerCase(),
        paymentMethods: selectedPaymentMethods,
        page: currentPage,
      );
      
      setState(() {
        currentOrders = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders: $e'),
          backgroundColor: const Color(0xFFF6465D),
        ),
      );
    }
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          // Header controls
          Container(
            padding: EdgeInsets.all(isDesktop ? 55 : (isTablet ? 24 : 16)),
            child: Column(
              children: [
                if (isMobile) ...[
                  // Mobile layout - stacked vertically
                  _buildMobileControls(),
                ] else ...[
                  // Desktop/Tablet layout - horizontal
                  _buildDesktopControls(isDesktop),
                ],
              ],
            ),
          ),
          // Table
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2B3139),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (!isMobile) ...[
                    // Desktop table header
                    _buildDesktopTableHeader(),
                  ],
                  // Table body with loading indicator
                  Expanded(
                    child: isLoading 
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 122, 79, 223),
                            ),
                          )
                        : isMobile 
                            ? _buildMobileOrdersList()
                            : _buildDesktopOrdersList(),
                  ),
                ],
              ),
            ),
          ),
          // Pagination
          Container(
            padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
            child: _buildPagination(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileControls() {
    return Column(
      children: [
        // Buy/Sell toggle
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2B3139),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedOrderType = 'Buy');
                    _fetchOrders();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedOrderType == 'Buy' ? const Color(0xFF0ECB81) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedOrderType == 'Buy' ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedOrderType = 'Sell');
                    _fetchOrders();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedOrderType == 'Sell' ? const Color(0xFFF6465D) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sell',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedOrderType == 'Sell' ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Crypto tabs - horizontal scroll
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCryptoTab('USDT'),
              _buildCryptoTab('USDC'),
              _buildCryptoTab('BTC'),
              _buildCryptoTab('BNB'),
              _buildCryptoTab('ETH'),
              _buildCryptoTab('EURI'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Filter dropdowns - stacked on mobile
        _buildCurrencyDropdown(),
        const SizedBox(height: 12),
        _buildPaymentMethodsDropdown(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                'Sort By',
                sortBy,
                ['Price', 'Amount', 'Completion Rate'],
                (value) => setState(() => sortBy = value!),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2B3139),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopControls(bool isDesktop) {
    return Column(
      children: [
        // Buy/Sell toggle and crypto selection
        Row(
          children: [
            // Buy/Sell toggle
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2B3139),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedOrderType = 'Buy');
                      _fetchOrders();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : 24, 
                        vertical: isDesktop ? 12 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedOrderType == 'Buy' ? const Color(0xFF0ECB81) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          color: selectedOrderType == 'Buy' ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: isDesktop ? 16 : 14,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedOrderType = 'Sell');
                      _fetchOrders();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : 24, 
                        vertical: isDesktop ? 12 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedOrderType == 'Sell' ? const Color(0xFFF6465D) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Sell',
                        style: TextStyle(
                          color: selectedOrderType == 'Sell' ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: isDesktop ? 16 : 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: isDesktop ? 32 : 24),
            // Crypto selection
            Row(
              children: [
                _buildCryptoTab('USDT'),
                _buildCryptoTab('USDC'),
                _buildCryptoTab('BTC'),
                _buildCryptoTab('BNB'),
                _buildCryptoTab('ETH'),
                _buildCryptoTab('EURI'),
              ],
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        // Filter controls
        Row(
          children: [
            // Transaction amount dropdown with search
            Expanded(
              flex: 2,
              child: _buildCurrencyDropdown(),
            ),
            SizedBox(width: isDesktop ? 16 : 12),
            // Payment methods dropdown
            Expanded(
              flex: 3,
              child: _buildPaymentMethodsDropdown(),
            ),
            SizedBox(width: isDesktop ? 16 : 12),
            // Filter button
            Container(
              padding: EdgeInsets.all(isDesktop ? 16 : 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B3139),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white70,
                size: isDesktop ? 24 : 20,
              ),
            ),
            const Spacer(),
            // Sort dropdown
            _buildDropdown(
              'Sort By',
              sortBy,
              ['Price', 'Amount', 'Completion Rate'],
              (value) => setState(() => sortBy = value!),
              isCompact: !isDesktop,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopTableHeader() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16, 
        vertical: isDesktop ? 16 : 12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF383E47), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Text(
              'Advertisers', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: isDesktop ? 16 : 14, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              'Price', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: isDesktop ? 16 : 14, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3, 
            child: Text(
              'Available/Order Limit', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: isDesktop ? 16 : 14, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              'Payment', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: isDesktop ? 16 : 14, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              'Trade', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: isDesktop ? 16 : 14, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentOrders.length,
      itemBuilder: (context, index) {
        final order = currentOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF383E47),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Advertiser info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF0ECB81),
                    child: Text(
                      order.advertiser[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                order.advertiser,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (order.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Color.fromARGB(255, 122, 79, 223),
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${order.orders} orders | ${order.completionRate.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Price and stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'zł ${order.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 14,
                            color: order.completionRate >= 99.5 ? const Color(0xFF0ECB81) : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${order.completionRate.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: order.completionRate >= 99.5 ? const Color(0xFF0ECB81) : Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${order.responseTime} min',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Available amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${order.available.toStringAsFixed(2)} $selectedCrypto',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.orderLimit,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Payment methods
              const Text(
                'Payment Methods',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: order.paymentMethods.take(3).map((method) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3139),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    method,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )).toList(),
              ),
              if (order.paymentMethods.length > 3) ...[
                const SizedBox(height: 4),
                Text(
                  '+${order.paymentMethods.length - 3} more',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Trade button
              SizedBox(
                width: double.infinity,
                child: order.isRestricted
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Restricted',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () => _handleTrade(order),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selectedOrderType == 'Buy' 
                                ? const Color(0xFF0ECB81) 
                                : const Color(0xFFF6465D),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            selectedOrderType == 'Buy' ? 'Buy $selectedCrypto' : 'Sell $selectedCrypto',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopOrdersList() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return ListView.builder(
      itemCount: currentOrders.length,
      itemBuilder: (context, index) {
        final order = currentOrders[index];
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16, 
            vertical: isDesktop ? 20 : 16,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF383E47), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Advertisers column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: isDesktop ? 18 : 16,
                          backgroundColor: const Color(0xFF0ECB81),
                          child: Text(
                            order.advertiser[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isDesktop ? 16 : 14,
                            ),
                          ),
                        ),
                        SizedBox(width: isDesktop ? 12 : 8),
                        Flexible(
                          child: Text(
                            order.advertiser,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isDesktop ? 16 : 14,
                            ),
                          ),
                        ),
                        if (order.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            color: const Color.fromARGB(255, 122, 79, 223),
                            size: isDesktop ? 18 : 16,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: isDesktop ? 6 : 4),
                    Text(
                      '${order.orders} orders | ${order.completionRate.toStringAsFixed(2)}% completion',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: isDesktop ? 14 : 12,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 4 : 2),
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: isDesktop ? 14 : 12,
                          color: order.completionRate >= 99.5 ? const Color(0xFF0ECB81) : Colors.orange,
                        ),
                        SizedBox(width: isDesktop ? 6 : 4),
                        Text(
                          '${order.completionRate.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: order.completionRate >= 99.5 ? const Color(0xFF0ECB81) : Colors.orange,
                            fontSize: isDesktop ? 14 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 16 : 12),
                        Icon(
                          Icons.access_time,
                          size: isDesktop ? 14 : 12,
                          color: Colors.white54,
                        ),
                        SizedBox(width: isDesktop ? 6 : 4),
                        Text(
                          '${order.responseTime} min',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: isDesktop ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'zł ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 18 : 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Available/Order Limit column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.available.toStringAsFixed(2)} $selectedCrypto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 16 : 14,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 6 : 4),
                    Text(
                      order.orderLimit,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isDesktop ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Payment column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.paymentMethods.take(3).map((method) => Container(
                      margin: EdgeInsets.only(bottom: isDesktop ? 6 : 4),
                      child: Row(
                        children: [
                          Container(
                            width: isDesktop ? 10 : 8,
                            height: isDesktop ? 10 : 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF6465D),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: isDesktop ? 8 : 6),
                          Flexible(
                            child: Text(
                              method,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 14 : 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    if (order.paymentMethods.length > 3)
                      Text(
                        '+${order.paymentMethods.length - 3} more',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          fontSize: isDesktop ? 13 : 11,
                        ),
                      ),
                  ],
                ),
              ),
              // Trade column
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    if (order.isRestricted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 16 : 12, 
                          vertical: isDesktop ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: isDesktop ? 16 : 14,
                              color: Colors.white54,
                            ),
                            SizedBox(width: isDesktop ? 6 : 4),
                            Text(
                              'Restricted',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: isDesktop ? 14 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => _handleTrade(order),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 20 : 16, 
                            vertical: isDesktop ? 10 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedOrderType == 'Buy' 
                                ? const Color(0xFF0ECB81) 
                                : const Color(0xFFF6465D),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            selectedOrderType == 'Buy' ? 'Buy $selectedCrypto' : 'Sell $selectedCrypto',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isDesktop ? 14 : 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCryptoTab(String crypto) {
    final isSelected = selectedCrypto == crypto;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return GestureDetector(
      onTap: () {
        setState(() => selectedCrypto = crypto);
        _fetchOrders();
      },
      child: Container(
        margin: EdgeInsets.only(right: isDesktop ? 12 : 8),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 20 : 16, 
          vertical: isDesktop ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : const Color(0xFF2B3139),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          crypto,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 16 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 16, 
        vertical: isDesktop ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383E47)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTransactionAmount,
          isDense: true,
          dropdownColor: const Color(0xFF2B3139),
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 16 : 14,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down, 
            color: Colors.white70, 
            size: isDesktop ? 24 : 20,
          ),
          onChanged: (value) {
            setState(() => selectedTransactionAmount = value!);
            _fetchOrders();
          },
          items: [
            DropdownMenuItem(
              value: 'Search',
              child: Row(
                children: [
                  Icon(
                    Icons.search, 
                    color: Colors.white70, 
                    size: isDesktop ? 18 : 16,
                  ),
                  SizedBox(width: isDesktop ? 10 : 8),
                  Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white70, 
                      fontSize: isDesktop ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
            ...currencies.skip(1).map((currency) => DropdownMenuItem(
              value: currency,
              child: Row(
                children: [
                  Icon(
                    Icons.circle, 
                    color: const Color(0xFFF6465D), 
                    size: isDesktop ? 14 : 12,
                  ),
                  SizedBox(width: isDesktop ? 10 : 8),
                  Text(
                    currency,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsDropdown() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 16, 
        vertical: isDesktop ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383E47)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPaymentMethods.first,
          isDense: true,
          dropdownColor: const Color(0xFF2B3139),
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 16 : 14,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down, 
            color: Colors.white70, 
            size: isDesktop ? 24 : 20,
          ),
          onChanged: (value) {
            setState(() {
              if (value == 'All payment methods') {
                selectedPaymentMethods = ['All payment methods'];
              } else {
                selectedPaymentMethods = [value!];
              }
            });
            _fetchOrders();
          },
          items: _buildPaymentMethodItems(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildPaymentMethodItems() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    List<DropdownMenuItem<String>> items = [];
    Set<String> addedValues = {}; // Track added values to avoid duplicates
    
    paymentMethodCategories.forEach((category, methods) {
      // Add methods in category (skip category headers to avoid duplicates)
      for (String method in methods) {
        if (!addedValues.contains(method)) {
          addedValues.add(method);
          items.add(DropdownMenuItem(
            value: method,
            child: Text(
              method,
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
          ));
        }
      }
    });
    
    return items;
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    IconData? icon,
    bool isCompact = false,
  }) {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? (isDesktop ? 16 : 12) : (isDesktop ? 20 : 16),
        vertical: isCompact ? (isDesktop ? 12 : 8) : (isDesktop ? 16 : 12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383E47)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          dropdownColor: const Color(0xFF2B3139),
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 16 : 14,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down, 
            color: Colors.white70, 
            size: isDesktop ? 24 : 20,
          ),
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon, 
                    color: const Color(0xFFF6465D), 
                    size: isDesktop ? 14 : 12,
                  ),
                  SizedBox(width: isDesktop ? 10 : 8),
                ],
                Text(
                  item,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? (isDesktop ? 14 : 12) : (isDesktop ? 16 : 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 1 ? () {
            setState(() => currentPage--);
            _fetchOrders();
          } : null,
          icon: Icon(
            Icons.chevron_left, 
            color: Colors.white70,
            size: isDesktop ? 28 : 24,
          ),
        ),
        ...List.generate(totalPages, (index) {
          final page = index + 1;
          return GestureDetector(
            onTap: () {
              setState(() => currentPage = page);
              _fetchOrders();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 6 : 4),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12, 
                vertical: isDesktop ? 10 : 6,
              ),
              decoration: BoxDecoration(
                color: currentPage == page ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$page',
                style: TextStyle(
                  color: currentPage == page ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 16 : 14,
                ),
              ),
            ),
          );
        }),
        IconButton(
          onPressed: currentPage < totalPages ? () {
            setState(() => currentPage++);
            _fetchOrders();
          } : null,
          icon: Icon(
            Icons.chevron_right, 
            color: Colors.white70,
            size: isDesktop ? 28 : 24,
          ),
        ),
      ],
    );
  }

  void _handleTrade(P2POrder order) {
    // Handle trade button tap
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B3139),
        title: Text(
          '$selectedOrderType $selectedCrypto',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Trade with ${order.advertiser}\nPrice: zł ${order.price.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Confirm',
              style: TextStyle(
                color: selectedOrderType == 'Buy' ? const Color(0xFF0ECB81) : const Color(0xFFF6465D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class P2POrder {
  final String advertiser;
  final bool isVerified;
  final int orders;
  final double completionRate;
  final int responseTime;
  final double price;
  final double available;
  final String orderLimit;
  final List<String> paymentMethods;
  final bool isRestricted;
  final DateTime lastUpdated;

  P2POrder({
    required this.advertiser,
    required this.isVerified,
    required this.orders,
    required this.completionRate,
    required this.responseTime,
    required this.price,
    required this.available,
    required this.orderLimit,
    required this.paymentMethods,
    required this.isRestricted,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory P2POrder.fromJson(Map<String, dynamic> json) {
    return P2POrder(
      advertiser: json['advertiser'] ?? 'Unknown',
      isVerified: json['isVerified'] ?? false,
      orders: json['orders'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      responseTime: json['responseTime'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      available: (json['available'] ?? 0.0).toDouble(),
      orderLimit: json['orderLimit'] ?? '',
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      isRestricted: json['isRestricted'] ?? false,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advertiser': advertiser,
      'isVerified': isVerified,
      'orders': orders,
      'completionRate': completionRate,
      'responseTime': responseTime,
      'price': price,
      'available': available,
      'orderLimit': orderLimit,
      'paymentMethods': paymentMethods,
      'isRestricted': isRestricted,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class P2PApiService {
  static const String baseUrl = 'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search';
  
  // Mock data for demonstration - replace with actual API calls
  static final List<String> _mockAdvertisers = [
    'CryptoKing2024', 'TradeExpert', 'BinancePro', 'CoinMaster', 'FastTrader',
    'SafeTrader', 'CryptoGuru', 'QuickExchange', 'ReliableTrader', 'CoinExpert'
  ];
  
  static final List<List<String>> _mockPaymentMethods = [
    ['Blik', 'PKO Bank'],
    ['Santander Poland', 'Millennium'],
    ['Bank Pekao', 'mBank'],
    ['ING', 'VeloBank'],
    ['ZEN', 'Alior Bank'],
    ['Credit Agricole (Card)'],
    ['Bank Pocztowy', 'Nest Bank'],
    ['Citi Handlowy'],
    ['Skrill (Moneybookers)'],
    ['Bank Transfer']
  ];

  static Future<List<P2POrder>> fetchP2POrders({
    required String crypto,
    required String fiat,
    required String tradeType,
    required List<String> paymentMethods,
    required int page,
  }) async {
    try {
      // Simulate API call with real Binance P2P parameters
      final requestBody = {
        "page": page,
        "rows": 10,
        "payTypes": paymentMethods.contains('All payment methods') ? [] : paymentMethods,
        "asset": crypto,
        "tradeType": tradeType.toUpperCase(),
        "fiat": fiat,
        "publisherType": null,
        "merchantCheck": false,
      };

      // For demonstration, we'll use mock data instead of actual API call
      // In production, uncomment the following lines and remove mock data:
      /*
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (compatible; P2PApp/1.0)',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> ordersData = data['data'] ?? [];
        return ordersData.map((orderJson) => P2POrder.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to load P2P orders: ${response.statusCode}');
      }
      */

      // Mock data generation for demonstration
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final Random random = Random();
      final List<P2POrder> mockOrders = [];

      for (int i = 0; i < 10; i++) {
        final advertiser = _mockAdvertisers[random.nextInt(_mockAdvertisers.length)];
        final basePrice = _getPriceForCrypto(crypto, fiat);
        final priceVariation = (random.nextDouble() - 0.5) * 0.1; // ±5% variation
        final price = basePrice * (1 + priceVariation);
        
        mockOrders.add(P2POrder(
          advertiser: advertiser,
          isVerified: random.nextBool(),
          orders: random.nextInt(1000) + 50,
          completionRate: 95.0 + (random.nextDouble() * 5.0), // 95-100%
          responseTime: random.nextInt(10) + 1, // 1-10 minutes
          price: price,
          available: (random.nextDouble() * 50000) + 1000, // 1K-51K
          orderLimit: _generateOrderLimit(price, fiat),
          paymentMethods: _mockPaymentMethods[random.nextInt(_mockPaymentMethods.length)],
          isRestricted: random.nextDouble() < 0.1, // 10% chance of restriction
          lastUpdated: DateTime.now().subtract(Duration(seconds: random.nextInt(300))),
        ));
      }

      // Sort based on the current sort criteria
      _sortOrders(mockOrders, 'Price'); // Default sort by price
      
      return mockOrders;

    } catch (e) {
      throw Exception('Failed to fetch P2P orders: $e');
    }
  }

  static double _getPriceForCrypto(String crypto, String fiat) {
    // Mock exchange rates - replace with real API data
    final Map<String, double> cryptoPrices = {
      'USDT': 4.15, // PLN per USDT
      'USDC': 4.15, // PLN per USDC
      'BTC': 180000.0, // PLN per BTC
      'ETH': 12000.0, // PLN per ETH
      'BNB': 2500.0, // PLN per BNB
      'EURI': 4.30, // PLN per EURI
    };

    return cryptoPrices[crypto] ?? 4.15;
  }

  static String _generateOrderLimit(double price, String fiat) {
    final Random random = Random();
    final minAmount = (random.nextInt(500) + 100) * price; // 100-600 crypto units
    final maxAmount = minAmount + (random.nextInt(2000) + 500) * price; // +500-2500 crypto units
    
    final currencySymbol = _getCurrencySymbol(fiat);
    return '${currencySymbol}${minAmount.toStringAsFixed(0)} - ${currencySymbol}${maxAmount.toStringAsFixed(0)}';
  }

  static String _getCurrencySymbol(String fiat) {
    final Map<String, String> currencySymbols = {
      'PLN': 'zł',
      'USD': '€',
      'EUR': '€',
      'GBP': '£',
      'INR': '₹',
      'JPY': '¥',
    };
    return currencySymbols[fiat] ?? fiat;
  }

  static void _sortOrders(List<P2POrder> orders, String sortBy) {
    switch (sortBy) {
      case 'Price':
        orders.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Amount':
        orders.sort((a, b) => b.available.compareTo(a.available));
        break;
      case 'Completion Rate':
        orders.sort((a, b) => b.completionRate.compareTo(a.completionRate));
        break;
    }
  }

  // Method to get real-time price updates
  static Future<Map<String, double>> getCryptoPrices(List<String> symbols) async {
    try {
      // In production, use a real crypto price API like CoinGecko or Binance API
      // Example: https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=pln
      
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 200));
      
      final Map<String, double> prices = {};
      final Random random = Random();
      
      for (String symbol in symbols) {
        final basePrice = _getPriceForCrypto(symbol, 'PLN');
        final priceVariation = (random.nextDouble() - 0.5) * 0.02; // ±1% variation
        prices[symbol] = basePrice * (1 + priceVariation);
      }
      
      return prices;
    } catch (e) {
      throw Exception('Failed to fetch crypto prices: $e');
    }
  }

  // Method to get payment methods for a specific country/fiat
  static Future<Map<String, List<String>>> getPaymentMethods(String fiat) async {
    try {
      // In production, fetch this from Binance API
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Mock data based on fiat currency
      if (fiat == 'PLN') {
        return {
          'All payment methods': ['All payment methods'],
          'Popular': ['Blik', 'PKO Bank', 'Santander Poland', 'Millennium', 'Bank Pekao'],
          'Others': ['BNP Paribas', 'mBank', 'ING', 'VeloBank', 'ZEN', 'Alior Bank', 'Credit Agricole (Card)', 'Bank Pocztowy', 'Nest Bank', 'Citi Handlowy', 'Skrill (Moneybookers)'],
          'Bank Transfer': ['Bank Transfer'],
        };
      } else if (fiat == 'USD') {
        return {
          'All payment methods': ['All payment methods'],
          'Popular': ['PayPal', 'Wise', 'Bank Transfer', 'Zelle', 'Cash App'],
          'Others': ['Western Union', 'MoneyGram', 'Remitly', 'Skrill', 'Neteller'],
          'Bank Transfer': ['Bank Transfer', 'Wire Transfer'],
        };
      }
      
      // Default payment methods for other currencies
      return {
        'All payment methods': ['All payment methods'],
        'Popular': ['Bank Transfer', 'PayPal', 'Wise'],
        'Others': ['Skrill', 'Neteller', 'Western Union'],
        'Bank Transfer': ['Bank Transfer'],
      };
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }
}