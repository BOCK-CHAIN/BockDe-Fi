import 'package:bockchain/widgets/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AISelectScreen extends StatefulWidget {
  @override
  _AISelectScreenState createState() => _AISelectScreenState();
}

class _AISelectScreenState extends State<AISelectScreen> {
  List<Map<String, dynamic>> aiTokens = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 38;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchAITokens();
  }

  Future<void> fetchAITokens() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Using CoinGecko API for real-time data
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&category=artificial-intelligence&order=market_cap_desc&per_page=250&page=1'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        setState(() {
          aiTokens = data.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> token = entry.value;
            
            return {
              'name': token['name'] ?? 'Unknown',
              'symbol': token['symbol']?.toString().toUpperCase() ?? 'N/A',
              'rank': index + 1,
              'aiRating': _generateAIRating(), // Simulated AI rating
              'price': token['current_price']?.toDouble() ?? 0.0,
              'priceChange24h': token['price_change_percentage_24h']?.toDouble() ?? 0.0,
              'socialVol24h': _generateSocialVolume(), // Simulated social volume
              'socialScore': _generateSocialScore(), // Simulated social score
              'newsCount': _generateNewsCount(), // Simulated news count
              'kolScore': _generateKOLScore(), // Simulated KOL score
              'image': token['image'] ?? '',
              'marketCap': token['market_cap']?.toDouble() ?? 0.0,
            };
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double _generateAIRating() => (3.0 + (2.0 * (0.5 - (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)));
  int _generateSocialVolume() => 50000 + (DateTime.now().millisecondsSinceEpoch % 100000);
  double _generateSocialScore() => 60.0 + (40.0 * (0.5 - (DateTime.now().millisecondsSinceEpoch % 1000) / 1000));
  int _generateNewsCount() => 5 + (DateTime.now().millisecondsSinceEpoch % 20);
  double _generateKOLScore() => 70.0 + (30.0 * (0.5 - (DateTime.now().millisecondsSinceEpoch % 1000) / 1000));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0E11),
        elevation: 0,
        title: Text(
          'AI Select',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchAITokens,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top 3 containers section
          _buildTopContainers(),
          
          // Table section
          Expanded(
            child: _buildDataTable(),
          ),
          
          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildTopContainers() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildInfoContainer("Total Market Cap", "\$125.4B", "+2.34%", true)),
          SizedBox(width: 12),
          Expanded(child: _buildInfoContainer("24h Volume", "\$8.9B", "-1.23%", false)),
          SizedBox(width: 12),
          Expanded(child: _buildInfoContainer("AI Tokens", "${aiTokens.length}", "+5.67%", true)),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value, String change, bool isPositive) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF848E9C),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: isPositive ? Color(0xFF03A66D) : Color(0xFFF84638),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF2B3139),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildHeaderCell("Name")),
                Expanded(flex: 1, child: _buildHeaderCell("Rank")),
                Expanded(flex: 2, child: _buildHeaderCell("AI Rating")),
                Expanded(flex: 2, child: _buildHeaderCell("Price")),
                Expanded(flex: 2, child: _buildHeaderCell("24h Social Vol")),
                Expanded(flex: 2, child: _buildHeaderCell("Social")),
                Expanded(flex: 1, child: _buildHeaderCell("News")),
                Expanded(flex: 2, child: _buildHeaderCell("KOL")),
              ],
            ),
          ),
          
          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: _getPageItems().length,
              itemBuilder: (context, index) {
                final token = _getPageItems()[index];
                return _buildTableRow(token, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF848E9C),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> token, int index) {
    bool isEven = index % 2 == 0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? Color(0xFF1E2329) : Color(0xFF181A20),
      ),
      child: Row(
        children: [
          // Name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      token['symbol'].substring(0, 1),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token['name'],
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        token['symbol'],
                        style: TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Rank
          Expanded(
            flex: 1,
            child: Text(
              '#${token['rank']}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          
          // AI Rating
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ...List.generate(5, (i) {
                  return Icon(
                    Icons.star,
                    size: 12,
                    color: i < token['aiRating'].floor() 
                        ? Color.fromARGB(255, 122, 79, 223) 
                        : Color(0xFF2B3139),
                  );
                }),
                SizedBox(width: 4),
                Text(
                  token['aiRating'].toStringAsFixed(1),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Price
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${token['price'].toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${token['priceChange24h'] >= 0 ? '+' : ''}${token['priceChange24h'].toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: token['priceChange24h'] >= 0 ? Color(0xFF03A66D) : Color(0xFFF84638),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 24h Social Vol
          Expanded(
            flex: 2,
            child: Text(
              '${(token['socialVol24h'] / 1000).toStringAsFixed(1)}K',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          
          // Social
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Color(0xFF2B3139),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: token['socialScore'] / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF03A66D),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '${token['socialScore'].toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // News
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2B3139)),
              ),
              child: Text(
                '${token['newsCount']}',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // KOL
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Color(0xFF2B3139),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: token['kolScore'] / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '${token['kolScore'].toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPageItems() {
    int itemsPerPage = 20;
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    
    if (startIndex >= aiTokens.length) return [];
    if (endIndex > aiTokens.length) endIndex = aiTokens.length;
    
    return aiTokens.sublist(startIndex, endIndex);
  }

  Widget _buildPagination() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1 ? () {
              setState(() {
                currentPage--;
              });
            } : null,
            icon: Icon(
              Icons.chevron_left,
              color: currentPage > 1 ? Colors.white : Color(0xFF848E9C),
            ),
          ),
          
          // Page numbers
          Row(
            children: _buildPageNumbers(),
          ),
          
          IconButton(
            onPressed: currentPage < totalPages ? () {
              setState(() {
                currentPage++;
              });
            } : null,
            icon: Icon(
              Icons.chevron_right,
              color: currentPage < totalPages ? Colors.white : Color(0xFF848E9C),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];
    int start = (currentPage - 2).clamp(1, totalPages);
    int end = (currentPage + 2).clamp(1, totalPages);

    if (start > 1) {
      pages.add(_buildPageButton(1));
      if (start > 2) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('...', style: TextStyle(color: Color(0xFF848E9C))),
        ));
      }
    }

    for (int i = start; i <= end; i++) {
      pages.add(_buildPageButton(i));
    }

    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('...', style: TextStyle(color: Color(0xFF848E9C))),
        ));
      }
      pages.add(_buildPageButton(totalPages));
    }

    return pages;
  }

  Widget _buildPageButton(int page) {
    bool isSelected = page == currentPage;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = page;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}