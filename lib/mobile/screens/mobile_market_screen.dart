import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_data_screen.dart';
import 'package:bockchain/mobile/screens/mobile_grow_screen.dart';
import 'package:bockchain/mobile/screens/mobile_markets_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileMarketScreen extends StatefulWidget {
  @override
  _MobileMarketScreenState createState() => _MobileMarketScreenState();
}

class _MobileMarketScreenState extends State<MobileMarketScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _priceUpdateTimer;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  List<CryptoAsset> _allAssets = [
    CryptoAsset(
      name: 'BNB',
      pair: '/USDT',
      leverage: '10x',
      price: 990.00,
      volume: '340.65M',
      priceInr: '₹87,248.70',
      change24h: -0.75,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'BTC',
      pair: '/USDT',
      leverage: '10x',
      price: 116147.83,
      volume: '1.17B',
      priceInr: '₹10,236,108.25',
      change24h: -1.17,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'ETH',
      pair: '/USDT',
      leverage: '10x',
      price: 4512.75,
      volume: '1.30B',
      priceInr: '₹397,708.65',
      change24h: -1.76,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'SOL',
      pair: '/USDT',
      leverage: '10x',
      price: 240.80,
      volume: '936.33M',
      priceInr: '₹21,221.70',
      change24h: -2.77,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'DOGE',
      pair: '/USDT',
      leverage: '10x',
      price: 0.27019,
      volume: '447.93M',
      priceInr: '₹23.81',
      change24h: -4.80,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'WLFI',
      pair: '/USDT',
      leverage: '5x',
      price: 0.2328,
      volume: '122.46M',
      priceInr: '₹20.51',
      change24h: 4.44,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'ADA',
      pair: '/USDT',
      leverage: '10x',
      price: 0.9043,
      volume: '151.14M',
      priceInr: '₹79.68',
      change24h: -1.51,
      isFavorite: true,
    ),
    CryptoAsset(
      name: 'PEPE',
      pair: '/USDT',
      leverage: '5x',
      price: 0.00001090,
      volume: '118.37M',
      priceInr: '₹0.00096061',
      change24h: -4.05,
      isFavorite: true,
    ),
  ];

  List<CryptoAsset> get _filteredAssets {
    if (_searchQuery.isEmpty) {
      return _tabController.index == 0 
          ? _allAssets.where((asset) => asset.isFavorite).toList()
          : _allAssets;
    }
    
    final query = _searchQuery.toLowerCase();
    return _allAssets.where((asset) {
      final matchesSearch = asset.name.toLowerCase().contains(query);
      return _tabController.index == 0 
          ? (matchesSearch && asset.isFavorite)
          : matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _startPriceUpdates();
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        for (var asset in _allAssets) {
          // Simulate price changes
          final random = Random();
          final changePercent = (random.nextDouble() - 0.5) * 0.1; // ±5% max change
          asset.price = asset.price * (1 + changePercent);
          
          // Update 24h change slightly
          final changeDirection = random.nextBool() ? 1 : -1;
          asset.change24h += (random.nextDouble() * 0.1 * changeDirection);
          
          // Update INR price proportionally
          asset.priceInr = '₹${(asset.price * 88.2).toStringAsFixed(2)}';
        }
      });
    });
  }

  // Navigation methods to your existing screens
  /*void _navigateToMarketsScreen() {
    Navigator.pushNamed(context, '/markets', arguments: _allAssets);
  }

  void _navigateToAlphaScreen() {
    Navigator.pushNamed(context, '/alpha', arguments: _allAssets);
  }

  void _navigateToGrowScreen() {
    Navigator.pushNamed(context, '/grow', arguments: _allAssets);
  }

  void _navigateToSquareScreen() {
    Navigator.pushNamed(context, '/square', arguments: _allAssets);
  }

  void _navigateToDataScreen() {
    Navigator.pushNamed(context, '/data', arguments: _allAssets);
  }*/

    void _navigateToMarketsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileMarketsScreen(),
      ),
    );
  }

  void _navigateToAlphaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAlphaScreen(),
      ),
    );
  }

  void _navigateToGrowScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileGrowScreen(),
      ),
    );
  }


  void _navigateToDataScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileDataScreen(),
      ),
    );
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        // Stay on Favorites (current screen)
        break;
      case 1:
        _navigateToMarketsScreen();
        break;
      case 2:
        _navigateToAlphaScreen();
        break;
      case 3:
        _navigateToGrowScreen();
        break;
      /*case 4:
        _navigateToSquareScreen();
        break;*/
      case 4:
        _navigateToDataScreen();
        break;
    }
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Coin Pairs',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
            
            // Main Tabs
            Container(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[500],
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                onTap: _onTabTapped,
                tabs: [
                  Tab(text: 'Favorites'),
                  Tab(text: 'Market'),
                  Tab(text: 'Alpha'),
                  Tab(text: 'Grow'),
                  //Tab(text: 'Square'),
                  Tab(text: 'Data'),
                ],
              ),
            ),
            
            // List Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name ↕ / Vol ↕',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Last Price ↕',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '24h Chg% ↕',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            
            // Favorites List (only show this content)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAssets.length,
                itemBuilder: (context, index) {
                  final asset = _filteredAssets[index];
                  return _buildCryptoItem(asset);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoItem(CryptoAsset asset) {
    final isPositive = asset.change24h > 0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Name and Volume
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      asset.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      asset.pair,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        asset.leverage,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  asset.volume,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          // Price
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(asset.price),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 2),
                Text(
                  asset.priceInr,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 8),
          
          // 24h Change
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price < 0.001) {
      return price.toStringAsExponential(4);
    } else if (price < 1) {
      return price.toStringAsFixed(5);
    } else if (price < 100) {
      return price.toStringAsFixed(4);
    } else {
      return price.toStringAsFixed(2);
    }
  }
}

class CryptoAsset {
  final String name;
  final String pair;
  final String leverage;
  double price;
  final String volume;
  String priceInr;
  double change24h;
  bool isFavorite;

  CryptoAsset({
    required this.name,
    required this.pair,
    required this.leverage,
    required this.price,
    required this.volume,
    required this.priceInr,
    required this.change24h,
    required this.isFavorite,
  });
}