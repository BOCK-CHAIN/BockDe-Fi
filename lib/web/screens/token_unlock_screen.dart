import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TokenUnlockScreen extends StatefulWidget {
  const TokenUnlockScreen({super.key});

  @override
  State<TokenUnlockScreen> createState() => _TokenUnlockScreenState();
}

class _TokenUnlockScreenState extends State<TokenUnlockScreen> {
  List<TokenUnlockData> tokenData = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 20;
  int itemsPerPage = 50; // Changed from 50 to 50 as requested
  Timer? refreshTimer;
  String searchQuery = '';
  String sortBy = 'market_cap';
  bool sortAscending = false;

  @override
  void initState() {
    super.initState();
    fetchTokenData();
    // Refresh data every 30 seconds
    refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchTokenData();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTokenData() async {
    try {
      // Using CoinGecko API as it's free and reliable
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$itemsPerPage&page=$currentPage&sparkline=false&price_change_percentage=24h',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tokenData = data.map((item) => TokenUnlockData.fromJson(item)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching token data: $e');
    }
  }

  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
        isLoading = true;
      });
      fetchTokenData();
    }
  }

  void sortData(String column) {
    setState(() {
      if (sortBy == column) {
        sortAscending = !sortAscending;
      } else {
        sortBy = column;
        sortAscending = false;
      }

      tokenData.sort((a, b) {
        dynamic aVal, bVal;
        switch (column) {
          case 'name':
            aVal = a.name.toLowerCase();
            bVal = b.name.toLowerCase();
            break;
          case 'price':
            aVal = a.currentPrice;
            bVal = b.currentPrice;
            break;
          case 'change':
            aVal = a.priceChange24h ?? 0;
            bVal = b.priceChange24h ?? 0;
            break;
          case 'market_cap':
            aVal = a.marketCap ?? 0;
            bVal = b.marketCap ?? 0;
            break;
          case 'supply':
            aVal = a.circulatingSupply ?? 0;
            bVal = b.circulatingSupply ?? 0;
            break;
          default:
            return 0;
        }
        return sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        title: const Text(
          'Token Unlock',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchTokenData();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters section
          Container(
            // Increased desktop padding
            padding: MediaQuery.of(context).size.width > 768 
                ? EdgeInsets.all(32) // Increased from 16 for desktop
                : EdgeInsets.all(16), // Keep original for mobile
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2329),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search tokens...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2329),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'All Tokens',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Table section with scrolling
          Expanded(
            child: Container(
              // Increased desktop margin
              height: 1000,
              margin: MediaQuery.of(context).size.width > 768 
                  ? EdgeInsets.symmetric(horizontal: 32) // Increased from 16 for desktop
                  : EdgeInsets.symmetric(horizontal: 16), // Keep original for mobile
              decoration: BoxDecoration(
                color: const Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2B3139), width: 1),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 768 
                      ? MediaQuery.of(context).size.width - 64
                      : 1200, // Fixed width for mobile to enable horizontal scrolling
                  child: Column(
                    children: [
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3139),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell('Name', 'name', flex: 3),
                            _buildHeaderCell('Price', 'price', flex: 2),
                            _buildHeaderCell('24H %', 'change', flex: 2),
                            _buildHeaderCell('Market Cap', 'market_cap', flex: 2),
                            _buildHeaderCell('Cir.Supply', 'supply', flex: 2),
                            _buildHeaderCell('Total Unlocked', 'unlocked', flex: 2),
                            _buildHeaderCell('Next Unlock', 'next_unlock', flex: 2),
                            _buildHeaderCell('Next Unlock Date', 'unlock_date', flex: 2),
                          ],
                        ),
                      ),

                      // Table content
                      Expanded(
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredTokenData.length,
                                itemBuilder: (context, index) {
                                  final token = filteredTokenData[index];
                                  return _buildTokenRow(token, index);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  List<TokenUnlockData> get filteredTokenData {
    if (searchQuery.isEmpty) return tokenData;
    return tokenData.where((token) =>
      token.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      token.symbol.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  Widget _buildHeaderCell(String title, String column, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => sortData(column),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF848E9C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (sortBy == column) ...[
                const SizedBox(width: 4),
                Icon(
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: const Color.fromARGB(255, 122, 79, 223),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenRow(TokenUnlockData token, int index) {
    final isEven = index % 2 == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? Color(0xFF1E2329) : Color(0xFF181A20),
      ),
      child: Row(
        children: [
          // Name with logo
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    token.image,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3139),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.currency_bitcoin,
                          size: 16,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        token.symbol.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF848E9C),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Price
          Expanded(
            flex: 2,
            child: Text(
              '\$${token.currentPrice.toStringAsFixed(token.currentPrice < 1 ? 6 : 2)}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // 24H Change
          Expanded(
            flex: 2,
            child: Text(
              '${token.priceChange24h?.toStringAsFixed(2) ?? '0.00'}%',
              style: TextStyle(
                color: (token.priceChange24h ?? 0) >= 0
                    ? const Color(0xFF03A66D)
                    : const Color(0xFFF6465D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Market Cap
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(token.marketCap ?? 0),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // Circulating Supply
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(token.circulatingSupply ?? 0),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // Total Unlocked
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(token.totalUnlocked),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // Next Unlock
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(token.nextUnlock),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // Next Unlock Date
          Expanded(
            flex: 2,
            child: Text(
              token.nextUnlockDate,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      // Increased desktop padding
      padding: MediaQuery.of(context).size.width > 768 
          ? EdgeInsets.all(32) // Increased from 16 for desktop
          : EdgeInsets.all(16), // Keep original for mobile
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF2B3139), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(currentPage - 1) * itemsPerPage + 1}-${currentPage * itemsPerPage} of ${totalPages * itemsPerPage}',
            style: const TextStyle(color: Color(0xFF848E9C), fontSize: 14),
          ),
          Row(
            children: [
              _buildPageButton(Icons.first_page, () => changePage(1)),
              _buildPageButton(Icons.chevron_left, () => changePage(currentPage - 1)),
              
              // Page numbers
              ...List.generate(
                5,
                (index) {
                  int pageNum = currentPage - 2 + index;
                  if (pageNum < 1 || pageNum > totalPages) return const SizedBox.shrink();
                  return _buildPageNumberButton(pageNum);
                },
              ),
              
              _buildPageButton(Icons.chevron_right, () => changePage(currentPage + 1)),
              _buildPageButton(Icons.last_page, () => changePage(totalPages)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF1E2329),
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(32, 32),
        ),
      ),
    );
  }

  Widget _buildPageNumberButton(int pageNumber) {
    final isActive = pageNumber == currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () => changePage(pageNumber),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? const Color.fromARGB(255, 122, 79, 223) : const Color(0xFF1E2329),
          foregroundColor: isActive ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(32, 32),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1e12) {
      return '\$${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '\$${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return '\$${number.toStringAsFixed(2)}';
    }
  }
}

class TokenUnlockData {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double? marketCap;
  final double? marketCapRank;
  final double? fullyDilutedValuation;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? marketCapChange24h;
  final double? marketCapChangePercentage24h;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final String lastUpdated;

  // Mock unlock data (in real implementation, this would come from a token unlock API)
  final double totalUnlocked;
  final double nextUnlock;
  final String nextUnlockDate;

  TokenUnlockData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.lastUpdated,
    required this.totalUnlocked,
    required this.nextUnlock,
    required this.nextUnlockDate,
  });

  factory TokenUnlockData.fromJson(Map<String, dynamic> json) {
    // Generate mock unlock data based on circulating supply
    double circulatingSupply = (json['circulating_supply'] ?? 0).toDouble();
    double totalSupply = (json['total_supply'] ?? circulatingSupply * 1.5).toDouble();
    
    // Mock calculations for unlock data
    double totalUnlocked = circulatingSupply;
    double nextUnlock = (totalSupply - circulatingSupply) * 0.1; // 10% of remaining supply
    
    // Generate random future dates for next unlock
    List<String> futureDates = [
      '2025-09-15',
      '2025-10-01',
      '2025-10-30',
      '2025-11-15',
      '2025-12-01',
      '2026-01-01',
      '2026-02-15',
      '2026-03-01',
    ];
    String randomDate = futureDates[json['symbol'].hashCode % futureDates.length];

    return TokenUnlockData(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      marketCap: json['market_cap']?.toDouble(),
      marketCapRank: json['market_cap_rank']?.toDouble(),
      fullyDilutedValuation: json['fully_diluted_valuation']?.toDouble(),
      totalVolume: json['total_volume']?.toDouble(),
      high24h: json['high_24h']?.toDouble(),
      low24h: json['low_24h']?.toDouble(),
      priceChange24h: json['price_change_24h']?.toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble(),
      marketCapChange24h: json['market_cap_change_24h']?.toDouble(),
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h']?.toDouble(),
      circulatingSupply: circulatingSupply,
      totalSupply: json['total_supply']?.toDouble(),
      maxSupply: json['max_supply']?.toDouble(),
      lastUpdated: json['last_updated'] ?? DateTime.now().toIso8601String(),
      totalUnlocked: totalUnlocked,
      nextUnlock: nextUnlock,
      nextUnlockDate: randomDate,
    );
  }
}