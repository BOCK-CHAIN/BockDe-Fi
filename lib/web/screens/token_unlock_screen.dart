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
  int itemsPerPage = 50;
  Timer? refreshTimer;
  String searchQuery = '';
  String sortBy = 'market_cap';
  bool sortAscending = false;

  @override
  void initState() {
    super.initState();
    fetchTokenData();
    refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
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
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets'
          '?vs_currency=usd'
          '&order=market_cap_desc'
          '&per_page=$itemsPerPage'
          '&page=$currentPage'
          '&sparkline=false'
          '&price_change_percentage=24h',
        ),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          tokenData = data.map((e) => TokenUnlockData.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void changePage(int page) {
    if (page < 1 || page > totalPages) return;
    setState(() {
      currentPage = page;
      isLoading = true;
    });
    fetchTokenData();
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
          case 'market_cap':
            aVal = a.marketCap ?? 0;
            bVal = b.marketCap ?? 0;
            break;
          default:
            return 0;
        }
        return sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  List<TokenUnlockData> get filteredTokenData {
    if (searchQuery.isEmpty) return tokenData;
    return tokenData.where((t) =>
        t.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        t.symbol.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        title: const Text(
          'Token Unlock',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              fetchTokenData();
            },
          )
        ],
      ),

      /// ✅ FULL PAGE SCROLL
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTable(),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Search tokens...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF1E2329),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onChanged: (v) => setState(() => searchQuery = v),
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B3139)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1200,
          child: Column(
            children: [
              _buildHeader(),
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 122, 79, 223),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTokenData.length,
                      itemBuilder: (c, i) =>
                          _buildRow(filteredTokenData[i], i),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF2B3139),
      child: Row(
        children: [
          _header('Name', 'name', 3),
          _header('Price', 'price', 2),
          _header('Market Cap', 'market_cap', 2),
          _header('Unlocked', '', 2),
          _header('Next Unlock', '', 2),
          _header('Date', '', 2),
        ],
      ),
    );
  }

  Widget _header(String t, String c, int f) {
    return Expanded(
      flex: f,
      child: GestureDetector(
        onTap: c.isEmpty ? null : () => sortData(c),
        child: Text(t,
            style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12)),
      ),
    );
  }

  Widget _buildRow(TokenUnlockData t, int i) {
    return Container(
      color: i.isEven ? const Color(0xFF1E2329) : const Color(0xFF181A20),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(t.name, style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Text('\$${t.currentPrice}', style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Text(_fmt(t.marketCap ?? 0), style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Text(_fmt(t.totalUnlocked), style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Text(_fmt(t.nextUnlock), style: const TextStyle(color: Colors.white))),
          Expanded(flex: 2, child: Text(t.nextUnlockDate, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () => changePage(currentPage - 1), icon: const Icon(Icons.chevron_left)),
          Text('$currentPage / $totalPages', style: const TextStyle(color: Colors.white)),
          IconButton(onPressed: () => changePage(currentPage + 1), icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  String _fmt(double n) {
    if (n >= 1e9) return '\$${(n / 1e9).toStringAsFixed(2)}B';
    if (n >= 1e6) return '\$${(n / 1e6).toStringAsFixed(2)}M';
    return '\$${n.toStringAsFixed(2)}';
  }
}

/* -------------------- MODEL -------------------- */

class TokenUnlockData {
  final String id, symbol, name, image;
  final double currentPrice;
  final double? marketCap;
  final double totalUnlocked, nextUnlock;
  final String nextUnlockDate;

  TokenUnlockData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.totalUnlocked,
    required this.nextUnlock,
    required this.nextUnlockDate,
  });

  factory TokenUnlockData.fromJson(Map<String, dynamic> j) {
    double circ = (j['circulating_supply'] ?? 0).toDouble();
    double total = (j['total_supply'] ?? circ * 1.5).toDouble();

    return TokenUnlockData(
      id: j['id'] ?? '',
      symbol: j['symbol'] ?? '',
      name: j['name'] ?? '',
      image: j['image'] ?? '',
      currentPrice: (j['current_price'] ?? 0).toDouble(),
      marketCap: j['market_cap']?.toDouble(),
      totalUnlocked: circ,
      nextUnlock: (total - circ) * 0.1,
      nextUnlockDate: '2025-10-01',
    );
  }
}
