import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class MarginScreen extends StatefulWidget {
  const MarginScreen({Key? key}) : super(key: key);

  @override
  State<MarginScreen> createState() => _MarginScreenState();
}

class _MarginScreenState extends State<MarginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CandleData> candles = [];
  List<FlSpot> priceSpots = [];
  Timer? _timer;
  double currentPrice = 145.67;
  double priceChange = 2.34;
  double priceChangePercent = 1.63;
  String selectedTimeframe = '1m';
  
  // Trading data
  double high24h = 148.92;
  double low24h = 142.15;
  double volume24h = 1234567.89;
  double volumeUSDT = 179876543.21;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateInitialCandles();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _generateInitialCandles() {
    final now = DateTime.now();
    final random = Random();
    double basePrice = 145.0;
    
    for (int i = 100; i >= 0; i--) {
      final time = now.subtract(Duration(minutes: i));
      final open = basePrice + (random.nextDouble() - 0.5) * 4;
      final close = open + (random.nextDouble() - 0.5) * 3;
      final high = max(open, close) + random.nextDouble() * 2;
      final low = min(open, close) - random.nextDouble() * 2;
      final volume = 1000 + random.nextDouble() * 5000;
      
      candles.add(CandleData(
        date: time,
        high: high,
        low: low,
        open: open,
        close: close,
        volume: volume,
      ));
      
      priceSpots.add(FlSpot(i.toDouble(), close));
      basePrice = close;
    }
    
    currentPrice = candles.last.close;
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateRealTimeData();
    });
  }

  void _updateRealTimeData() {
    final random = Random();
    final now = DateTime.now();
    
    // Update current price with realistic fluctuation
    final priceChangeValue = (random.nextDouble() - 0.5) * 0.5;
    currentPrice += priceChangeValue;
    
    // Update the last candle or add new one if minute changed
    if (candles.isNotEmpty) {
      final lastCandle = candles.last;
      final timeDiff = now.difference(lastCandle.date).inMinutes;
      
      if (timeDiff >= 1) {
        // Add new candle
        final volume = 1000 + random.nextDouble() * 5000;
        candles.add(CandleData(
          date: now,
          high: currentPrice + random.nextDouble() * 0.5,
          low: currentPrice - random.nextDouble() * 0.5,
          open: candles.last.close,
          close: currentPrice,
          volume: volume,
        ));
        
        priceSpots.add(FlSpot(candles.length.toDouble() - 1, currentPrice));
        
        // Keep only last 100 candles
        if (candles.length > 100) {
          candles.removeAt(0);
          priceSpots.removeAt(0);
          // Reindex spots
          for (int i = 0; i < priceSpots.length; i++) {
            priceSpots[i] = FlSpot(i.toDouble(), priceSpots[i].y);
          }
        }
      } else {
        // Update current candle
        final updatedCandle = CandleData(
          date: lastCandle.date,
          high: max(lastCandle.high, currentPrice),
          low: min(lastCandle.low, currentPrice),
          open: lastCandle.open,
          close: currentPrice,
          volume: lastCandle.volume + random.nextDouble() * 100,
        );
        candles[candles.length - 1] = updatedCandle;
        priceSpots[priceSpots.length - 1] = FlSpot(priceSpots.length.toDouble() - 1, currentPrice);
      }
    }
    
    // Update 24h stats
    priceChange = (random.nextDouble() - 0.5) * 0.1;
    priceChangePercent = (priceChange / currentPrice) * 100;
    volume24h += random.nextDouble() * 1000;
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final isMobile = screenWidth <= 600;
    final padding = isDesktop ? 55.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'SOL/USDT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2329),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Cross 10x',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 10 : 12,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '\$${currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: priceChange >= 0 ? Colors.green : Colors.red,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(2)} (${priceChangePercent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: priceChange >= 0 ? Colors.green : Colors.red,
                    fontSize: isMobile ? 10 : 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: const Color(0xFF1E2329),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 122, 79, 223),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: TextStyle(fontSize: isMobile ? 14 : 16),
              unselectedLabelStyle: TextStyle(fontSize: isMobile ? 14 : 16),
              tabs: const [
                Tab(text: 'Chart'),
                Tab(text: 'Info'),
                Tab(text: 'Trading Data'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChartTab(),
                _buildInfoTab(),
                _buildTradingDataTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final isMobile = screenWidth <= 600;
    final padding = isDesktop ? 32.0 : 16.0;

    return Container(
      color: const Color(0xFF0B0E11),
      child: Column(
        children: [
          // Chart Controls
          Container(
            padding: EdgeInsets.all(padding * 0.75),
            child: Column(
              children: [
                // First row of time buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton('1m', selectedTimeframe == '1m'),
                    _buildTimeButton('5m', selectedTimeframe == '5m'),
                    _buildTimeButton('15m', selectedTimeframe == '15m'),
                  ],
                ),
                if (!isMobile) const SizedBox(height: 8),
                // Second row on mobile, same row on desktop
                if (isMobile)
                  const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton('1h', selectedTimeframe == '1h'),
                    _buildTimeButton('4h', selectedTimeframe == '4h'),
                    _buildTimeButton('1d', selectedTimeframe == '1d'),
                  ],
                ),
                if (!isMobile)
                  Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        Icon(Icons.fullscreen, color: Colors.white60, size: 20),
                        const SizedBox(width: 12),
                        Icon(Icons.settings, color: Colors.white60, size: 20),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Chart
          Expanded(
            child: candles.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        // Main Price Chart
                        Expanded(
                          flex: isMobile ? 4 : 3,
                          child: _buildPriceChart(),
                        ),
                        SizedBox(height: padding),
                        // Volume Chart
                        Expanded(
                          flex: 1,
                          child: _buildVolumeChart(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    if (candles.isEmpty) return Container();

    double minY = candles.map((c) => c.low).reduce(min) - 1;
    double maxY = candles.map((c) => c.high).reduce(max) + 1;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 6 : 8),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white10,
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white10,
                  strokeWidth: 0.5,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: isMobile ? 35 : 50,
                  interval: (maxY - minY) / 5,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: isMobile ? 4 : 8),
                      child: Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: isMobile ? 8 : 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: isMobile ? 20 : 30,
                  interval: isMobile ? 30 : 20,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < candles.length) {
                      final candle = candles[index];
                      return Padding(
                        padding: EdgeInsets.only(top: isMobile ? 4 : 8),
                        child: Text(
                          '${candle.date.hour.toString().padLeft(2, '0')}:${candle.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: isMobile ? 8 : 9,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: priceSpots,
                isCurved: false,
                color: priceChange >= 0 ? const Color(0xFF00C851) : const Color(0xFFFF4444),
                barWidth: isMobile ? 1.2 : 1.5,
                isStrokeCapRound: false,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: (priceChange >= 0 ? const Color(0xFF00C851) : const Color(0xFFFF4444)).withOpacity(0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    int index = touchedSpot.x.toInt();
                    if (index >= 0 && index < candles.length) {
                      final candle = candles[index];
                      return LineTooltipItem(
                        'Price: \$${touchedSpot.y.toStringAsFixed(2)}\n'
                        'Open: \$${candle.open.toStringAsFixed(2)}\n'
                        'High: \$${candle.high.toStringAsFixed(2)}\n'
                        'Low: \$${candle.low.toStringAsFixed(2)}\n'
                        'Volume: ${candle.volume.toStringAsFixed(0)}',
                        TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 10 : 12,
                        ),
                      );
                    }
                    return null;
                  }).where((item) => item != null).cast<LineTooltipItem>().toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeChart() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    if (candles.isEmpty) return Container();

    double maxVolume = candles.map((c) => c.volume).reduce(max);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 6 : 8),
        child: BarChart(
          BarChartData(
            maxY: maxVolume,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: isMobile ? 30 : 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${(value / 1000).toStringAsFixed(0)}K',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: isMobile ? 8 : 9,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: candles.asMap().entries.map((entry) {
              int index = entry.key;
              CandleData candle = entry.value;
              bool isGreen = candle.close >= candle.open;
              
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: candle.volume,
                    color: isGreen 
                        ? const Color(0xFF00C851).withOpacity(0.7) 
                        : const Color(0xFFFF4444).withOpacity(0.7),
                    width: isMobile ? 1.5 : 2,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }).toList(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (groupIndex < candles.length) {
                    return BarTooltipItem(
                      'Volume: ${candles[groupIndex].volume.toStringAsFixed(0)}',
                      TextStyle(
                        color: Colors.white, 
                        fontSize: isMobile ? 10 : 12,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String timeframe, bool isSelected) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 4),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedTimeframe = timeframe;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12, 
              vertical: isMobile ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.white30,
              ),
            ),
            child: Text(
              timeframe,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final isMobile = screenWidth <= 600;
    final padding = isDesktop ? 32.0 : 16.0;

    return Container(
      color: const Color(0xFF0B0E11),
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding * 0.8),
            _buildInfoRow('Symbol', 'SOL/USDT'),
            _buildInfoRow('Current Price', '\$${currentPrice.toStringAsFixed(2)}'),
            _buildInfoRow('24h Change', '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(2)} (${priceChangePercent.toStringAsFixed(2)}%)'),
            _buildInfoRow('24h High', '\$${high24h.toStringAsFixed(2)}'),
            _buildInfoRow('24h Low', '\$${low24h.toStringAsFixed(2)}'),
            _buildInfoRow('24h Volume (SOL)', '${(volume24h / 1000).toStringAsFixed(2)}K'),
            _buildInfoRow('24h Volume (USDT)', '\$${(volumeUSDT / 1000000).toStringAsFixed(2)}M'),
            SizedBox(height: padding),
            Text(
              'Margin Trading',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding * 0.6),
            _buildInfoRow('Leverage', '10x Cross'),
            _buildInfoRow('Margin Ratio', '12.34%'),
            _buildInfoRow('Available Balance', '1,234.56 USDT'),
            _buildInfoRow('Position Value', '12,345.67 USDT'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white60,
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: label.contains('Change') 
                  ? (priceChange >= 0 ? Colors.green : Colors.red)
                  : Colors.white,
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingDataTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 768;
    final padding = isMobile ? 8.0 : 16.0;

    return Container(
      color: const Color(0xFF0B0E11),
      child: Column(
        children: [
          // Order Book Header
          Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Price (USDT)',
                    style: TextStyle(
                      color: Colors.white60, 
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount (SOL)',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white60, 
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white60, 
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sell Orders (Red)
          Expanded(
            flex: isMobile ? 1 : 2,
            child: ListView.builder(
              reverse: true,
              itemCount: isMobile ? 5 : 10,
              itemBuilder: (context, index) {
                final price = currentPrice + (index + 1) * 0.05;
                final amount = 100 + Random().nextDouble() * 500;
                final total = price * amount;
                
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding, 
                    vertical: isMobile ? 2 : 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          price.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.red, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          amount.toStringAsFixed(3),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          total.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white60, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Current Price
          Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
            color: const Color(0xFF1E2329),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: priceChange >= 0 ? Colors.green : Colors.red,
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  priceChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: priceChange >= 0 ? Colors.green : Colors.red,
                  size: isMobile ? 14 : 16,
                ),
              ],
            ),
          ),
          // Buy Orders (Green)
          Expanded(
            flex: isMobile ? 1 : 2,
            child: ListView.builder(
              itemCount: isMobile ? 5 : 10,
              itemBuilder: (context, index) {
                final price = currentPrice - (index + 1) * 0.05;
                final amount = 100 + Random().nextDouble() * 500;
                final total = price * amount;
                
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding, 
                    vertical: isMobile ? 2 : 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          price.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.green, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          amount.toStringAsFixed(3),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          total.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white60, 
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Recent Trades
          Container(
            height: isMobile ? 100 : 120,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  child: Text(
                    'Recent Trades',
                    style: TextStyle(
                      color: Colors.white60, 
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: isMobile ? 3 : 5,
                    itemBuilder: (context, index) {
                      final isGreen = Random().nextBool();
                      final price = currentPrice + (Random().nextDouble() - 0.5) * 0.1;
                      final amount = Random().nextDouble() * 100;
                      final time = DateTime.now().subtract(Duration(seconds: index * 10));
                      
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: padding, 
                          vertical: isMobile ? 1 : 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                price.toStringAsFixed(2),
                                style: TextStyle(
                                  color: isGreen ? Colors.green : Colors.red,
                                  fontSize: isMobile ? 9 : 11,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                amount.toStringAsFixed(3),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: isMobile ? 9 : 11,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white60, 
                                  fontSize: isMobile ? 9 : 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}