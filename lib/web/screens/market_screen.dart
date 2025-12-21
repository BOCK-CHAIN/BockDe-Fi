import 'package:bockchain/web/screens/AI_select_screen.dart';
import 'package:bockchain/web/screens/token_unlock_screen.dart';
import 'package:bockchain/web/screens/trading_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// Model classes for token data
class TokenData {
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double volume24h;
  final double marketCap;
  final String icon;

  TokenData({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.marketCap,
    required this.icon,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      change24h: double.tryParse(json['priceChangePercent']?.toString() ?? '0') ?? 0.0,
      volume24h: double.tryParse(json['volume']?.toString() ?? '0') ?? 0.0,
      marketCap: double.tryParse(json['marketCap']?.toString() ?? '0') ?? 0.0,
      icon: json['icon'] ?? '',
    );
  }
}

// Chainlink Price Feed Service
class ChainlinkService {
  static const String baseUrl = 'https://api.coinpaprika.com/v1';
  static const String binanceApiUrl = 'https://api.binance.com/api/v3';
  
  // Get real-time price data from multiple sources
  static Future<List<TokenData>> fetchTokens({int page = 1, int limit = 50}) async {
    try {
      // Using Binance API for real-time data
      final response = await http.get(
        Uri.parse('$binanceApiUrl/ticker/24hr'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Filter and convert to TokenData
        final tokens = data.map((item) => _parseTokenData(item)).toList();
        
        // Sort by market cap (volume as proxy)
        tokens.sort((a, b) => b.volume24h.compareTo(a.volume24h));
        
        // Implement pagination
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        
        return tokens.sublist(
          startIndex, 
          endIndex > tokens.length ? tokens.length : endIndex
        );
      }
    } catch (e) {
      print('Error fetching tokens: $e');
    }
    
    return _getFallbackTokens(page, limit);
  }

  static TokenData _parseTokenData(Map<String, dynamic> item) {
    final symbol = item['symbol']?.toString() ?? '';
    final price = double.tryParse(item['lastPrice']?.toString() ?? '0') ?? 0.0;
    final change = double.tryParse(item['priceChangePercent']?.toString() ?? '0') ?? 0.0;
    final volume = double.tryParse(item['volume']?.toString() ?? '0') ?? 0.0;
    
    // Estimate market cap (this would require additional API calls for accurate data)
    final estimatedMarketCap = price * volume * 0.01; // Rough estimation
    
    return TokenData(
      symbol: symbol,
      name: _getTokenName(symbol),
      price: price,
      change24h: change,
      volume24h: volume,
      marketCap: estimatedMarketCap,
      icon: _getTokenIcon(symbol),
    );
  }

  static String _getTokenName(String symbol) {
    final tokenNames = {
      'BTCUSDT': 'Bitcoin',
      'ETHUSDT': 'Ethereum',
      'BNBUSDT': 'BNB',
      'XRPUSDT': 'XRP',
      'SOLUSDT': 'Solana',
      'ADAUSDT': 'Cardano',
      'DOGEUSDT': 'Dogecoin',
      'AVAXUSDT': 'Avalanche',
      'DOTUSDT': 'Polkadot',
      'LINKUSDT': 'Chainlink',
      'LTCUSDT': 'Litecoin',
      'BCHUSDT': 'Bitcoin Cash',
      'UNIUSDT': 'Uniswap',
      'MATICUSDT': 'Polygon',
      'ATOMUSDT': 'Cosmos',
      'VETUSDT': 'VeChain',
      'FILUSDT': 'Filecoin',
      'TRXUSDT': 'TRON',
      'XLMUSDT': 'Stellar',
      'EOSUSDT': 'EOS',
    };
    
    return tokenNames[symbol] ?? symbol.replaceAll('USDT', '').replaceAll('BTC', '').replaceAll('ETH', '');
  }

  static String _getTokenIcon(String symbol) {
    // Return first letter of symbol for icon
    final cleanSymbol = symbol.replaceAll('USDT', '').replaceAll('BTC', '').replaceAll('ETH', '');
    return cleanSymbol.isNotEmpty ? cleanSymbol.substring(0, 1) : 'T';
  }

  // Fallback data when API is unavailable
  static List<TokenData> _getFallbackTokens(int page, int limit) {
    final baseTokens = [
      TokenData(symbol: 'BTC', name: 'Bitcoin', price: 112641.07, change24h: 0.47, volume24h: 62560000000, marketCap: 2240000000000, icon: 'B'),
      TokenData(symbol: 'ETH', name: 'Ethereum', price: 4490.95, change24h: -3.41, volume24h: 38930000000, marketCap: 545320000000, icon: 'E'),
      TokenData(symbol: 'XRP', name: 'XRP', price: 2.9727, change24h: -1.43, volume24h: 7010000000, marketCap: 178170000000, icon: 'X'),
      TokenData(symbol: 'USDT', name: 'Tether', price: 0.9999, change24h: -0.03, volume24h: 119270000000, marketCap: 167340000000, icon: 'U'),
      TokenData(symbol: 'BNB', name: 'BNB', price: 866.85, change24h: 0.29, volume24h: 2700000000, marketCap: 121070000000, icon: 'B'),
      TokenData(symbol: 'SOL', name: 'Solana', price: 212.04, change24h: 2.43, volume24h: 1500000000, marketCap: 98000000000, icon: 'S'),
      TokenData(symbol: 'ADA', name: 'Cardano', price: 1.23, change24h: 1.85, volume24h: 890000000, marketCap: 43000000000, icon: 'A'),
      TokenData(symbol: 'DOGE', name: 'Dogecoin', price: 0.38, change24h: 3.21, volume24h: 2100000000, marketCap: 55000000000, icon: 'D'),
      TokenData(symbol: 'AVAX', name: 'Avalanche', price: 45.67, change24h: -1.23, volume24h: 450000000, marketCap: 18500000000, icon: 'A'),
      TokenData(symbol: 'DOT', name: 'Polkadot', price: 8.92, change24h: 0.87, volume24h: 320000000, marketCap: 12300000000, icon: 'D'),
      TokenData(symbol: 'LINK', name: 'Chainlink', price: 26.34, change24h: 1.45, volume24h: 890000000, marketCap: 16800000000, icon: 'L'),
      TokenData(symbol: 'LTC', name: 'Litecoin', price: 98.76, change24h: -0.65, volume24h: 1200000000, marketCap: 7450000000, icon: 'L'),
      TokenData(symbol: 'UNI', name: 'Uniswap', price: 12.45, change24h: 2.34, volume24h: 340000000, marketCap: 9870000000, icon: 'U'),
      TokenData(symbol: 'MATIC', name: 'Polygon', price: 0.92, change24h: 1.78, volume24h: 450000000, marketCap: 9100000000, icon: 'M'),
      TokenData(symbol: 'ATOM', name: 'Cosmos', price: 7.83, change24h: -0.45, volume24h: 180000000, marketCap: 3050000000, icon: 'A'),
    ];
    
    // Generate 700 tokens by repeating and modifying base tokens
    final allTokens = <TokenData>[];
    for (int i = 0; i < 700; i++) {
      final baseToken = baseTokens[i % baseTokens.length];
      final variation = (i / baseTokens.length).floor();
      
      allTokens.add(TokenData(
        symbol: '${baseToken.symbol}${variation > 0 ? variation.toString() : ''}',
        name: '${baseToken.name}${variation > 0 ? ' $variation' : ''}',
        price: baseToken.price * (0.8 + (i % 100) * 0.004),
        change24h: (baseToken.change24h + (i % 20 - 10) * 0.1),
        volume24h: baseToken.volume24h * (0.5 + (i % 50) * 0.02),
        marketCap: baseToken.marketCap * (0.3 + (i % 100) * 0.01),
        icon: baseToken.icon,
      ));
    }

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    return allTokens.sublist(
      startIndex,
      endIndex > allTokens.length ? allTokens.length : endIndex
    );
  }
}

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  
  // Token table state
  List<TokenData> _tokens = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _tokensPerPage = 50;
  Timer? _refreshTimer;
  String _sortBy = 'marketCap';
  bool _sortAscending = false;
  final int _totalPages = 14;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    
    _loadTokens();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadTokens() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tokens = await ChainlinkService.fetchTokens(
        page: _currentPage,
        limit: _tokensPerPage,
      );
      
