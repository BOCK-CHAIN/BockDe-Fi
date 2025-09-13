import 'package:bockchain/screens/advanced_screen.dart';
import 'package:bockchain/screens/loan_scree.dart';
import 'package:bockchain/screens/simple_earn_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class EarnScreen extends StatefulWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  _EarnScreenState createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  Map<String, bool> _expandedCoins = {};
  Map<String, dynamic> _coinPrices = {};
  bool _isLoading = true;

  final List<String> _tabs = ['Overview', 'Simple Earn', 'Advanced', 'Loan'];
  
  final List<Map<String, dynamic>> _carouselCoins = [
    {
      'symbol': 'USDT',
      'name': 'Special Offer',
      'subtitle': 'Flexible',
      'icon': '💚',
      'apr': '27.91',
      'color': Color(0xFF26A17B),
      'tag': 'Ends in 27 days',
    },
    {
      'symbol': 'USDT',
      'name': 'RWUSD',
      'subtitle': 'Flexible',
      'icon': '💚',
      'apr': '4.2',
      'color': Color(0xFF26A17B),
      'tag': '',
    },
    {
      'symbol': 'USDC',
      'name': 'Simple Earn',
      'subtitle': 'Flexible',
      'icon': '💙',
      'apr': '11.85',
      'color': Color(0xFF2775CA),
      'tag': '',
    },
    {
      'symbol': 'DOLO',
      'name': 'Simple Earn',
      'subtitle': 'Flexible',
      'icon': '⚫',
      'apr': '18.65',
      'color': Color(0xFF1E1E1E),
      'tag': '',
    },
  ];

  final List<Map<String, dynamic>> _allCoins = [
    {
      'symbol': 'USDC',
      'name': 'USD Coin',
      'icon': '💙',
      'minApr': '4.2',
      'maxApr': '11.85',
      'color': Color(0xFF2775CA),
      'products': [
        {'name': 'Simple Earn', 'apr': '11.85', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'RWUSD', 'apr': '4.2', 'type': 'Flexible', 'tag': 'RWA'},
        {'name': 'Dual Investment', 'apr': '3.65-193', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'USDT',
      'name': 'Tether',
      'icon': '💚',
      'minApr': '4.2',
      'maxApr': '27.91',
      'color': Color(0xFF26A17B),
      'products': [
        {'name': 'Simple Earn', 'apr': '27.91', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '4.2-15.6', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'ETH',
      'name': 'Ethereum',
      'icon': '⚡',
      'minApr': '1.45',
      'maxApr': '397.34',
      'color': Color(0xFF627EEA),
      'products': [
        {'name': 'Simple Earn', 'apr': '397.34', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '1.45-45.2', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'SOL',
      'name': 'Solana',
      'icon': '🟣',
      'minApr': '1.8',
      'maxApr': '142.43',
      'color': Color(0xFF9945FF),
      'products': [
        {'name': 'Simple Earn', 'apr': '142.43', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '1.8-89.2', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'BNB',
      'name': 'BNB',
      'icon': '🟡',
      'minApr': '0.15',
      'maxApr': '35.99',
      'color': Color(0xFFF0B90B),
      'products': [
        {'name': 'Simple Earn', 'apr': '35.99', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '0.15-28.4', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'XUSD',
      'name': 'XUSD',
      'icon': '💎',
      'minApr': '3.58',
      'maxApr': '3.58',
      'color': Color(0xFF00D4AA),
      'products': [
        {'name': 'Simple Earn', 'apr': '3.58', 'type': 'Flexible', 'tag': 'Principal Protected'},
      ]
    },
    {
      'symbol': 'FDUSD',
      'name': 'First Digital USD',
      'icon': '💰',
      'minApr': '11.81',
      'maxApr': '11.81',
      'color': Color(0xFF1E40AF),
      'products': [
        {'name': 'Simple Earn', 'apr': '11.81', 'type': 'Flexible', 'tag': 'Principal Protected'},
      ]
    },
    {
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'icon': '🟠',
      'minApr': '0.5',
      'maxApr': '125.4',
      'color': Color(0xFFF7931A),
      'products': [
        {'name': 'Simple Earn', 'apr': '125.4', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '0.5-89.2', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'ADA',
      'name': 'Cardano',
      'icon': '🔵',
      'minApr': '2.1',
      'maxApr': '45.8',
      'color': Color(0xFF0033AD),
      'products': [
        {'name': 'Simple Earn', 'apr': '45.8', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '2.1-32.5', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'DOT',
      'name': 'Polkadot',
      'icon': '⚫',
      'minApr': '3.2',
      'maxApr': '78.9',
      'color': Color(0xFFE6007A),
      'products': [
        {'name': 'Simple Earn', 'apr': '78.9', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '3.2-55.6', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'MATIC',
      'name': 'Polygon',
      'icon': '🟣',
      'minApr': '4.5',
      'maxApr': '92.3',
      'color': Color(0xFF8247E5),
      'products': [
        {'name': 'Simple Earn', 'apr': '92.3', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '4.5-67.8', 'type': 'Locked', 'tag': ''},
      ]
    },
    {
      'symbol': 'AVAX',
      'name': 'Avalanche',
      'icon': '🔴',
      'minApr': '5.8',
      'maxApr': '156.7',
      'color': Color(0xFFE84142),
      'products': [
        {'name': 'Simple Earn', 'apr': '156.7', 'type': 'Flexible', 'tag': 'Principal Protected'},
        {'name': 'Dual Investment', 'apr': '5.8-89.4', 'type': 'Locked', 'tag': ''},
      ]
    },
  ];

  bool get _isMobile => MediaQuery.of(context).size.width < 768;
  double get _horizontalPadding => _isMobile ? 16.0 : 55.0;

  @override
  void initState() {
    super.initState();
    _fetchCoinPrices();
    Timer.periodic(Duration(seconds: 30), (timer) {
      _fetchCoinPrices();
    });
  }

  Future<void> _fetchCoinPrices() async {
    try {
      final symbols = _allCoins.map((coin) => coin['symbol']).join(',');
      final response = await http.get(
        Uri.parse('https://api.binance.com/api/v3/ticker/price?symbols=["${symbols.replaceAll(',', '","')}USDT"]'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          for (var item in data) {
            String symbol = item['symbol'].replaceAll('USDT', '');
            _coinPrices[symbol] = double.parse(item['price']);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback with mock data
      setState(() {
        _coinPrices = {
          'USDC': 1.0001,
          'USDT': 0.9999,
          'ETH': 2456.78,
          'SOL': 189.45,
          'BNB': 542.12,
          'XUSD': 1.0002,
          'FDUSD': 0.9998,
          'BTC': 43567.89,
          'ADA': 0.4523,
          'DOT': 7.234,
          'MATIC': 0.8765,
          'AVAX': 34.56,
        };
        _isLoading = false;
      });
    }
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    
    // Navigate to different screens based on tab
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleEarnScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdvancedScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoanScreen()));
        break;
      default:
        // Stay on Overview
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0E11),
        elevation: 0,
        title: Text(
          'Earn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Section - Only show on Overview tab
            if (_selectedTabIndex == 0) ...[
              Container(
                height: _isMobile ? 160 : 180,
                margin: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 20),
                child: PageView.builder(
                  controller: _carouselController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                  itemCount: _carouselCoins.length,
                  itemBuilder: (context, index) {
                    final coin = _carouselCoins[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.all(_isMobile ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E2329),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[800]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top section with tag and coin info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (coin['tag'].isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    coin['tag'],
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 122, 79, 223),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else
                                SizedBox(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[600],
                                size: 16,
                              ),
                            ],
                          ),
                          
                          SizedBox(height: _isMobile ? 12 : 16),
                          
                          // Coin info and APR
                          Row(
                            children: [
                              Container(
                                width: _isMobile ? 36 : 40,
                                height: _isMobile ? 36 : 40,
                                decoration: BoxDecoration(
                                  color: coin['color'],
                                  borderRadius: BorderRadius.circular(_isMobile ? 18 : 20),
                                ),
                                child: Center(
                                  child: Text(
                                    coin['icon'],
                                    style: TextStyle(fontSize: _isMobile ? 18 : 20),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coin['symbol'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _isMobile ? 16 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          coin['name'],
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: _isMobile ? 11 : 12,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          coin['subtitle'],
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: _isMobile ? 11 : 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: _isMobile ? 16 : 20),
                          
                          // APR Display
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'APR',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${coin['apr']}%',
                                style: TextStyle(
                                  color: Color(0xFF02C076),
                                  fontSize: _isMobile ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Carousel Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _carouselCoins.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == entry.key
                          ? Color.fromARGB(255, 122, 79, 223)
                          : Colors.grey[600],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
            ],

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E2329),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search coins',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Filters Row
            if (_isMobile)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildFilterChip('All Durations', true)),
                        SizedBox(width: 12),
                        Expanded(child: _buildFilterChip('All Products', false)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              activeColor: Color.fromARGB(255, 122, 79, 223),
                            ),
                            Expanded(
                              child: Text(
                                'Match My Assets',
                                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              activeColor: Color.fromARGB(255, 122, 79, 223),
                            ),
                            Expanded(
                              child: Text(
                                'Sharia Products',
                                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Row(
                  children: [
                    _buildFilterChip('All Durations', true),
                    SizedBox(width: 12),
                    _buildFilterChip('All Products', false),
                    SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                          activeColor: Color.fromARGB(255, 122, 79, 223),
                        ),
                        Text(
                          'Match My Assets',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                          activeColor: Color.fromARGB(255, 122, 79, 223),
                        ),
                        Text(
                          'Sharia Products',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              decoration: BoxDecoration(
                color: Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: _tabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  String tab = entry.value;
                  bool isSelected = _selectedTabIndex == index;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToTab(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey[400],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: _isMobile ? 13 : 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),

            // Popular Products Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Yield Arena',
                        style: TextStyle(
                          color: Color.fromARGB(255, 122, 79, 223),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 122, 79, 223),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Table Headers - Desktop only
            if (!_isMobile)
              Container(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Coins',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Est. APR',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Duration',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Coins List
            if (_isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                itemCount: _allCoins.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final coin = _allCoins[index];
                  final isExpanded = _expandedCoins[coin['symbol']] ?? false;
                  final currentPrice = _coinPrices[coin['symbol']] ?? 0.0;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1E2329),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedCoins[coin['symbol']] = !isExpanded;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: coin['color'],
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Center(
                                        child: Text(
                                          coin['icon'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coin['symbol'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            coin['name'],
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF02C076).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${coin['minApr']}%-${coin['maxApr']}%',
                                        style: TextStyle(
                                          color: Color(0xFF02C076),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (currentPrice > 0)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 48),
                                        Text(
                                          '\$${currentPrice.toStringAsFixed(currentPrice < 1 ? 4 : 2)}',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.5 : 0,
                                          duration: Duration(milliseconds: 200),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Expanded Products - Mobile
                        if (isExpanded) ...coin['products'].map<Widget>((product) {
                          return Container(
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2B3139),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            product['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (product['tag'].isNotEmpty) ...[
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: product['tag'] == 'Principal Protected' 
                                                    ? Color(0xFF02C076).withOpacity(0.2)
                                                    : Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                product['tag'],
                                                style: TextStyle(
                                                  color: product['tag'] == 'Principal Protected'
                                                      ? Color(0xFF02C076)
                                                      : Color.fromARGB(255, 122, 79, 223),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '${product['apr']}% APR',
                                            style: TextStyle(
                                              color: Color(0xFF02C076),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            product['type'],
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 122, 79, 223),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Subscribe',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                itemCount: _allCoins.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[800],
                  height: 1,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  final coin = _allCoins[index];
                  final isExpanded = _expandedCoins[coin['symbol']] ?? false;
                  final currentPrice = _coinPrices[coin['symbol']] ?? 0.0;
                  
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedCoins[coin['symbol']] = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              // Coin Info
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: coin['color'],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          coin['icon'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coin['symbol'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (currentPrice > 0)
                                            Text(
                                              '\${currentPrice.toStringAsFixed(currentPrice < 1 ? 4 : 2)}',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // APR
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${coin['minApr']}%-${coin['maxApr']}%',
                                  style: TextStyle(
                                    color: Color(0xFF02C076),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              
                              // Duration and Arrow
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Flexible/Locked',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: Duration(milliseconds: 200),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Expanded Products - Desktop
                      if (isExpanded) ...coin['products'].map<Widget>((product) {
                        return Container(
                          padding: EdgeInsets.only(left: 44, right: 0, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          product['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (product['tag'].isNotEmpty) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: product['tag'] == 'Principal Protected' 
                                                  ? Color(0xFF02C076).withOpacity(0.2)
                                                  : Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              product['tag'],
                                              style: TextStyle(
                                                color: product['tag'] == 'Principal Protected'
                                                    ? Color(0xFF02C076)
                                                    : Color.fromARGB(255, 122, 79, 223),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${product['apr']}%',
                                      style: TextStyle(
                                        color: Color(0xFF02C076),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (product['name'] == 'Simple Earn')
                                      Text(
                                        'Max',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 10,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product['type'],
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 122, 79, 223),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Subscribe',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            
            SizedBox(height: 40),
            
            // Crypto Earnings Calculator Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              padding: EdgeInsets.all(_isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate your crypto earnings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Calculator Input Section
                  if (_isMobile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I have',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF2B3139),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '1000',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2B3139),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: 'USDT',
                                    dropdownColor: Color(0xFF2B3139),
                                    isExpanded: true,
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
                                    items: ['USDT', 'USDC', 'BTC', 'ETH'].map((String coin) {
                                      return DropdownMenuItem<String>(
                                        value: coin,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                color: coin == 'USDT' ? Color(0xFF26A17B) : 
                                                       coin == 'USDC' ? Color(0xFF2775CA) :
                                                       coin == 'BTC' ? Color(0xFFF7931A) : Color(0xFF627EEA),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              coin,
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      // Handle dropdown change
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'and I am interested in',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            _buildToggleButton('Flexible', true),
                            SizedBox(width: 12),
                            _buildToggleButton('Locked', false),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'investment.',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  else
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'I have ',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '1000',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'USDT',
                              dropdownColor: Color(0xFF2B3139),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
                              items: ['USDT', 'USDC', 'BTC', 'ETH'].map((String coin) {
                                return DropdownMenuItem<String>(
                                  value: coin,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: coin == 'USDT' ? Color(0xFF26A17B) : 
                                                 coin == 'USDC' ? Color(0xFF2775CA) :
                                                 coin == 'BTC' ? Color(0xFFF7931A) : Color(0xFF627EEA),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Text(
                                        coin,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle dropdown change
                              },
                            ),
                          ),
                        ),
                        Text(
                          ' and I am interested in ',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildToggleButton('Flexible', true),
                              SizedBox(width: 8),
                              _buildToggleButton('Locked', false),
                            ],
                          ),
                        ),
                        Text(
                          ' investment.',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 32),
                  
                  // Products and Earnings Section
                  if (_isMobile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Products on offer
                        Text(
                          'Products on offer',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Simple Earn',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF02C076).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Low Risk',
                                      style: TextStyle(
                                        color: Color(0xFF02C076),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 12),
                              
                              Row(
                                children: [
                                  Text(
                                    '2.91%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' + ',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '8%',
                                    style: TextStyle(
                                      color: Color(0xFF02C076),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 8),
                              
                              Row(
                                children: [
                                  Text(
                                    'APR Breakdown',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 122, 79, 223),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Subscribe Now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        // Estimated Earnings
                        Text(
                          'Estimated Earnings',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        Text(
                          '+ 141.3207398 USDT',
                          style: TextStyle(
                            color: Color(0xFF02C076),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Auto-Compounding',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.check_box,
                              color: Color.fromARGB(255, 122, 79, 223),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Auto-Subscribe',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Chart background with time periods
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                                Color.fromARGB(255, 122, 79, 223).withOpacity(0.05),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Curved line representing growth
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                                        Color.fromARGB(255, 122, 79, 223),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Time period buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTimeButton('1 year', false),
                            _buildTimeButton('2 years', false),
                            _buildTimeButton('3 years', true),
                            _buildTimeButton('5 years', false),
                          ],
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Products on offer
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Products on offer',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2B3139),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Simple Earn',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF02C076).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Low Risk',
                                            style: TextStyle(
                                              color: Color(0xFF02C076),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 12),
                                    
                                    Row(
                                      children: [
                                        Text(
                                          '2.91%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' + ',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '8%',
                                          style: TextStyle(
                                            color: Color(0xFF02C076),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 8),
                                    
                                    Row(
                                      children: [
                                        Text(
                                          'APR Breakdown',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.grey[400],
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Subscribe Now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 24),
                        
                        // Estimated Earnings
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Earnings',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Text(
                                '+ 141.3207398 USDT',
                                style: TextStyle(
                                  color: Color(0xFF02C076),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.grey[500],
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Auto-Compounding',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 8),
                              
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Color.fromARGB(255, 122, 79, 223),
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Auto-Subscribe',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 24),
                              
                              // Chart background with time periods
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                                      Color.fromARGB(255, 122, 79, 223).withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    // Curved line representing growth
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                      child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                                              Color.fromARGB(255, 122, 79, 223),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              // Time period buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildTimeButton('1 year', false),
                                  _buildTimeButton('2 years', false),
                                  _buildTimeButton('3 years', true),
                                  _buildTimeButton('5 years', false),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 24),
                  
                  // Disclaimer
                  Text(
                    'This calculation is an estimate of rewards you will earn in cryptocurrency over the selected timeframe. It does not display the actual or predicted APR in any fiat currency. APR is subject to change at any time and the estimated earnings may be different from the actual earnings generated.',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.2) : Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[700]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[300],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _isMobile ? 8 : 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[400],
          fontSize: _isMobile ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}