import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';

class UsdScreen extends StatefulWidget {
  @override
  _UsdScreenState createState() => _UsdScreenState();
}

class _UsdScreenState extends State<UsdScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;
  String selectedSymbol = 'BTCUSDT';
  String selectedPeriod = '5m';
  
  // Data storage
  List<FlSpot> openInterestData = [];
  List<FlSpot> topTraderAccountRatioData = [];
  List<FlSpot> topTraderPositionRatioData = [];
  List<FlSpot> longShortRatioData = [];
  List<FlSpot> takerBuySellVolumeData = [];
  List<FlSpot> basisData = [];
  List<FlSpot> fundingRateData = [];
  
  // Current values
  double currentOpenInterest = 0.0;
  double currentAccountRatio = 0.0;
  double currentPositionRatio = 0.0;
  double currentLongShortRatio = 0.0;
  double currentTakerVolume = 0.0;
  double currentBasis = 0.0;
  double currentFundingRate = 0.0;
  
  final List<String> symbols = [
    'BTCUSDT', 'ETHUSDT', 'ADAUSDT', 'BNBUSDT', 'XRPUSDT', 
    'SOLUSDT', 'DOGEUSDT', 'DOTUSDT', 'MATICUSDT', 'LTCUSDT'
  ];
  
  final List<String> periods = ['5m', '15m', '30m', '1h', '2h', '4h', '6h', '12h', '1d'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _startRealTimeUpdates();
    _fetchAllData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchAllData();
    });
  }

  Future<void> _fetchAllData() async {
    await Future.wait([
      _fetchOpenInterest(),
      _fetchTopTraderAccountRatio(),
      _fetchTopTraderPositionRatio(),
      _fetchLongShortRatio(),
      _fetchTakerBuySellVolume(),
      _fetchBasis(),
      _fetchFundingRate(),
    ]);
  }

  Future<void> _fetchOpenInterest() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/fapi/v1/openInterest?symbol=$selectedSymbol'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final value = double.parse(data['openInterest']);
        setState(() {
          currentOpenInterest = value;
          if (openInterestData.length >= 50) {
            openInterestData.removeAt(0);
          }
          openInterestData.add(FlSpot(openInterestData.length.toDouble(), value));
        });
      }
    } catch (e) {
      print('Error fetching open interest: $e');
    }
  }

  Future<void> _fetchTopTraderAccountRatio() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/futures/data/topLongShortAccountRatio?symbol=$selectedSymbol&period=$selectedPeriod&limit=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final ratio = double.parse(data[0]['longShortRatio']);
          setState(() {
            currentAccountRatio = ratio;
            if (topTraderAccountRatioData.length >= 50) {
              topTraderAccountRatioData.removeAt(0);
            }
            topTraderAccountRatioData.add(FlSpot(topTraderAccountRatioData.length.toDouble(), ratio));
          });
        }
      }
    } catch (e) {
      print('Error fetching top trader account ratio: $e');
    }
  }

  Future<void> _fetchTopTraderPositionRatio() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/futures/data/topLongShortPositionRatio?symbol=$selectedSymbol&period=$selectedPeriod&limit=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final ratio = double.parse(data[0]['longShortRatio']);
          setState(() {
            currentPositionRatio = ratio;
            if (topTraderPositionRatioData.length >= 50) {
              topTraderPositionRatioData.removeAt(0);
            }
            topTraderPositionRatioData.add(FlSpot(topTraderPositionRatioData.length.toDouble(), ratio));
          });
        }
      }
    } catch (e) {
      print('Error fetching top trader position ratio: $e');
    }
  }

  Future<void> _fetchLongShortRatio() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/futures/data/globalLongShortAccountRatio?symbol=$selectedSymbol&period=$selectedPeriod&limit=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final ratio = double.parse(data[0]['longShortRatio']);
          setState(() {
            currentLongShortRatio = ratio;
            if (longShortRatioData.length >= 50) {
              longShortRatioData.removeAt(0);
            }
            longShortRatioData.add(FlSpot(longShortRatioData.length.toDouble(), ratio));
          });
        }
      }
    } catch (e) {
      print('Error fetching long/short ratio: $e');
    }
  }

  Future<void> _fetchTakerBuySellVolume() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/futures/data/takerlongshortRatio?symbol=$selectedSymbol&period=$selectedPeriod&limit=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final buySellRatio = double.parse(data[0]['buySellRatio']);
          setState(() {
            currentTakerVolume = buySellRatio;
            if (takerBuySellVolumeData.length >= 50) {
              takerBuySellVolumeData.removeAt(0);
            }
            takerBuySellVolumeData.add(FlSpot(takerBuySellVolumeData.length.toDouble(), buySellRatio));
          });
        }
      }
    } catch (e) {
      print('Error fetching taker buy/sell volume: $e');
    }
  }

  Future<void> _fetchBasis() async {
    try {
      // Fetch both spot and futures price to calculate basis
      final futuresResponse = await http.get(
        Uri.parse('https://fapi.binance.com/fapi/v1/ticker/price?symbol=$selectedSymbol'),
      );
      final spotResponse = await http.get(
        Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=$selectedSymbol'),
      );
      
      if (futuresResponse.statusCode == 200 && spotResponse.statusCode == 200) {
        final futuresData = json.decode(futuresResponse.body);
        final spotData = json.decode(spotResponse.body);
        
        final futuresPrice = double.parse(futuresData['price']);
        final spotPrice = double.parse(spotData['price']);
        final basis = ((futuresPrice - spotPrice) / spotPrice) * 100;
        
        setState(() {
          currentBasis = basis;
          if (basisData.length >= 50) {
            basisData.removeAt(0);
          }
          basisData.add(FlSpot(basisData.length.toDouble(), basis));
        });
      }
    } catch (e) {
      print('Error fetching basis: $e');
    }
  }

  Future<void> _fetchFundingRate() async {
    try {
      final response = await http.get(
        Uri.parse('https://fapi.binance.com/fapi/v1/fundingRate?symbol=$selectedSymbol&limit=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final fundingRate = double.parse(data[0]['fundingRate']) * 100;
          setState(() {
            currentFundingRate = fundingRate;
            if (fundingRateData.length >= 50) {
              fundingRateData.removeAt(0);
            }
            fundingRateData.add(FlSpot(fundingRateData.length.toDouble(), fundingRate));
          });
        }
      }
    } catch (e) {
      print('Error fetching funding rate: $e');
    }
  }

  Widget _buildChart(List<FlSpot> data, String title, double currentValue, Color color, String suffix) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2D2D2D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${currentValue.toStringAsFixed(4)}$suffix',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 120,
            child: data.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Color(0xFF2D2D2D),
                            strokeWidth: 0.5,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                          isCurved: true,
                          color: color,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withOpacity(0.1),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(bottom: BorderSide(color: Color(0xFF2D2D2D))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'USD Futures Trading Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 8),
                    SizedBox(width: 4),
                    Text('Live', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Symbol selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: selectedSymbol,
                  dropdownColor: Color(0xFF2D2D2D),
                  style: TextStyle(color: Colors.white),
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedSymbol = newValue;
                        // Clear existing data
                        openInterestData.clear();
                        topTraderAccountRatioData.clear();
                        topTraderPositionRatioData.clear();
                        longShortRatioData.clear();
                        takerBuySellVolumeData.clear();
                        basisData.clear();
                        fundingRateData.clear();
                      });
                      _fetchAllData();
                    }
                  },
                  items: symbols.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 16),
              // Period selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  dropdownColor: Color(0xFF2D2D2D),
                  style: TextStyle(color: Colors.white),
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPeriod = newValue;
                      });
                      _fetchAllData();
                    }
                  },
                  items: periods.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: _fetchAllData,
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Color(0xFF181818),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Color.fromARGB(255, 122, 79, 223),
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: [
          Tab(text: 'Open Interest'),
          Tab(text: 'Top Trader L/S (Accounts)'),
          Tab(text: 'Top Trader L/S (Positions)'),
          Tab(text: 'Long/Short Ratio'),
          Tab(text: 'Taker Buy/Sell Volume'),
          Tab(text: 'Basis'),
          Tab(text: 'Funding Rate'),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF2D2D2D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          _buildHeader(),
          
          // Quick stats row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Open Interest',
                    currentOpenInterest.toStringAsFixed(0),
                    'USDT',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatsCard(
                    'Funding Rate',
                    '${currentFundingRate.toStringAsFixed(4)}%',
                    '8h Rate',
                    currentFundingRate >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatsCard(
                    'Long/Short',
                    currentLongShortRatio.toStringAsFixed(2),
                    'Ratio',
                    currentLongShortRatio >= 1 ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatsCard(
                    'Basis',
                    '${currentBasis.toStringAsFixed(4)}%',
                    'Spread',
                    currentBasis >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          _buildTabBar(),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Open Interest
                SingleChildScrollView(
                  child: _buildChart(
                    openInterestData,
                    'Open Interest',
                    currentOpenInterest,
                    Colors.blue,
                    ' USDT',
                  ),
                ),
                
                // Top Trader Long/Short Ratio (Accounts)
                SingleChildScrollView(
                  child: _buildChart(
                    topTraderAccountRatioData,
                    'Top Trader Long/Short Ratio (Accounts)',
                    currentAccountRatio,
                    Colors.orange,
                    '',
                  ),
                ),
                
                // Top Trader Long/Short Ratio (Positions)
                SingleChildScrollView(
                  child: _buildChart(
                    topTraderPositionRatioData,
                    'Top Trader Long/Short Ratio (Positions)',
                    currentPositionRatio,
                    Colors.purple,
                    '',
                  ),
                ),
                
                // Long/Short Ratio
                SingleChildScrollView(
                  child: _buildChart(
                    longShortRatioData,
                    'Long/Short Ratio',
                    currentLongShortRatio,
                    Colors.green,
                    '',
                  ),
                ),
                
                // Taker Buy/Sell Volume
                SingleChildScrollView(
                  child: _buildChart(
                    takerBuySellVolumeData,
                    'Taker Buy/Sell Volume',
                    currentTakerVolume,
                    Colors.cyan,
                    '',
                  ),
                ),
                
                // Basis
                SingleChildScrollView(
                  child: _buildChart(
                    basisData,
                    'Basis',
                    currentBasis,
                    Colors.yellow,
                    '%',
                  ),
                ),
                
                // Funding Rate
                SingleChildScrollView(
                  child: _buildChart(
                    fundingRateData,
                    'Funding Rate',
                    currentFundingRate,
                    Colors.red,
                    '%',
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