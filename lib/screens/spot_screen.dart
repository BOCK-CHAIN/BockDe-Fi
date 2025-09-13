import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class SpotScreen extends StatefulWidget {
  @override
  _SpotScreenState createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late Timer _priceTimer;
  
  // Market Data
  double currentPrice = 205.12;
  double priceChange = 12.45;
  double priceChangePercent = 6.47;
  double volume24h = 1234567.89;
  double high24h = 215.89;
  double low24h = 192.34;
  
  // Candlestick Data
  List<CandlestickData> candlestickData = [];
  
  // Time intervals
  List<String> timeIntervals = ['1m', '5m', '15m', '1h', '4h', '1d', '1w'];
  int selectedInterval = 3; // 1h selected by default
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateInitialCandlestickData();
    _startPriceUpdates();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _priceTimer.cancel();
    super.dispose();
  }
  
  void _generateInitialCandlestickData() {
    final random = Random();
    final now = DateTime.now();
    
    for (int i = 100; i >= 0; i--) {
      final time = now.subtract(Duration(hours: i));
      final basePrice = 200 + random.nextDouble() * 20;
      final open = basePrice + (random.nextDouble() - 0.5) * 10;
      final close = open + (random.nextDouble() - 0.5) * 8;
      final high = max(open, close) + random.nextDouble() * 5;
      final low = min(open, close) - random.nextDouble() * 5;
      final volume = 1000 + random.nextDouble() * 5000;
      
      candlestickData.add(CandlestickData(
        time: time,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
    }
  }
  
  void _startPriceUpdates() {
    _priceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Simulate price movement
        final random = Random();
        final change = (random.nextDouble() - 0.5) * 2;
        currentPrice += change;
        priceChange += change * 0.1;
        priceChangePercent = (priceChange / (currentPrice - priceChange)) * 100;
        
        // Update latest candlestick
        if (candlestickData.isNotEmpty) {
          final latest = candlestickData.last;
          candlestickData[candlestickData.length - 1] = CandlestickData(
            time: latest.time,
            open: latest.open,
            high: max(latest.high, currentPrice),
            low: min(latest.low, currentPrice),
            close: currentPrice,
            volume: latest.volume + random.nextDouble() * 100,
          );
        }
        
        // Add new candlestick every 30 seconds
        if (timer.tick % 15 == 0) {
          final newCandle = CandlestickData(
            time: DateTime.now(),
            open: currentPrice,
            high: currentPrice,
            low: currentPrice,
            close: currentPrice,
            volume: random.nextDouble() * 1000,
          );
          candlestickData.add(newCandle);
          
          // Keep only last 100 candles
          if (candlestickData.length > 100) {
            candlestickData.removeAt(0);
          }
        }
      });
    });
  }

  // Get responsive padding based on screen width
  EdgeInsets _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      // Desktop: increased padding
      return EdgeInsets.all(32);
    } else if (screenWidth > 800) {
      // Tablet
      return EdgeInsets.all(20);
    } else {
      // Mobile
      return EdgeInsets.all(12);
    }
  }

  // Get responsive horizontal padding
  EdgeInsets _getResponsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      // Desktop: increased padding
      return EdgeInsets.symmetric(horizontal: 55);
    } else if (screenWidth > 800) {
      // Tablet
      return EdgeInsets.symmetric(horizontal: 20);
    } else {
      // Mobile
      return EdgeInsets.symmetric(horizontal: 12);
    }
  }

  // Get responsive font size
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return baseFontSize * 0.9;
    }
    return baseFontSize;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildPriceHeader(context),
          _buildTimeIntervals(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChartTab(context),
                _buildInfoTab(context),
                _buildTradingDataTab(context),
                _buildTradingAnalysisTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return AppBar(
      backgroundColor: Color(0xFF0B0E11),
      elevation: 0,
      leading: Icon(Icons.arrow_back, color: Colors.white),
      title: Row(
        children: [
          CircleAvatar(
            radius: isSmallScreen ? 10 : 12,
            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            child: Text('S', style: TextStyle(
              color: Colors.white, 
              fontSize: isSmallScreen ? 10 : 12
            )),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Text('SOL/USDT', style: TextStyle(
            color: Colors.white, 
            fontSize: _getResponsiveFontSize(context, 18)
          )),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 4 : 6, 
              vertical: 2
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('Spot', style: TextStyle(
              color: Colors.white, 
              fontSize: isSmallScreen ? 8 : 10
            )),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.star_border, color: Colors.white, 
            size: isSmallScreen ? 20 : 24), 
          onPressed: () {}
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white,
            size: isSmallScreen ? 20 : 24), 
          onPressed: () {}
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Color.fromARGB(255, 122, 79, 223),
        labelColor: Color.fromARGB(255, 122, 79, 223),
        unselectedLabelColor: Colors.grey,
        isScrollable: screenWidth < 500, // Make tabs scrollable on small screens
        labelStyle: TextStyle(fontSize: _getResponsiveFontSize(context, 14)),
        unselectedLabelStyle: TextStyle(fontSize: _getResponsiveFontSize(context, 14)),
        tabs: [
          Tab(text: 'Chart'),
          Tab(text: 'Info'),
          Tab(text: screenWidth < 400 ? 'Data' : 'Trading Data'),
          Tab(text: screenWidth < 400 ? 'Analysis' : 'Trading Analysis'),
        ],
      ),
    );
  }
  
  Widget _buildPriceHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      padding: _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '\$${currentPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: priceChange >= 0 ? Color(0xFF00D4AA) : Color(0xFFFF6B6B),
                  fontSize: _getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8, 
                  vertical: 4
                ),
                decoration: BoxDecoration(
                  color: priceChange >= 0 ? Color(0xFF00D4AA) : Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${priceChange >= 0 ? '+' : ''}${priceChangePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: _getResponsiveFontSize(context, 12)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          screenWidth < 500 ? 
          // Vertical layout for small screens
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatItem(context, '24h Vol', '${(volume24h / 1000).toStringAsFixed(0)}K'),
              SizedBox(height: 8),
              _buildStatItem(context, '24h High', '\$${high24h.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              _buildStatItem(context, '24h Low', '\$${low24h.toStringAsFixed(2)}'),
            ],
          ) :
          // Horizontal layout for larger screens
          Row(
            children: [
              _buildStatItem(context, '24h Vol', '${(volume24h / 1000).toStringAsFixed(0)}K'),
              SizedBox(width: 20),
              _buildStatItem(context, '24h High', '\$${high24h.toStringAsFixed(2)}'),
              SizedBox(width: 20),
              _buildStatItem(context, '24h Low', '\$${low24h.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: Colors.grey, 
          fontSize: _getResponsiveFontSize(context, 12)
        )),
        Text(value, style: TextStyle(
          color: Colors.white, 
          fontSize: _getResponsiveFontSize(context, 14)
        )),
      ],
    );
  }
  
  Widget _buildTimeIntervals(BuildContext context) {
    return Container(
      height: 40,
      padding: _getResponsiveHorizontalPadding(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timeIntervals.length,
        itemBuilder: (context, index) {
          final isSelected = selectedInterval == index;
          return GestureDetector(
            onTap: () => setState(() => selectedInterval = index),
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                timeIntervals[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: _getResponsiveFontSize(context, 14),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildChartTab(BuildContext context) {
    return Container(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: CandlestickChart(data: candlestickData),
          ),
          SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: VolumeChart(data: candlestickData),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(context, 'About Solana', 
            'Solana is a high-performance blockchain platform designed to host decentralized, scalable applications. It can process over 50,000 transactions per second with low fees.'),
          SizedBox(height: 20),
          _buildInfoSection(context, 'Market Cap', '\$96.2B'),
          _buildInfoSection(context, 'Circulating Supply', '468.7M SOL'),
          _buildInfoSection(context, 'Total Supply', '588.4M SOL'),
          _buildInfoSection(context, 'All-time High', '\$259.96'),
          _buildInfoSection(context, 'All-time Low', '\$0.50'),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(
          color: Colors.white, 
          fontSize: _getResponsiveFontSize(context, 16), 
          fontWeight: FontWeight.bold
        )),
        SizedBox(height: 8),
        Text(content, style: TextStyle(
          color: Colors.grey, 
          fontSize: _getResponsiveFontSize(context, 14)
        )),
        SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildTradingDataTab(BuildContext context) {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          _buildOrderBook(context),
          SizedBox(height: 20),
          _buildRecentTrades(context),
        ],
      ),
    );
  }
  
  Widget _buildOrderBook(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Book', style: TextStyle(
          color: Colors.white, 
          fontSize: _getResponsiveFontSize(context, 18), 
          fontWeight: FontWeight.bold
        )),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Text('Price (USDT)', style: TextStyle(
              color: Colors.grey,
              fontSize: _getResponsiveFontSize(context, 12)
            ))),
            Expanded(child: Text(isSmallScreen ? 'Amount' : 'Amount (SOL)', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: _getResponsiveFontSize(context, 12)
              ))),
            Expanded(child: Text('Total', style: TextStyle(
              color: Colors.grey,
              fontSize: _getResponsiveFontSize(context, 12)
            ))),
          ],
        ),
        SizedBox(height: 8),
        // Sell orders
        ...List.generate(5, (i) => _buildOrderBookRow(
          context,
          (currentPrice + (5 - i) * 0.5).toStringAsFixed(2),
          (Random().nextDouble() * 100).toStringAsFixed(2),
          Color(0xFFFF6B6B),
        )),
        SizedBox(height: 8),
        // Current price
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text('\$${currentPrice.toStringAsFixed(2)}', 
              style: TextStyle(
                color: priceChange >= 0 ? Color(0xFF00D4AA) : Color(0xFFFF6B6B), 
                fontSize: _getResponsiveFontSize(context, 16), 
                fontWeight: FontWeight.bold
              )),
          ),
        ),
        SizedBox(height: 8),
        // Buy orders
        ...List.generate(5, (i) => _buildOrderBookRow(
          context,
          (currentPrice - (i + 1) * 0.5).toStringAsFixed(2),
          (Random().nextDouble() * 100).toStringAsFixed(2),
          Color(0xFF00D4AA),
        )),
      ],
    );
  }
  
  Widget _buildOrderBookRow(BuildContext context, String price, String amount, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(price, style: TextStyle(
            color: color, 
            fontSize: _getResponsiveFontSize(context, 12)
          ))),
          Expanded(child: Text(amount, style: TextStyle(
            color: Colors.white, 
            fontSize: _getResponsiveFontSize(context, 12)
          ))),
          Expanded(child: Text((double.parse(price) * double.parse(amount)).toStringAsFixed(2), 
            style: TextStyle(
              color: Colors.white, 
              fontSize: _getResponsiveFontSize(context, 12)
            ))),
        ],
      ),
    );
  }
  
  Widget _buildRecentTrades(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Trades', style: TextStyle(
          color: Colors.white, 
          fontSize: _getResponsiveFontSize(context, 18), 
          fontWeight: FontWeight.bold
        )),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Text('Price (USDT)', style: TextStyle(
              color: Colors.grey,
              fontSize: _getResponsiveFontSize(context, 12)
            ))),
            Expanded(child: Text(isSmallScreen ? 'Amount' : 'Amount (SOL)', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: _getResponsiveFontSize(context, 12)
              ))),
            Expanded(child: Text('Time', style: TextStyle(
              color: Colors.grey,
              fontSize: _getResponsiveFontSize(context, 12)
            ))),
          ],
        ),
        SizedBox(height: 8),
        ...List.generate(10, (i) {
          final isBuy = Random().nextBool();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(child: Text(
                  (currentPrice + (Random().nextDouble() - 0.5) * 2).toStringAsFixed(2),
                  style: TextStyle(
                    color: isBuy ? Color(0xFF00D4AA) : Color(0xFFFF6B6B), 
                    fontSize: _getResponsiveFontSize(context, 12)
                  ))),
                Expanded(child: Text((Random().nextDouble() * 10).toStringAsFixed(3), 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: _getResponsiveFontSize(context, 12)
                  ))),
                Expanded(child: Text(
                  isSmallScreen ? 
                    '${DateTime.now().subtract(Duration(minutes: i)).toString().substring(11, 16)}' :
                    '${DateTime.now().subtract(Duration(minutes: i)).toString().substring(11, 19)}', 
                  style: TextStyle(
                    color: Colors.grey, 
                    fontSize: _getResponsiveFontSize(context, 12)
                  ))),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildTradingAnalysisTab(BuildContext context) {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Analysis', style: TextStyle(
            color: Colors.white, 
            fontSize: _getResponsiveFontSize(context, 18), 
            fontWeight: FontWeight.bold
          )),
          SizedBox(height: 16),
          _buildAnalysisRow(context, 'RSI (14)', '67.5', 'Neutral'),
          _buildAnalysisRow(context, 'MACD', '1.25', 'Bullish'),
          _buildAnalysisRow(context, 'Moving Average (20)', '201.45', 'Above'),
          _buildAnalysisRow(context, 'Bollinger Bands', 'Upper: 215.3', 'Approaching'),
          _buildAnalysisRow(context, 'Support', '195.50', 'Strong'),
          _buildAnalysisRow(context, 'Resistance', '220.00', 'Key Level'),
          SizedBox(height: 20),
          Text('Market Sentiment', style: TextStyle(
            color: Colors.white, 
            fontSize: _getResponsiveFontSize(context, 16), 
            fontWeight: FontWeight.bold
          )),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Fear & Greed Index', style: TextStyle(
                      color: Colors.grey,
                      fontSize: _getResponsiveFontSize(context, 14)
                    ))),
                    Text('72 - Greed', style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: _getResponsiveFontSize(context, 14)
                    )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('24h Volume Trend', style: TextStyle(
                      color: Colors.grey,
                      fontSize: _getResponsiveFontSize(context, 14)
                    ))),
                    Text('↗️ Increasing', style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: _getResponsiveFontSize(context, 14)
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisRow(BuildContext context, String indicator, String value, String signal) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    
    Color signalColor;
    switch (signal) {
      case 'Bullish':
      case 'Above':
      case 'Strong':
        signalColor = Color(0xFF00D4AA);
        break;
      case 'Bearish':
      case 'Below':
      case 'Weak':
        signalColor = Color(0xFFFF6B6B);
        break;
      default:
        signalColor = Color.fromARGB(255, 122, 79, 223);
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: isSmallScreen ? 
      // Vertical layout for small screens
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(indicator, style: TextStyle(
                color: Colors.white,
                fontSize: _getResponsiveFontSize(context, 14)
              ))),
              Text(signal, style: TextStyle(
                color: signalColor,
                fontSize: _getResponsiveFontSize(context, 14)
              )),
            ],
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(
            color: Colors.grey,
            fontSize: _getResponsiveFontSize(context, 12)
          )),
        ],
      ) :
      // Horizontal layout for larger screens
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(indicator, style: TextStyle(
            color: Colors.white,
            fontSize: _getResponsiveFontSize(context, 14)
          ))),
          Expanded(child: Text(value, style: TextStyle(
            color: Colors.grey,
            fontSize: _getResponsiveFontSize(context, 14)
          ))),
          Expanded(child: Text(signal, style: TextStyle(
            color: signalColor,
            fontSize: _getResponsiveFontSize(context, 14)
          ))),
        ],
      ),
    );
  }
}

