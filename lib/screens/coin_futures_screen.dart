import 'package:flutter/material.dart';
import 'dart:math' as math;

class CoinFuturesScreen extends StatefulWidget {
  @override
  _CoinFuturesScreenState createState() => _CoinFuturesScreenState();
}

class _CoinFuturesScreenState extends State<CoinFuturesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCoin = 'BTCUSD CM';
  String selectedTimeframe = '5m';
  String selectedCurrency = 'BTC';
  String selectedFilter = 'All';

  final List<String> coins = ['BTCUSD CM', 'ETHUSD CM', 'ADAUSD CM', 'LINKUSD CM'];
  final List<String> timeframes = ['5m', '15m', '1h', '4h', '1d'];
  final List<String> currencies = ['BTC', 'ETH', 'ADA', 'LINK'];
  final List<String> filters = ['All', 'BTC', 'ETH', 'Others'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 1; // Default to COIN-M Futures tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;
    
    // Responsive padding
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final topPadding = isDesktop ? 55.0 : (isTablet ? 50.0 : 40.0);
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),

                // Tab Bar and Action Buttons
                if (isMobile)
                  _buildMobileHeader()
                else
                  _buildDesktopHeader(isDesktop),
              ],
            ),
          ),

          // Filters Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
            child: _buildFilters(isMobile),
          ),

          // Main Content - Charts Grid
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: _buildChartsGrid(isMobile, isTablet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      children: [
        // Tab Bar
        Container(
          height: 44,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 122, 79, 223),
                  width: 2,
                ),
              ),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF848E9C),
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Rankings'),
              Tab(text: 'USDⓈ-M Futures'),
              Tab(text: 'COIN-M Futures'),
              Tab(text: 'Options'),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Action buttons stacked vertically on mobile
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_outlined, 
                       color: Color(0xFF0B0E11), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Historical Data',
                    style: TextStyle(
                      color: Color(0xFF0B0E11),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Trade Futures',
                    style: TextStyle(
                      color: Color(0xFF0B0E11),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, 
                       color: Color(0xFF0B0E11), size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(bool isDesktop) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 122, 79, 223),
                    width: 2,
                  ),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF848E9C),
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: 'Rankings'),
                Tab(text: 'USDⓈ-M Futures'),
                Tab(text: 'COIN-M Futures'),
                Tab(text: 'Options'),
              ],
            ),
          ),
        ),
        SizedBox(width: isDesktop ? 24 : 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 122, 79, 223),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_outlined, 
                   color: Color(0xFF0B0E11), size: 16),
              SizedBox(width: 8),
              Text(
                'Historical Data',
                style: TextStyle(
                  color: Color(0xFF0B0E11),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isDesktop ? 24 : 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 122, 79, 223),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Trade Futures',
                style: TextStyle(
                  color: Color(0xFF0B0E11),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, 
                   color: Color(0xFF0B0E11), size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2026),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFF2B3139)),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCoin,
                    dropdownColor: Color(0xFF1E2026),
                    underline: SizedBox(),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, 
                              color: Color(0xFF848E9C), size: 16),
                    items: coins.map((coin) {
                      return DropdownMenuItem(
                        value: coin,
                        child: Text(
                          coin,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCoin = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2026),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFF2B3139)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.view_list, color: Color(0xFF848E9C), size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.grid_view, color: Color(0xFF848E9C), size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          // Coin Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF1E2026),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Color(0xFF2B3139)),
            ),
            child: DropdownButton<String>(
              value: selectedCoin,
              dropdownColor: Color(0xFF1E2026),
              underline: SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down, 
                        color: Color(0xFF848E9C), size: 16),
              items: coins.map((coin) {
                return DropdownMenuItem(
                  value: coin,
                  child: Text(
                    coin,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCoin = value!;
                });
              },
            ),
          ),
          SizedBox(width: 12),

          // View Toggle Icons
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color(0xFF1E2026),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Color(0xFF2B3139)),
            ),
            child: Row(
              children: [
                Icon(Icons.view_list, color: Color(0xFF848E9C), size: 16),
                SizedBox(width: 8),
                Icon(Icons.grid_view, color: Color(0xFF848E9C), size: 16),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildChartsGrid(bool isMobile, bool isTablet) {
    final spacing = isMobile ? 12.0 : (isTablet ? 16.0 : 20.0);
    
    return Column(
      children: [
        // Open Interest Chart (full width on all devices)
        _buildChartCard(
          'Open Interest',
          _buildTimeframeSelector(isMobile),
          _buildOpenInterestChart(),
          isMobile,
        ),
        SizedBox(height: spacing),

        // Two charts in a row (stack on mobile)
        if (isMobile)
          Column(
            children: [
              _buildChartCard(
                'Top Trader Long/Short Ratio (Accounts)',
                _buildCurrencySelector(isMobile),
                _buildLongShortChart(true),
                isMobile,
              ),
              SizedBox(height: spacing),
              _buildChartCard(
                'Top Trader Long/Short Ratio (Positions)',
                _buildCurrencySelector(isMobile),
                _buildLongShortChart(false),
                isMobile,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildChartCard(
                  'Top Trader Long/Short Ratio (Accounts)',
                  _buildCurrencySelector(isMobile),
                  _buildLongShortChart(true),
                  isMobile,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildChartCard(
                  'Top Trader Long/Short Ratio (Positions)',
                  _buildCurrencySelector(isMobile),
                  _buildLongShortChart(false),
                  isMobile,
                ),
              ),
            ],
          ),
        SizedBox(height: spacing),

        // Another row of charts
        if (isMobile)
          Column(
            children: [
              _buildChartCard(
                'Long/Short Ratio',
                _buildCurrencySelector(isMobile),
                _buildRatioChart(),
                isMobile,
              ),
              SizedBox(height: spacing),
              _buildChartCard(
                'Taker Buy/Sell Volume',
                _buildCurrencySelector(isMobile),
                _buildVolumeChart(),
                isMobile,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildChartCard(
                  'Long/Short Ratio',
                  _buildCurrencySelector(isMobile),
                  _buildRatioChart(),
                  isMobile,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildChartCard(
                  'Taker Buy/Sell Volume',
                  _buildCurrencySelector(isMobile),
                  _buildVolumeChart(),
                  isMobile,
                ),
              ),
            ],
          ),
        SizedBox(height: spacing),

        // Last row of charts
        if (isMobile)
          Column(
            children: [
              _buildChartCard(
                'Basis',
                _buildCurrencySelector(isMobile),
                _buildBasisChart(),
                isMobile,
              ),
              SizedBox(height: spacing),
              _buildChartCard(
                'Funding Rate',
                _buildCurrencySelector(isMobile),
                _buildFundingRateChart(),
                isMobile,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildChartCard(
                  'Basis',
                  _buildCurrencySelector(isMobile),
                  _buildBasisChart(),
                  isMobile,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildChartCard(
                  'Funding Rate',
                  _buildCurrencySelector(isMobile),
                  _buildFundingRateChart(),
                  isMobile,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget controls, Widget chart, bool isMobile) {
    final padding = isMobile ? 12.0 : 20.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                controls,
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                controls,
              ],
            ),
          SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(selectedTimeframe, timeframes, (value) {
                  setState(() {
                    selectedTimeframe = value!;
                  });
                }),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(selectedCurrency, currencies, (value) {
                  setState(() {
                    selectedCurrency = value!;
                  });
                }),
              ),
            ],
          ),
          SizedBox(height: 8),
          _buildDropdown(selectedFilter, filters, (value) {
            setState(() {
              selectedFilter = value!;
            });
          }),
        ],
      );
    } else {
      return Row(
        children: [
          _buildDropdown(selectedTimeframe, timeframes, (value) {
            setState(() {
              selectedTimeframe = value!;
            });
          }),
          SizedBox(width: 8),
          _buildDropdown(selectedCurrency, currencies, (value) {
            setState(() {
              selectedCurrency = value!;
            });
          }),
          SizedBox(width: 8),
          _buildDropdown(selectedFilter, filters, (value) {
            setState(() {
              selectedFilter = value!;
            });
          }),
        ],
      );
    }
  }

  Widget _buildCurrencySelector(bool isMobile) {
    return _buildDropdown(selectedCurrency, currencies, (value) {
      setState(() {
        selectedCurrency = value!;
      });
    }, isExpanded: isMobile);
  }

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged, {bool isExpanded = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Color(0xFF1E2026),
        underline: SizedBox(),
        isExpanded: isExpanded,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF848E9C), size: 14),
        style: TextStyle(color: Colors.white, fontSize: 12),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildOpenInterestChart() {
    return Container(
      height: 200,
      child: CustomPaint(
        painter: BarChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildLongShortChart(bool isAccounts) {
    return Container(
      height: 150,
      child: CustomPaint(
        painter: LongShortChartPainter(isAccounts: isAccounts),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildRatioChart() {
    return Container(
      height: 150,
      child: CustomPaint(
        painter: RatioChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildVolumeChart() {
    return Container(
      height: 150,
      child: CustomPaint(
        painter: VolumeChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildBasisChart() {
    return Container(
      height: 150,
      child: CustomPaint(
        painter: BasisChartPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildFundingRateChart() {
    return Container(
      height: 150,
      child: CustomPaint(
        painter: FundingRateChartPainter(),
        size: Size.infinite,
      ),
    );
  }
}

// Custom Painters for different chart types

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 122, 79, 223)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw Y-axis labels
    final yLabels = ['31,120', '31,040', '30,960'];
    for (int i = 0; i < yLabels.length; i++) {
      textPainter.text = TextSpan(
        text: yLabels[i],
        style: TextStyle(color: Color(0xFF848E9C), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, i * (size.height / 3) - 5));
    }

    // Generate bar chart data
    final barCount = 30;
    final barWidth = (size.width - 60) / barCount;
    final baseHeight = size.height * 0.3;

    for (int i = 0; i < barCount; i++) {
      final x = 60 + i * barWidth;
      final barHeight = baseHeight + (math.Random().nextDouble() * size.height * 0.4);
      
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barHeight, barWidth * 0.8, barHeight),
        paint,
      );
    }

    // Draw time labels
    final timeLabels = ['10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15'];
    for (int i = 0; i < timeLabels.length; i++) {
      if (i % 2 == 0) {
        textPainter.text = TextSpan(
          text: timeLabels[i ~/ 2],
          style: TextStyle(color: Color(0xFF848E9C), fontSize: 9),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(60 + i * (size.width - 60) / 9, size.height - 15));
      }
    }

    // Legend
    textPainter.text = TextSpan(
      text: '■ Open Interest (BTC)',
      style: TextStyle(color: Color.fromARGB(255, 122, 79, 223), fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 50, size.height - 30));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LongShortChartPainter extends CustomPainter {
  final bool isAccounts;

  LongShortChartPainter({required this.isAccounts});

  @override
  void paint(Canvas canvas, Size size) {
    final longPaint = Paint()
      ..color = Color(0xFF0ECB81)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final shortPaint = Paint()
      ..color = Color(0xFFF6465D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = 20;
    final stepX = size.width / (points - 1);

    // Generate Long line
    final longPath = Path();
    final shortPath = Path();

    for (int i = 0; i < points; i++) {
      final x = i * stepX;
      final longY = size.height * 0.3 + math.sin(i * 0.3) * size.height * 0.2;
      final shortY = size.height * 0.7 + math.cos(i * 0.4) * size.height * 0.2;

      if (i == 0) {
        longPath.moveTo(x, longY);
        shortPath.moveTo(x, shortY);
      } else {
        longPath.lineTo(x, longY);
        shortPath.lineTo(x, shortY);
      }
    }

    canvas.drawPath(longPath, longPaint);
    canvas.drawPath(shortPath, shortPaint);

    // Legend
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    textPainter.text = TextSpan(
      text: '— Long',
      style: TextStyle(color: Color(0xFF0ECB81), fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, 10));

    textPainter.text = TextSpan(
      text: '— Short',
      style: TextStyle(color: Color(0xFFF6465D), fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, 25));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RatioChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF3861FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = 20;
    final stepX = size.width / (points - 1);
    final path = Path();

    for (int i = 0; i < points; i++) {
      final x = i * stepX;
      final y = size.height * 0.5 + math.sin(i * 0.2) * size.height * 0.3;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw ratio line at 1.0
    final dashedPaint = Paint()
      ..color = Color(0xFF848E9C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerY = size.height * 0.5;
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, centerY),
        Offset(x + 5, centerY),
        dashedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class VolumeChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buyPaint = Paint()..color = Color(0xFF0ECB81);
    final sellPaint = Paint()..color = Color(0xFFF6465D);

    final barCount = 15;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;
      final buyHeight = math.Random().nextDouble() * size.height * 0.4;
      final sellHeight = math.Random().nextDouble() * size.height * 0.4;

      // Buy volume (bottom)
      canvas.drawRect(
        Rect.fromLTWH(x + 2, size.height - buyHeight, barWidth - 4, buyHeight),
        buyPaint,
      );

      // Sell volume (top)
      canvas.drawRect(
        Rect.fromLTWH(x + 2, 0, barWidth - 4, sellHeight),
        sellPaint,
      );
    }

    // Legend
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    textPainter.text = TextSpan(
      text: '■ Buy Volume',
      style: TextStyle(color: Color(0xFF0ECB81), fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, size.height - 20));

    textPainter.text = TextSpan(
      text: '■ Sell Volume',
      style: TextStyle(color: Color(0xFFF6465D), fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, 10));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BasisChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFF6B35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = 20;
    final stepX = size.width / (points - 1);
    final path = Path();

    for (int i = 0; i < points; i++) {
      final x = i * stepX;
      final y = size.height * 0.6 + math.sin(i * 0.15) * size.height * 0.2;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Zero line
    final zeroPaint = Paint()
      ..color = Color(0xFF848E9C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerY = size.height * 0.5;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(
        Offset(x, centerY),
        Offset(x + 4, centerY),
        zeroPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FundingRateChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final positivePaint = Paint()..color = Color(0xFF0ECB81);
    final negativePaint = Paint()..color = Color(0xFFF6465D);

    final barCount = 15;
    final barWidth = size.width / barCount;
    final centerY = size.height * 0.5;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;
      final value = (math.Random().nextDouble() - 0.5) * 2; // -1 to 1
      final barHeight = math.cos(value) * size.height * 0.4;
      final isPositive = value > 0;

      final startY = isPositive ? centerY - barHeight : centerY;
      final paint = isPositive ? positivePaint : negativePaint;

      canvas.drawRect(
        Rect.fromLTWH(x + 2, startY, barWidth - 4, barHeight),
        paint,
      );
    }

    // Zero line
    final zeroPaint = Paint()
      ..color = Color(0xFF848E9C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      zeroPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Bottom Navigation Section
class TradingDataBottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        border: Border(
          top: BorderSide(color: Color(0xFF2B3139)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top Trader Long/Short Ratio (Accounts)',
            style: TextStyle(
              color: Color(0xFF848E9C),
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF848E9C), size: 16),
              SizedBox(width: 8),
              Text(
                'What is this?',
                style: TextStyle(
                  color: Color(0xFF848E9C),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}