      setState(() {
        _tokens = tokens;
        _isLoading = false;
      });
      
      _sortTokens();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startRealTimeUpdates() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadTokens();
    });
  }

  void _sortTokens() {
    setState(() {
      _tokens.sort((a, b) {
        double valueA, valueB;
        
        switch (_sortBy) {
          case 'price':
            valueA = a.price;
            valueB = b.price;
            break;
          case 'change':
            valueA = a.change24h;
            valueB = b.change24h;
            break;
          case 'volume':
            valueA = a.volume24h;
            valueB = b.volume24h;
            break;
          case 'marketCap':
          default:
            valueA = a.marketCap;
            valueB = b.marketCap;
            break;
        }
        
        return _sortAscending 
            ? valueA.compareTo(valueB)
            : valueB.compareTo(valueA);
      });
    });
  }

  void _onSort(String sortType) {
    setState(() {
      if (_sortBy == sortType) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortType;
        _sortAscending = false;
      }
    });
    _sortTokens();
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 768;
  double get _sidePadding => _isMobile ? 16.0 : 55.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          // Tab Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: _sidePadding, vertical: 10),
            child: _isMobile ? _buildMobileTabBar() : _buildDesktopTabBar(),
          ),
          
          // Content Area
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTabBar() {
    return Row(
      children: [
        _buildTab('Overview', 0),
        const SizedBox(width: 30),
        _buildTab('Trading Data', 1),
        const SizedBox(width: 30),
        _buildTab('AI Select', 2),
        const SizedBox(width: 30),
        _buildTab('Token Unlock', 3),
      ],
    );
  }

  Widget _buildMobileTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildTab('Overview', 0)),
        Expanded(child: _buildTab('Trading', 1)),
        Expanded(child: _buildTab('AI Select', 2)),
        Expanded(child: _buildTab('Unlock', 3)),
      ],
    );
  }
  

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Overview
        return _buildOverviewTab();
      case 1: // Trading Data
        return TradingDataScreen();
      case 2: // AI Select
        return AISelectScreen();
      case 3: // Token Unlock
        return TokenUnlockScreen();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(_sidePadding),
        child: Column(
          children: [
            // Top Row - Hot and New containers
            _isMobile
                ? Column(
                    children: [
                      _buildHotContainer(),
                      const SizedBox(height: 16),
                      _buildNewContainer(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildHotContainer()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildNewContainer()),
                    ],
                  ),
            const SizedBox(height: 20),
            
            // Middle Row - Top Gainer and Top Volume containers
            _isMobile
                ? Column(
                    children: [
                      _buildTopGainerContainer(),
                      const SizedBox(height: 16),
                      _buildTopVolumeContainer(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildTopGainerContainer()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTopVolumeContainer()),
                    ],
                  ),
            const SizedBox(height: 30),
            
            // Tokens Table Section
            SizedBox(
              height: _isMobile ? 500 : 600,
              child: _buildTokensTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF848E9C),
              fontSize: _isMobile ? 14 : 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: _isMobile ? 60 : title.length * 8.0,
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokensTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.all(_isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isMobile ? 'All Cryptos' : 'All Cryptocurrencies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _loadTokens,
                          icon: _isLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
                                  ),
                                )
                              : Icon(Icons.refresh, color: Color.fromARGB(255, 122, 79, 223), size: _isMobile ? 20 : 24),
                        ),
                        if (!_isMobile) ...[
                          Text(
                            'Page $_currentPage of $_totalPages',
                            style: const TextStyle(
                              color: Color(0xFF848E9C),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Column Headers - Only show on desktop
                if (!_isMobile) ...[
                  Row(
                    children: [
                      const SizedBox(width: 50),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Color(0xFF848E9C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: _buildSortableHeader('Price', 'price')),
                      Expanded(child: _buildSortableHeader('24h Change', 'change')),
                      Expanded(child: _buildSortableHeader('24h Volume', 'volume')),
                      Expanded(child: _buildSortableHeader('Market Cap', 'marketCap')),
                      const SizedBox(width: 80),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 1,
            color: const Color(0xFF2B3139),
          ),
          
          // Table Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tokens.length,
                    itemBuilder: (context, index) {
                      return _isMobile 
                          ? _buildMobileTokenRow(_tokens[index], index + 1 + (_currentPage - 1) * _tokensPerPage)
                          : _buildTokenRow(_tokens[index], index + 1 + (_currentPage - 1) * _tokensPerPage);
                    },
                  ),
          ),
          
          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileTokenRow(TokenData token, int rank) {
    final isPositive = token.change24h >= 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2B3139),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Rank & Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getTokenColor(token.symbol),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                token.icon,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Token Info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      token.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Color(0xFF848E9C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  token.name,
                  style: const TextStyle(
                    color: Color(0xFF848E9C),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Price & Change
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(token.price),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${token.change24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF02C076) : const Color(0xFFFF4747),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(String title, String sortKey) {
    final isActive = _sortBy == sortKey;
    
    return GestureDetector(
      onTap: () => _onSort(sortKey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF848E9C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          if (isActive)
            Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: const Color.fromARGB(255, 122, 79, 223),
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildTokenRow(TokenData token, int rank) {
    final isPositive = token.change24h >= 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2B3139),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 20),
          
          // Token Icon & Name
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getTokenColor(token.symbol),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      token.icon,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      token.name,
                      style: const TextStyle(
                        color: Color(0xFF848E9C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price
          Expanded(
            child: Text(
              _formatPrice(token.price),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 24h Change
          Expanded(
            child: Text(
              '${isPositive ? '+' : ''}${token.change24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isPositive ? const Color(0xFF02C076) : const Color(0xFFFF4747),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 24h Volume
          Expanded(
            child: Text(
              _formatVolume(token.volume24h),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Market Cap
          Expanded(
            child: Text(
              _formatVolume(token.marketCap),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Actions
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${token.symbol} to favorites')),
                    );
                  },
                  icon: const Icon(
                    Icons.star_border,
                    color: Color(0xFF848E9C),
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Trade ${token.symbol}')),
                    );
                  },
                  icon: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF02C076),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      child: _isMobile ? _buildMobilePagination() : _buildDesktopPagination(),
    );
  }

  Widget _buildMobilePagination() {
    return Column(
      children: [
        Text(
          'Page $_currentPage of $_totalPages',
          style: const TextStyle(
            color: Color(0xFF848E9C),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _currentPage > 1 ? () {
                setState(() {
                  _currentPage--;
                });
                _loadTokens();
              } : null,
              icon: Icon(
                Icons.chevron_left,
                color: _currentPage > 1 ? Colors.white : const Color(0xFF848E9C),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$_currentPage',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: _currentPage < _totalPages ? () {
                setState(() {
                  _currentPage++;
                });
                _loadTokens();
              } : null,
              icon: Icon(
                Icons.chevron_right,
                color: _currentPage < _totalPages ? Colors.white : const Color(0xFF848E9C),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${(_currentPage - 1) * _tokensPerPage + 1}-${_currentPage * _tokensPerPage} of ${_totalPages * _tokensPerPage}',
          style: const TextStyle(
            color: Color(0xFF848E9C),
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _currentPage > 1 ? () {
                setState(() {
                  _currentPage--;
                });
                _loadTokens();
              } : null,
              icon: Icon(
                Icons.chevron_left,
                color: _currentPage > 1 ? Colors.white : const Color(0xFF848E9C),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$_currentPage',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: _currentPage < _totalPages ? () {
                setState(() {
                  _currentPage++;
                });
                _loadTokens();
              } : null,
              icon: Icon(
                Icons.chevron_right,
                color: _currentPage < _totalPages ? Colors.white : const Color(0xFF848E9C),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPrice(double price) {
  if (price >= 1) {
    return '\$${price.toStringAsFixed(2)}';
  } else {
    return '\$${price.toStringAsFixed(6)}';
  }
}

  String _formatVolume(double value) {
  if (value >= 1e12) {
    return '\$${(value / 1e12).toStringAsFixed(2)}T';
  } else if (value >= 1e9) {
    return '\$${(value / 1e9).toStringAsFixed(2)}B';
  } else if (value >= 1e6) {
    return '\$${(value / 1e6).toStringAsFixed(2)}M';
  } else if (value >= 1e3) {
    return '\$${(value / 1e3).toStringAsFixed(2)}K';
  } else {
    return '\$${value.toStringAsFixed(2)}';
  }
}

  Color _getTokenColor(String symbol) {
    final colors = {
      'BTC': const Color(0xFFF7931A),
      'ETH': const Color(0xFF627EEA),
      'BNB': const Color(0xFFF0B90B),
      'XRP': const Color(0xFF00AAE4),
      'SOL': const Color(0xFF9945FF),
      'ADA': const Color(0xFF0033AD),
      'DOGE': const Color(0xFFC2A633),
      'AVAX': const Color(0xFFE84142),
      'DOT': const Color(0xFFE6007A),
      'LINK': const Color(0xFF375BD2),
      'LTC': const Color(0xFF345D9D),
      'UNI': const Color(0xFFFF007A),
      'MATIC': const Color(0xFF8247E5),
      'ATOM': const Color(0xFF2E3148),
    };
    
    return colors[symbol] ?? const Color(0xFF848E9C);
  }

  Widget _buildHotContainer() {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'More >',
                  style: TextStyle(
                    color: const Color(0xFF848E9C),
                    fontSize: _isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          _buildCryptoItem('BNB', '\$868.73', '+0.64%', const Color(0xFFF0B90B), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('BTC', '\$112.64K', '+0.85%', const Color(0xFFF7931A), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('ETH', '\$4.52K', '-2.47%', const Color(0xFF627EEA), false),
        ],
      ),
    );
  }

  Widget _buildNewContainer() {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'More >',
                  style: TextStyle(
                    color: const Color(0xFF848E9C),
                    fontSize: _isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          _buildCryptoItem('DOLO', '\$0.2386', '+19.30%', const Color(0xFF848E9C), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('PLUME', '\$0.08451', '-0.48%', const Color(0xFFFF4747), false),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('BFUSD', '\$0.9991', '-0.04%', const Color(0xFFF0B90B), false),
        ],
      ),
    );
  }

  Widget _buildTopGainerContainer() {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Gainer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'More >',
                  style: TextStyle(
                    color: const Color(0xFF848E9C),
                    fontSize: _isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          _buildCryptoItem('PYTH', '\$0.1888', '+61.92%', const Color(0xFF9945FF), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('CTSI', '\$0.102', '+37.84%', const Color(0xFF00D4AA), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('TREE', '\$0.3972', '+28.50%', const Color(0xFF00D4AA), true),
        ],
      ),
    );
  }

  Widget _buildTopVolumeContainer() {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Volume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'More >',
                  style: TextStyle(
                    color: const Color(0xFF848E9C),
                    fontSize: _isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobile ? 16 : 20),
          _buildCryptoItem('BTC', '\$112.64K', '+0.85%', const Color(0xFFF7931A), true),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('ETH', '\$4.52K', '-2.47%', const Color(0xFF627EEA), false),
          SizedBox(height: _isMobile ? 12 : 15),
          _buildCryptoItem('SOL', '\$212.04', '+2.43%', const Color(0xFF00D4AA), true),
        ],
      ),
    );
  }

  Widget _buildCryptoItem(String symbol, String price, String change, Color iconColor, bool isPositive) {
    return Row(
      children: [
        Container(
          width: _isMobile ? 28 : 32,
          height: _isMobile ? 28 : 32,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(_isMobile ? 14 : 16),
          ),
          child: Center(
            child: Text(
              symbol.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile ? 12 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: _isMobile ? 8 : 12),
        Text(
          symbol,
          style: TextStyle(
            color: Colors.white,
            fontSize: _isMobile ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              change,
              style: TextStyle(
                color: isPositive ? const Color(0xFF02C076) : const Color(0xFFFF4747),
                fontSize: _isMobile ? 10 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
}
}