class CandlestickData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  
  CandlestickData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class CandlestickChart extends StatelessWidget {
  final List<CandlestickData> data;
  
  const CandlestickChart({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 10,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[800]!, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[800]!, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: data.isNotEmpty ? data.map((e) => e.low).reduce((a, b) => a < b ? a : b) - 2 : 0,
        maxY: data.isNotEmpty ? data.map((e) => e.high).reduce((a, b) => a > b ? a : b) + 2 : 100,
        lineBarsData: [
          // High-Low lines
          LineChartBarData(
            spots: data.asMap().entries.map((entry) => 
              FlSpot(entry.key.toDouble(), entry.value.high)).toList(),
            isCurved: false,
            color: Colors.transparent,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
            barWidth: 0,
          ),
        ],
        extraLinesData: ExtraLinesData(
          verticalLines: data.asMap().entries.map((entry) {
            final candle = entry.value;
            final index = entry.key.toDouble();
            final isGreen = candle.close > candle.open;
            
            return VerticalLine(
              x: index,
              color: isGreen ? Color(0xFF00D4AA) : Color(0xFFFF6B6B),
              strokeWidth: 2,
              dashArray: null,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class VolumeChart extends StatelessWidget {
  final List<CandlestickData> data;
  
  const VolumeChart({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.isNotEmpty ? data.map((e) => e.volume).reduce((a, b) => a > b ? a : b) : 1000,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final candle = entry.value;
          final index = entry.key;
          final isGreen = candle.close > candle.open;
          
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: candle.volume,
                color: isGreen ? Color(0xFF00D4AA).withOpacity(0.7) : Color(0xFFFF6B6B).withOpacity(0.7),
                width: 2,
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(show: false),
      ),
    );
  }
}