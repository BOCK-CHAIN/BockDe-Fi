import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class ArbitrageScreen extends StatefulWidget {
  @override
  _ArbitrageScreenState createState() => _ArbitrageScreenState();
}

class _ArbitrageScreenState extends State<ArbitrageScreen> {
  late Timer _updateTimer;
  int selectedHistoryDays = 7; // 7 or 14 days
  List<ArbitrageItem> arbitrageItems = [];
  Set<String> expandedItems = {};
  TextEditingController searchController = TextEditingController();
  
  // Portfolio data
  double totalBalance = 0.00;
  double thirtyDayProfit = 0.00;
  
  // Helper method to determine if we're on mobile
  bool get isMobile => MediaQuery.of(context).size.width < 768;
  
  // Responsive padding
  double get responsivePadding => isMobile ? 16.0 : 32.0;
  double get responsiveHorizontalPadding => isMobile ? 16.0 : 55.0;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
    _startRealTimeUpdates();
  }
  
  @override
  void dispose() {
    _updateTimer.cancel();
    searchController.dispose();
    super.dispose();
  }
  
  void _initializeData() {
    // Initialize arbitrage items with crypto data
    arbitrageItems = [
      ArbitrageItem(
        symbol: 'USDT',
        iconColor: Color(0xFF26A17B),
        nextAPR: _generateRandomAPR(),
        thirtyDayAPR: _generateRandomAPR(),
        portfolio: 'BTC',
        portfolioIcon: Icons.currency_bitcoin,
        portfolioColor: Color(0xFFF7931A),
        aprHistory: _generateAPRHistory(),
        timeLeft: _generateTimeLeft(),
      ),
      ArbitrageItem(
        symbol: 'USDT',
        iconColor: Color(0xFF26A17B),
        nextAPR: _generateRandomAPR(),
        thirtyDayAPR: _generateRandomAPR(),
        portfolio: 'ETH',
        portfolioIcon: Icons.currency_exchange,
        portfolioColor: Color(0xFF627EEA),
        aprHistory: _generateAPRHistory(),
        timeLeft: _generateTimeLeft(),
      ),
      ArbitrageItem(
        symbol: 'USDT',
        iconColor: Color(0xFF26A17B),
        nextAPR: _generateRandomAPR(),
        thirtyDayAPR: _generateRandomAPR(),
        portfolio: 'SOL',
        portfolioIcon: Icons.wb_sunny,
        portfolioColor: Color(0xFF9945FF),
        aprHistory: _generateAPRHistory(),
        timeLeft: _generateTimeLeft(),
      ),
      ArbitrageItem(
        symbol: 'USDT',
        iconColor: Color(0xFF26A17B),
        nextAPR: _generateRandomAPR(),
        thirtyDayAPR: _generateRandomAPR(),
        portfolio: 'XRP',
        portfolioIcon: Icons.water_drop,
        portfolioColor: Color(0xFF23292F),
        aprHistory: _generateAPRHistory(),
        timeLeft: _generateTimeLeft(),
      ),
      ArbitrageItem(
        symbol: 'USDT',
        iconColor: Color(0xFF26A17B),
        nextAPR: _generateRandomAPR(),
        thirtyDayAPR: _generateRandomAPR(),
        portfolio: 'DOGE',
        portfolioIcon: Icons.pets,
        portfolioColor: Color(0xFFC2A633),
        aprHistory: _generateAPRHistory(),
        timeLeft: _generateTimeLeft(),
      ),
    ];
  }
  
  double _generateRandomAPR() {
    return Random().nextDouble() * 10 + 1; // 1% to 11%
  }
  
  Duration _generateTimeLeft() {
    final hours = Random().nextInt(24);
    final minutes = Random().nextInt(60);
    final seconds = Random().nextInt(60);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
  
  List<FlSpot> _generateAPRHistory() {
    final random = Random();
    List<FlSpot> spots = [];
    
    for (int i = 0; i < 14; i++) {
      final y = random.nextDouble() * 10 + 2; // 2% to 12%
      spots.add(FlSpot(i.toDouble(), y));
    }
    
    return spots;
  }
  
  void _startRealTimeUpdates() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Update APR values
        for (var item in arbitrageItems) {
          item.nextAPR = _generateRandomAPR();
          item.thirtyDayAPR = _generateRandomAPR();
          
          // Update time left
          if (item.timeLeft.inSeconds > 0) {
            item.timeLeft = item.timeLeft - Duration(seconds: 5);
          } else {
            item.timeLeft = _generateTimeLeft();
          }
          
          // Add new point to APR history (simulate real-time data)
          if (timer.tick % 12 == 0) { // Every minute
            item.aprHistory.add(FlSpot(
              item.aprHistory.length.toDouble(),
              _generateRandomAPR(),
            ));
            
            // Keep only last 14 points
            if (item.aprHistory.length > 14) {
              item.aprHistory = item.aprHistory.sublist(1);
              // Re-index the spots
              for (int i = 0; i < item.aprHistory.length; i++) {
                item.aprHistory[i] = FlSpot(i.toDouble(), item.aprHistory[i].y);
              }
            }
          }
        }
        
        // Update portfolio totals
        totalBalance += (Random().nextDouble() - 0.5) * 0.01;
        thirtyDayProfit += (Random().nextDouble() - 0.5) * 0.05;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildBalanceSection(),
            _buildSearchAndPortfolio(),
            _buildArbitrageTable(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      child: isMobile ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderContent(),
          SizedBox(height: 24),
          Center(
            child: Container(
              width: 250,
              height: 150,
              child: CustomPaint(
                painter: ArbitrageRobotPainter(),
              ),
            ),
          ),
        ],
      ) : Row(
        children: [
          Expanded(child: _buildHeaderContent()),
          Container(
            width: 300,
            height: 200,
            child: CustomPaint(
              painter: ArbitrageRobotPainter(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smart Arbitrage',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Arbitrage Steadily and Increase Your Profits Easily',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isMobile ? 14 : 18,
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // Show arbitrage info dialog
          },
          child: Row(
            children: [
              Text(
                'What is Smart Arbitrage',
                style: TextStyle(
                  color: Color.fromARGB(255, 122, 79, 223),
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.help_outline,
                color: Color.fromARGB(255, 122, 79, 223),
                size: isMobile ? 14 : 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildBalanceSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsiveHorizontalPadding),
      child: isMobile ? Column(
        children: [
          _buildBalanceItem(
            'Total Balance',
            '≈ BTC ${totalBalance.toStringAsFixed(2)}BTC',
            '≈ \$${(totalBalance * 65000).toStringAsFixed(2)}',
            showVisibilityIcon: true,
          ),
          SizedBox(height: 24),
          _buildBalanceItem(
            '30-Day Profit',
            '${thirtyDayProfit.toStringAsFixed(2)}BTC',
            '≈ \$${(thirtyDayProfit * 65000).toStringAsFixed(2)}',
            showVisibilityIcon: false,
          ),
        ],
      ) : Row(
        children: [
          Expanded(
            child: _buildBalanceItem(
              'Total Balance',
              '≈ BTC ${totalBalance.toStringAsFixed(2)}BTC',
              '≈ \$${(totalBalance * 65000).toStringAsFixed(2)}',
              showVisibilityIcon: true,
            ),
          ),
          SizedBox(width: 40),
          Expanded(
            child: _buildBalanceItem(
              '30-Day Profit',
              '${thirtyDayProfit.toStringAsFixed(2)}BTC',
              '≈ \$${(thirtyDayProfit * 65000).toStringAsFixed(2)}',
              showVisibilityIcon: false,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBalanceItem(String title, String amount, String usdAmount, {required bool showVisibilityIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            if (showVisibilityIcon) ...[
              SizedBox(width: 8),
              Icon(Icons.visibility_off, color: Colors.grey[400], size: 16),
              SizedBox(width: 4),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          usdAmount,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ],
    );
  }
  
  Widget _buildSearchAndPortfolio() {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      child: isMobile ? Column(
        children: [
          _buildSearchField(),
          SizedBox(height: 12),
          _buildPortfolioButton(),
        ],
      ) : Row(
        children: [
          Expanded(child: _buildSearchField()),
          SizedBox(width: 16),
          _buildPortfolioButton(),
        ],
      ),
    );
  }
  
  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Portfolio',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
  
  Widget _buildPortfolioButton() {
    return Container(
      height: 48,
      width: isMobile ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(Icons.folder_outlined, color: Colors.grey[400], size: 20),
          SizedBox(width: 8),
          Text(
            'My Portfolio',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildArbitrageTable() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsiveHorizontalPadding),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (!isMobile) _buildTableHeader(),
          ...arbitrageItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isExpanded = expandedItems.contains('${item.symbol}_${item.portfolio}');
            
            return Column(
              children: [
                _buildTableRow(item, index, isExpanded),
                if (isExpanded) _buildExpandedContent(item),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Principle', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
          Expanded(flex: 2, child: Text('Next APR', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
          Expanded(flex: 2, child: Text('30d APR', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
          Expanded(flex: 2, child: Text('Portfolio', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
          SizedBox(width: 40), // Space for dropdown arrow
        ],
      ),
    );
  }
  
  Widget _buildTableRow(ArbitrageItem item, int index, bool isExpanded) {
    final itemKey = '${item.symbol}_${item.portfolio}';
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedItems.remove(itemKey);
          } else {
            expandedItems.add(itemKey);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
        ),
        child: isMobile ? _buildMobileTableRow(item, isExpanded) : _buildDesktopTableRow(item, isExpanded),
      ),
    );
  }
  
  Widget _buildMobileTableRow(ArbitrageItem item, bool isExpanded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Principle
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.symbol[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  item.symbol,
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // Portfolio
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.portfolioColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.portfolioIcon,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  item.portfolio,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next APR',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${item.nextAPR.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_formatTimeLeft(item.timeLeft)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '30d APR',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${item.thirtyDayAPR.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 32,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Subscribe',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildDesktopTableRow(ArbitrageItem item, bool isExpanded) {
    return Row(
      children: [
        // Principle
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: item.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.symbol[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                item.symbol,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Next APR
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.nextAPR.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: Color(0xFF00D4AA),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_formatTimeLeft(item.timeLeft)}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
        // 30d APR
        Expanded(
          flex: 2,
          child: Text(
            '${item.thirtyDayAPR.toStringAsFixed(2)}%',
            style: TextStyle(
              color: Color(0xFF00D4AA),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Portfolio
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: item.portfolioColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.portfolioIcon,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              SizedBox(width: 8),
              Text(
                item.portfolio,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        // Subscribe button and dropdown
        Row(
          children: [
            Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    'Subscribe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildExpandedContent(ArbitrageItem item) {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      decoration: BoxDecoration(
        color: Color(0xFF181A20),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'APR History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildHistoryButton('Last 7 days', selectedHistoryDays == 7),
                  SizedBox(width: 8),
                  _buildHistoryButton('Last 14 days', selectedHistoryDays == 14),
                ],
              ),
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'APR History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  _buildHistoryButton('Last 7 days', selectedHistoryDays == 7),
                  SizedBox(width: 8),
                  _buildHistoryButton('Last 14 days', selectedHistoryDays == 14),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: isMobile ? 180 : 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2.5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[800]!,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.now().subtract(Duration(days: 14 - value.toInt()));
                        return Text(
                          '${date.month}-${date.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[400], 
                            fontSize: isMobile ? 8 : 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 30 : 40,
                      interval: 2.5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: Colors.grey[400], 
                            fontSize: isMobile ? 8 : 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: selectedHistoryDays.toDouble() - 1,
                minY: 0,
                maxY: 12,
                lineBarsData: [
                  LineChartBarData(
                    spots: item.aprHistory.take(selectedHistoryDays).toList(),
                    isCurved: true,
                    color: Color.fromARGB(255, 122, 79, 223),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: isMobile ? 2 : 3,
                          color: Color.fromARGB(255, 122, 79, 223),
                          strokeWidth: 0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedHistoryDays = text.contains('7') ? 7 : 14;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12, 
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[600]!,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[400],
            fontSize: isMobile ? 10 : 12,
          ),
        ),
      ),
    );
  }
  
  String _formatTimeLeft(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class ArbitrageItem {
  final String symbol;
  final Color iconColor;
  double nextAPR;
  double thirtyDayAPR;
  final String portfolio;
  final IconData portfolioIcon;
  final Color portfolioColor;
  List<FlSpot> aprHistory;
  Duration timeLeft;
  
  ArbitrageItem({
    required this.symbol,
    required this.iconColor,
    required this.nextAPR,
    required this.thirtyDayAPR,
    required this.portfolio,
    required this.portfolioIcon,
    required this.portfolioColor,
    required this.aprHistory,
    required this.timeLeft,
  });
}

class ArbitrageRobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw robot illustration
    // Robot body (yellow)
    paint.color = Color.fromARGB(255, 122, 79, 223);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.3, size.height * 0.4, size.width * 0.4, size.height * 0.35),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Robot head (black)
    paint.color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.35, size.height * 0.25, size.width * 0.3, size.height * 0.2),
        Radius.circular(4),
      ),
      paint,
    );
    
    // Robot eyes (white diamonds)
    paint.color = Colors.white;
    final eyePath = Path();
    eyePath.moveTo(size.width * 0.42, size.height * 0.32);
    eyePath.lineTo(size.width * 0.45, size.height * 0.29);
    eyePath.lineTo(size.width * 0.48, size.height * 0.32);
    eyePath.lineTo(size.width * 0.45, size.height * 0.35);
    eyePath.close();
    canvas.drawPath(eyePath, paint);
    
    eyePath.reset();
    eyePath.moveTo(size.width * 0.52, size.height * 0.32);
    eyePath.lineTo(size.width * 0.55, size.height * 0.29);
    eyePath.lineTo(size.width * 0.58, size.height * 0.32);
    eyePath.lineTo(size.width * 0.55, size.height * 0.35);
    eyePath.close();
    canvas.drawPath(eyePath, paint);
    
    // Robot arms (gray)
    paint.color = Colors.grey[600]!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.5, size.width * 0.12, size.height * 0.15),
        Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.73, size.height * 0.5, size.width * 0.12, size.height * 0.15),
        Radius.circular(4),
      ),
      paint,
    );
    
    // Decorative elements
    paint.color = Color.fromARGB(255, 122, 79, 223);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 8, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.35), 6, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.15), 4, paint);
    
    // Geometric patterns
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    
    final pattern = Path();
    pattern.moveTo(size.width * 0.85, size.height * 0.6);
    pattern.lineTo(size.width * 0.95, size.height * 0.5);
    pattern.lineTo(size.width * 0.95, size.height * 0.7);
    pattern.close();
    canvas.drawPath(pattern, paint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}