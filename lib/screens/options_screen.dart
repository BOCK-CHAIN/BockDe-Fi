/*import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Timer _timer;
  
  // Real-time data simulation
  List<FlSpot> openInterestData = [];
  List<FlSpot> volumeData = [];
  List<FlSpot> putCallRatioData = [];
  List<FlSpot> takerFlowData = [];
  List<FlSpot> maxPainData = [];
  
  double currentBTCPrice = 95757.4;
  double openInterest = 2847329.12;
  double volume24h = 1284756.89;
  double putCallRatio = 0.78;
  double maxPainPrice = 96000.0;
  
  List<OpenInterestItem> topOpenInterest = [];
  List<VolumeItem> topVolume = [];
  List<TakerFlowItem> takerFlowData24h = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
    _startRealTimeUpdates();
  }

  void _initializeData() {
    // Initialize chart data with random values
    for (int i = 0; i < 50; i++) {
      openInterestData.add(FlSpot(i.toDouble(), 
          2500000 + Random().nextDouble() * 500000));
      volumeData.add(FlSpot(i.toDouble(), 
          1000000 + Random().nextDouble() * 500000));
      putCallRatioData.add(FlSpot(i.toDouble(), 
          0.5 + Random().nextDouble() * 0.6));
      takerFlowData.add(FlSpot(i.toDouble(), 
          -50000 + Random().nextDouble() * 100000));
      maxPainData.add(FlSpot(i.toDouble(), 
          95000 + Random().nextDouble() * 2000));
    }
    
    // Initialize top lists
    topOpenInterest = [
      OpenInterestItem("96000", "Call", 45678.90, 12.5),
      OpenInterestItem("95000", "Call", 38456.12, 10.8),
      OpenInterestItem("97000", "Call", 32145.78, 9.2),
      OpenInterestItem("94000", "Put", 28976.45, 8.1),
      OpenInterestItem("98000", "Call", 25634.89, 7.3),
    ];
    
    topVolume = [
      VolumeItem("96000", "Call", 12345.67, 15.8),
      VolumeItem("95000", "Put", 10987.54, 14.1),
      VolumeItem("97000", "Call", 9876.32, 12.7),
      VolumeItem("94000", "Put", 8765.43, 11.2),
      VolumeItem("98000", "Call", 7654.21, 9.8),
    ];
    
    takerFlowData24h = [
      TakerFlowItem("12:00", 45678, 38456, 7222),
      TakerFlowItem("13:00", 42134, 41298, 836),
      TakerFlowItem("14:00", 39876, 44123, -4247),
      TakerFlowItem("15:00", 48965, 35678, 13287),
    ];
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Update current values
        currentBTCPrice += (Random().nextDouble() - 0.5) * 100;
        openInterest += (Random().nextDouble() - 0.5) * 10000;
        volume24h += (Random().nextDouble() - 0.5) * 5000;
        putCallRatio += (Random().nextDouble() - 0.5) * 0.05;
        maxPainPrice += (Random().nextDouble() - 0.5) * 50;
        
        // Update chart data (remove first point, add new one)
        if (openInterestData.length >= 50) {
          openInterestData.removeAt(0);
          volumeData.removeAt(0);
          putCallRatioData.removeAt(0);
          takerFlowData.removeAt(0);
          maxPainData.removeAt(0);
          
          // Shift x values
          for (int i = 0; i < openInterestData.length; i++) {
            openInterestData[i] = FlSpot(i.toDouble(), openInterestData[i].y);
            volumeData[i] = FlSpot(i.toDouble(), volumeData[i].y);
            putCallRatioData[i] = FlSpot(i.toDouble(), putCallRatioData[i].y);
            takerFlowData[i] = FlSpot(i.toDouble(), takerFlowData[i].y);
            maxPainData[i] = FlSpot(i.toDouble(), maxPainData[i].y);
          }
        }
        
        // Add new data points
        double lastIndex = openInterestData.isNotEmpty ? openInterestData.last.x : 0;
        openInterestData.add(FlSpot(lastIndex + 1, 
            2500000 + Random().nextDouble() * 500000));
        volumeData.add(FlSpot(lastIndex + 1, 
            1000000 + Random().nextDouble() * 500000));
        putCallRatioData.add(FlSpot(lastIndex + 1, 
            0.5 + Random().nextDouble() * 0.6));
        takerFlowData.add(FlSpot(lastIndex + 1, 
            -50000 + Random().nextDouble() * 100000));
        maxPainData.add(FlSpot(lastIndex + 1, 
            95000 + Random().nextDouble() * 2000));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF181825),
        title: Row(
          children: [
            Text(
              'BTC/USDT Options',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '\$${currentBTCPrice.toStringAsFixed(1)}',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFF7931A),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Open Interest & Volume'),
            Tab(text: 'Max Pain'),
            Tab(text: 'Exercised History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildOpenInterestVolumeTab(),
          _buildMaxPainTab(),
          _buildExercisedHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row with Top 5 cards
          Row(
            children: [
              Expanded(child: _buildTopOpenInterestCard()),
              SizedBox(width: 16),
              Expanded(child: _buildTopVolumeCard()),
            ],
          ),
          SizedBox(height: 16),
          
          // Call vs Put ratio chart
          _buildCallVsPutChart(),
          SizedBox(height: 16),
          
          // Open Interest & Volume combined chart
          _buildOpenInterestVolumeChart(),
          SizedBox(height: 16),
          
          // Put/Call Ratio chart
          _buildPutCallRatioChart(),
          SizedBox(height: 16),
          
          // 24hr Taker Flow
          _buildTakerFlowChart(),
        ],
      ),
    );
  }

  Widget _buildTopOpenInterestCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFFF7931A), size: 20),
              SizedBox(width: 8),
              Text(
                'Top 5 Open Interest',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...topOpenInterest.map((item) => _buildOpenInterestRow(item)),
        ],
      ),
    );
  }

  Widget _buildOpenInterestRow(OpenInterestItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.strike} ${item.type}',
                style: TextStyle(
                  color: item.type == 'Call' ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${item.value.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ],
          ),
          Text(
            '${item.percentage.toStringAsFixed(1)}%',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTopVolumeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Color(0xFFF7931A), size: 20),
              SizedBox(width: 8),
              Text(
                'Top 5 24hr Volume',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...topVolume.map((item) => _buildVolumeRow(item)),
        ],
      ),
    );
  }

  Widget _buildVolumeRow(VolumeItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.strike} ${item.type}',
                style: TextStyle(
                  color: item.type == 'Call' ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${item.value.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ],
          ),
          Text(
            '${item.percentage.toStringAsFixed(1)}%',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCallVsPutChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Interest: Call vs Put',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Real-time',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 60,
                    title: 'Call\n60%',
                    radius: 60,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 40,
                    title: 'Put\n40%',
                    radius: 60,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenInterestVolumeChart() {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Interest & Volume',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildLegendItem(Colors.green, 'Open Interest'),
                  SizedBox(width: 16),
                  _buildLegendItem(Colors.blue, 'Volume'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[700]!,
                    strokeWidth: 0.5,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey[700]!,
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
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500000,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000000).toStringAsFixed(1)}M',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                minX: 0,
                maxX: 49,
                minY: 500000,
                maxY: 3500000,
                lineBarsData: [
                  LineChartBarData(
                    spots: openInterestData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.green.withOpacity(0.3), Colors.green],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.green.withOpacity(0.1), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: volumeData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.blue.withOpacity(0.3), Colors.blue],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPutCallRatioChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Put/Call Ratio',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${putCallRatio.toStringAsFixed(3)}',
                style: TextStyle(
                  color: putCallRatio > 0.7 ? Colors.red : Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                minX: 0,
                maxX: 49,
                minY: 0.2,
                maxY: 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: putCallRatioData,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakerFlowChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24hr Taker Flow',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildLegendItem(Colors.green, 'Buy'),
                  SizedBox(width: 16),
                  _buildLegendItem(Colors.red, 'Sell'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000).toStringAsFixed(0)}K',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                minX: 0,
                maxX: 49,
                minY: -100000,
                maxY: 100000,
                lineBarsData: [
                  LineChartBarData(
                    spots: takerFlowData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.purple.withOpacity(0.3), Colors.purple],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.purple.withOpacity(0.1), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenInterestVolumeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Open Interest',
                  '${(openInterest / 1000000).toStringAsFixed(2)}M',
                  '+5.2%',
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  '24hr Volume',
                  '${(volume24h / 1000000).toStringAsFixed(2)}M',
                  '+12.7%',
                  Colors.blue,
                  Icons.bar_chart,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Open Interest by Strike Chart
          _buildOpenInterestByStrikeChart(),
          SizedBox(height: 16),
          
          // Volume by Strike Chart
          _buildVolumeByStrikeChart(),
        ],
      ),
    );
  }

  Widget _buildMaxPainTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Max Pain Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF262637),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF3A3A4A), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Max Pain Price',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${maxPainPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Current BTC: \$${currentBTCPrice.toStringAsFixed(1)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // Max Pain Chart
          _buildMaxPainChart(),
          SizedBox(height: 16),
          
          // Strike Price Analysis
          _buildStrikePriceAnalysis(),
        ],
      ),
    );
  }

  Widget _buildExercisedHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Exercise Summary
          _buildExerciseSummaryCards(),
          SizedBox(height: 16),
          
          // Exercise History Table
          _buildExerciseHistoryTable(),
          SizedBox(height: 16),
          
          // Exercise Volume Chart
          _buildExerciseVolumeChart(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String change, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 12),
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
              color: change.startsWith('+') ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenInterestByStrikeChart() {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Open Interest by Strike Price',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        '${(94000 + value * 1000).toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000).toStringAsFixed(0)}K',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(8, (index) {
                  bool isCall = index % 2 == 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: 20000 + Random().nextDouble() * 30000,
                        color: isCall ? Colors.green : Colors.red,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeByStrikeChart() {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '24hr Volume by Strike Price',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        '${(94000 + value * 1000).toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000).toStringAsFixed(0)}K',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(8, (index) {
                  bool isCall = index % 2 == 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: 5000 + Random().nextDouble() * 15000,
                        color: isCall ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxPainChart() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Max Pain Analysis',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildLegendItem(Colors.green, 'Calls'),
                  SizedBox(width: 16),
                  _buildLegendItem(Colors.red, 'Puts'),
                  SizedBox(width: 16),
                  _buildLegendItem(Colors.yellow, 'Max Pain'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text(
                        '${(94000 + value * 200).toInt()}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000000).toStringAsFixed(1)}M',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                minX: 0,
                maxX: 20,
                minY: 0,
                maxY: 5000000,
                lineBarsData: [
                  LineChartBarData(
                    spots: maxPainData.take(21).toList(),
                    isCurved: true,
                    color: Colors.yellow,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.yellow.withOpacity(0.1),
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: 10, // Max pain position
                      color: Colors.yellow,
                      strokeWidth: 2,
                      dashArray: [5, 5],
                      label: VerticalLineLabel(
                        show: true,
                        labelResolver: (line) => 'Max Pain',
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrikePriceAnalysis() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Strike Price Analysis',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFF1E1E2E)),
                children: [
                  _buildTableHeader('Strike'),
                  _buildTableHeader('Calls'),
                  _buildTableHeader('Puts'),
                  _buildTableHeader('Total'),
                ],
              ),
              ...List.generate(5, (index) {
                int strike = 94000 + index * 1000;
                double calls = 20000 + Random().nextDouble() * 30000;
                double puts = 15000 + Random().nextDouble() * 25000;
                return TableRow(
                  children: [
                    _buildTableCell('\${strike}'),
                    _buildTableCell('${(calls / 1000).toStringAsFixed(1)}K'),
                    _buildTableCell('${(puts / 1000).toStringAsFixed(1)}K'),
                    _buildTableCell('${((calls + puts) / 1000).toStringAsFixed(1)}K'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Exercised Today',
            '1,247',
            '+8.3%',
            Colors.blue,
            Icons.assignment_turned_in,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Exercise Value',
            '\$12.4M',
            '+15.2%',
            Colors.green,
            Icons.monetization_on,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseHistoryTable() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Exercise History',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Table(
            columnWidths: {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFF1E1E2E)),
                children: [
                  _buildTableHeader('Time'),
                  _buildTableHeader('Strike'),
                  _buildTableHeader('Type'),
                  _buildTableHeader('Amount'),
                  _buildTableHeader('Value'),
                ],
              ),
              ...List.generate(6, (index) {
                List<String> times = ['15:30', '15:25', '15:20', '15:15', '15:10', '15:05'];
                List<String> strikes = ['96000', '95000', '97000', '94000', '98000', '95500'];
                List<String> types = ['Call', 'Put', 'Call', 'Put', 'Call', 'Call'];
                return TableRow(
                  children: [
                    _buildTableCell(times[index]),
                    _buildTableCell('\${strikes[index]}'),
                    _buildTableCell(
                      types[index],
                      color: types[index] == 'Call' ? Colors.green : Colors.red,
                    ),
                    _buildTableCell('${(100 + Random().nextDouble() * 500).toStringAsFixed(0)}'),
                    _buildTableCell('\${(50000 + Random().nextDouble() * 200000).toStringAsFixed(0)}'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseVolumeChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262637),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Volume Over Time',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 500,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> hours = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00'];
                        return Text(
                          hours[value.toInt() % hours.length],
                          style: TextStyle(color: Colors.grey[400], fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: 100 + Random().nextDouble() * 400,
                        color: Colors.blue,
                        width: 30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {Color? color}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.grey[300],
          fontSize: 11,
        ),
      ),
    );
  }
}

// Data Models
class OpenInterestItem {
  final String strike;
  final String type;
  final double value;
  final double percentage;

  OpenInterestItem(this.strike, this.type, this.value, this.percentage);
}

class VolumeItem {
  final String strike;
  final String type;
  final double value;
  final double percentage;

  VolumeItem(this.strike, this.type, this.value, this.percentage);
}

class TakerFlowItem {
  final String time;
  final double buyVolume;
  final double sellVolume;
  final double netFlow;

  TakerFlowItem(this.time, this.buyVolume, this.sellVolume, this.netFlow);
}*/

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedTimeframe = '1D';
  String selectedDataType = 'Open Interest';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to determine if device is desktop/tablet
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  // Helper method to get responsive padding
  EdgeInsets _getResponsivePadding(BuildContext context) {
    return _isDesktop(context) 
        ? EdgeInsets.all(55.0) // Increased desktop padding
        : EdgeInsets.all(16.0); // Mobile padding
  }

  // Helper method to get responsive horizontal padding
  EdgeInsets _getResponsiveHorizontalPadding(BuildContext context) {
    return _isDesktop(context) 
        ? EdgeInsets.symmetric(horizontal: 24.0) // Increased desktop padding
        : EdgeInsets.symmetric(horizontal: 16.0); // Mobile padding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildTimeframeSelector(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOpenInterestTab(),
                _buildTradingVolumeTab(),
                _buildPutCallRatioTab(),
                _buildMaxPainTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFF00D4AA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'SOLUSDT Options Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: _isDesktop(context) ? 18 : 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: _getResponsivePadding(context),
      child: _isDesktop(context) 
        ? Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Current Price',
                  '\$194.17',
                  '+2.45%',
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '24h Volume',
                  '\$1.2B',
                  '+15.2%',
                  Colors.green,
                  Icons.bar_chart,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Open Interest',
                  '\$45.7M',
                  '-3.1%',
                  Colors.red,
                  Icons.account_balance,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Current Price',
                      '\$194.17',
                      '+2.45%',
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '24h Volume',
                      '\$1.2B',
                      '+15.2%',
                      Colors.green,
                      Icons.bar_chart,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildStatCard(
                'Open Interest',
                '\$45.7M',
                '-3.1%',
                Colors.red,
                Icons.account_balance,
              ),
            ],
          ),
    );
  }

  Widget _buildStatCard(String title, String value, String change, Color changeColor, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 16),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: changeColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    List<String> timeframes = ['5M', '15M', '1H', '4H', '1D', '1W'];
    
    return Container(
      padding: _getResponsiveHorizontalPadding(context),
      child: Row(
        children: [
          Text(
            'Timeframe:',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeframes.map((timeframe) {
                  bool isSelected = selectedTimeframe == timeframe;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeframe = timeframe;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Color(0xFF2B3139),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        timeframe,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _isDesktop(context) ? 24.0 : 16.0, 
        vertical: 16
      ),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color.fromARGB(255, 122, 79, 223),
          borderRadius: BorderRadius.circular(6),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(
          fontSize: _isDesktop(context) ? 12 : 10, 
          fontWeight: FontWeight.w600
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: _isDesktop(context) ? 12 : 10
        ),
        isScrollable: !_isDesktop(context),
        tabs: [
          Tab(text: 'Open Interest'),
          Tab(text: 'Trading Volume'),
          Tab(text: 'Put/Call Ratio'),
          Tab(text: 'Max Pain'),
        ],
      ),
    );
  }

  Widget _buildOpenInterestTab() {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          _buildChartContainer(
            'Open Interest Distribution',
            _buildOpenInterestChart(),
          ),
          SizedBox(height: 16),
          _buildDataTable(),
        ],
      ),
    );
  }

  Widget _buildTradingVolumeTab() {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          _buildChartContainer(
            'Trading Volume Analysis',
            _buildVolumeChart(),
          ),
          SizedBox(height: 16),
          _buildVolumeDataTable(),
        ],
      ),
    );
  }

  Widget _buildPutCallRatioTab() {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          _buildChartContainer(
            'Put/Call Ratio',
            _buildPutCallChart(),
          ),
          SizedBox(height: 16),
          _buildPutCallDataTable(),
        ],
      ),
    );
  }

  Widget _buildMaxPainTab() {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        children: [
          _buildChartContainer(
            'Max Pain Analysis',
            _buildMaxPainChart(),
          ),
          SizedBox(height: 16),
          _buildMaxPainInfo(),
        ],
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
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
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: _isDesktop(context) ? 300 : 250,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildOpenInterestChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xFF2B3139),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Color(0xFF2B3139),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: _isDesktop(context) ? 12 : 10,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = Text('00:00', style: style);
                    break;
                  case 1:
                    text = Text('04:00', style: style);
                    break;
                  case 2:
                    text = Text('08:00', style: style);
                    break;
                  case 3:
                    text = Text('12:00', style: style);
                    break;
                  case 4:
                    text = Text('16:00', style: style);
                    break;
                  case 5:
                    text = Text('20:00', style: style);
                    break;
                  default:
                    text = Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}M',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: _isDesktop(context) ? 12 : 10,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Color(0xFF2B3139)),
        ),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 50,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 35),
              FlSpot(1, 28),
              FlSpot(2, 42),
              FlSpot(3, 38),
              FlSpot(4, 45),
              FlSpot(5, 41),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [Color(0xFF00D4AA), Color(0xFF00D4AA).withOpacity(0.3)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00D4AA).withOpacity(0.3),
                  Color(0xFF00D4AA).withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            //tooltipBgColor: Color(0xFF2B3139),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()}%',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: _isDesktop(context) ? 12 : 10,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = Text('Call', style: style);
                    break;
                  case 1:
                    text = Text('Put', style: style);
                    break;
                  default:
                    text = Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 75,
                color: Color(0xFF00D4AA),
                width: _isDesktop(context) ? 40 : 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 45,
                color: Color(0xFFF6465D),
                width: _isDesktop(context) ? 40 : 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPutCallChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: _isDesktop(context) ? 60 : 40,
        sections: [
          PieChartSectionData(
            color: Color(0xFF00D4AA),
            value: 65,
            title: 'Call\n65%',
            radius: _isDesktop(context) ? 80 : 60,
            titleStyle: TextStyle(
              fontSize: _isDesktop(context) ? 12 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Color(0xFFF6465D),
            value: 35,
            title: 'Put\n35%',
            radius: _isDesktop(context) ? 80 : 60,
            titleStyle: TextStyle(
              fontSize: _isDesktop(context) ? 12 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxPainChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xFF2B3139),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${(value * 20 + 180).toInt()}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: _isDesktop(context) ? 10 : 8,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 20),
              FlSpot(1, 60),
              FlSpot(2, 100),
              FlSpot(3, 75),
              FlSpot(4, 30),
            ],
            isCurved: true,
            color: Color.fromARGB(255, 122, 79, 223),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: _isDesktop(context) ? null : MediaQuery.of(context).size.width - 32,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2B3139),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text('Strike Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(child: Text('Call OI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                    Expanded(child: Text('Put OI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                    Expanded(child: Text('Total OI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
                  ],
                ),
              ),
              ..._buildDataRows(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDataRows() {
    List<Map<String, dynamic>> data = [
      {'strike': 190, 'callOI': 1245, 'putOI': 892, 'total': 2137},
      {'strike': 195, 'callOI': 2156, 'putOI': 1456, 'total': 3612},
      {'strike': 200, 'callOI': 3245, 'putOI': 2134, 'total': 5379},
      {'strike': 205, 'callOI': 1876, 'putOI': 1234, 'total': 3110},
      {'strike': 210, 'callOI': 967, 'putOI': 756, 'total': 1723},
    ];

    return data.map((item) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF2B3139), width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(child: Text('\$${item['strike']}', style: TextStyle(color: Colors.white, fontSize: 12))),
            Expanded(child: Text('${item['callOI']}', style: TextStyle(color: Color(0xFF00D4AA), fontSize: 12), textAlign: TextAlign.center)),
            Expanded(child: Text('${item['putOI']}', style: TextStyle(color: Color(0xFFF6465D), fontSize: 12), textAlign: TextAlign.center)),
            Expanded(child: Text('${item['total']}', style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildVolumeDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2B3139),
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                Expanded(child: Text('Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Volume', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                Expanded(child: Text('Change', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
              ],
            ),
          ),
          ...List.generate(5, (index) {
            String time = '${(14 + index * 2).toString().padLeft(2, '0')}:00';
            String volume = '${(1.2 + index * 0.3).toStringAsFixed(1)}M';
            String change = index % 2 == 0 ? '+${(2.5 + index).toStringAsFixed(1)}%' : '-${(1.2 + index).toStringAsFixed(1)}%';
            Color changeColor = index % 2 == 0 ? Color(0xFF00D4AA) : Color(0xFFF6465D);
            
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF2B3139), width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(time, style: TextStyle(color: Colors.white, fontSize: 12))),
                  Expanded(child: Text(volume, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center)),
                  Expanded(child: Text(change, style: TextStyle(color: changeColor, fontSize: 12), textAlign: TextAlign.right)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPutCallDataTable() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Put/Call Ratio:', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('0.54', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Call Volume:', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('1,245,678', style: TextStyle(color: Color(0xFF00D4AA), fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Put Volume:', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('672,354', style: TextStyle(color: Color(0xFFF6465D), fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaxPainInfo() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('Max Pain Price:', style: TextStyle(color: Colors.grey, fontSize: 14))),
              Text('\$195.00', style: TextStyle(color: Color.fromARGB(255, 122, 79, 223), fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Max Pain represents the strike price where the maximum number of options (both puts and calls) will expire worthless.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Price:', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('\$194.17', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('Distance to Max Pain:', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Text('-\$0.83 (-0.43%)', style: TextStyle(color: Color(0xFFF6465D), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}