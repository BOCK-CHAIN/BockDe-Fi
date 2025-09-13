import 'package:flutter/material.dart';

class DualInvestScreen extends StatefulWidget {
  const DualInvestScreen({Key? key}) : super(key: key);

  @override
  State<DualInvestScreen> createState() => _DualInvestScreenState();
}

class _DualInvestScreenState extends State<DualInvestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Pagination
  int _sellHighCurrentPage = 1;
  int _buyLowCurrentPage = 1;
  final int _sellHighTotalPages = 101;
  final int _buyLowTotalPages = 83;
  final int _itemsPerPage = 10;

  // Filters
  String _selectedCoin = 'All';
  String _selectedAPR = 'All';
  String _selectedSettlement = 'All';

  // Filter options
  final List<String> _coinOptions = ['All', 'BTC/USDT', 'ETH/USDT', 'BNB/USDT', 'SOL/USDT', 'ADA/USDT', 'DOT/USDT'];
  final List<String> _aprOptions = ['All', '0-50%', '50-100%', '100-200%', '200%+'];
  final List<String> _settlementOptions = ['All', '1-7 days', '8-15 days', '16-30 days', '30+ days'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample data generation for sell high
  List<Map<String, dynamic>> _generateSellHighData(int page) {
    return List.generate(_itemsPerPage, (index) {
      final itemIndex = (page - 1) * _itemsPerPage + index + 1;
      if (itemIndex > _sellHighTotalPages * _itemsPerPage) return null;
      
      final coins = ['BTC/USDT', 'ETH/USDT', 'BNB/USDT', 'SOL/USDT'];
      final coin = coins[itemIndex % coins.length];
      final basePrice = coin == 'BTC/USDT' ? 95000.0 : coin == 'ETH/USDT' ? 3500.0 : coin == 'BNB/USDT' ? 650.0 : 180.0;
      final targetPrice = basePrice * (1.02 + (itemIndex % 20) * 0.01);
      final apr = 15.0 + (itemIndex % 50) * 2.0;
      final daysUntil = 1 + (itemIndex % 30);
      
      return {
        'coin': coin,
        'targetPrice': targetPrice,
        'currentPrice': basePrice,
        'apr': apr,
        'settlement': _getSettlementDate(daysUntil),
        'settlementDays': daysUntil,
        'minAmount': coin == 'BTC/USDT' ? '0.001' : coin == 'ETH/USDT' ? '0.01' : '1.0',
      };
    }).where((item) => item != null).cast<Map<String, dynamic>>().toList();
  }

  // Sample data generation for buy low
  List<Map<String, dynamic>> _generateBuyLowData(int page) {
    return List.generate(_itemsPerPage, (index) {
      final itemIndex = (page - 1) * _itemsPerPage + index + 1;
      if (itemIndex > _buyLowTotalPages * _itemsPerPage) return null;
      
      final coins = ['BTC/USDT', 'ETH/USDT', 'BNB/USDT', 'SOL/USDT'];
      final coin = coins[itemIndex % coins.length];
      final basePrice = coin == 'BTC/USDT' ? 95000.0 : coin == 'ETH/USDT' ? 3500.0 : coin == 'BNB/USDT' ? 650.0 : 180.0;
      final targetPrice = basePrice * (0.95 - (itemIndex % 15) * 0.01);
      final apr = 12.0 + (itemIndex % 45) * 1.8;
      final daysUntil = 1 + (itemIndex % 25);
      
      return {
        'coin': coin,
        'targetPrice': targetPrice,
        'currentPrice': basePrice,
        'apr': apr,
        'settlement': _getSettlementDate(daysUntil),
        'settlementDays': daysUntil,
        'minAmount': coin == 'BTC/USDT' ? '0.001' : coin == 'ETH/USDT' ? '0.01' : '1.0',
      };
    }).where((item) => item != null).cast<Map<String, dynamic>>().toList();
  }

  String _getSettlementDate(int daysFromNow) {
    final now = DateTime.now();
    final settlementDate = now.add(Duration(days: daysFromNow));
    return '${settlementDate.year}-${settlementDate.month.toString().padLeft(2, '0')}-${settlementDate.day.toString().padLeft(2, '0')}';
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Text(
                'Dual Investment',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Buy Low or Sell High - Earn High Rewards',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monetize your market view and get access to potentially high rewards.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color.fromARGB(255, 122, 79, 223),
          borderRadius: BorderRadius.circular(6),
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Sell High'),
          Tab(text: 'Buy Low'),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildFilterDropdown('Coin', _selectedCoin, _coinOptions, (value) {
            setState(() => _selectedCoin = value!);
          }),
          const SizedBox(width: 16),
          _buildFilterDropdown('APR', _selectedAPR, _aprOptions, (value) {
            setState(() => _selectedAPR = value!);
          }),
          const SizedBox(width: 16),
          _buildFilterDropdown('Settlement', _selectedSettlement, _settlementOptions, (value) {
            setState(() => _selectedSettlement = value!);
          }),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCoin = 'All';
                _selectedAPR = 'All';
                _selectedSettlement = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        dropdownColor: Colors.grey.shade800,
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        hint: Text(label, style: const TextStyle(color: Colors.grey)),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataTable(List<Map<String, dynamic>> data, bool isSellHigh) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Target Price', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text('APR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Settlement Date', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          // Table rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade700, height: 1),
            itemBuilder: (context, index) {
              final item = data[index];
              final isAboveTarget = isSellHigh ? 
                item['currentPrice'] >= item['targetPrice'] : 
                item['currentPrice'] <= item['targetPrice'];
              
              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Target Price
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['coin'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item['targetPrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isSellHigh ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Current: \$${item['currentPrice'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // APR
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item['apr'].toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Settlement Date
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['settlement'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${item['settlementDays']} days',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          _showInvestDialog(item, isSellHigh);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Invest', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(bool isSellHigh) {
    final currentPage = isSellHigh ? _sellHighCurrentPage : _buyLowCurrentPage;
    final totalPages = isSellHigh ? _sellHighTotalPages : _buyLowTotalPages;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1 ? () {
              setState(() {
                if (isSellHigh) {
                  _sellHighCurrentPage--;
                } else {
                  _buyLowCurrentPage--;
                }
              });
            } : null,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          ...List.generate(
            7,
            (index) {
              int pageNum;
              if (currentPage <= 4) {
                pageNum = index + 1;
              } else if (currentPage >= totalPages - 3) {
                pageNum = totalPages - 6 + index;
              } else {
                pageNum = currentPage - 3 + index;
              }
              
              if (pageNum < 1 || pageNum > totalPages) return const SizedBox();
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSellHigh) {
                      _sellHighCurrentPage = pageNum;
                    } else {
                      _buyLowCurrentPage = pageNum;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: pageNum == currentPage ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: pageNum == currentPage ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: currentPage < totalPages ? () {
              setState(() {
                if (isSellHigh) {
                  _sellHighCurrentPage++;
                } else {
                  _buyLowCurrentPage++;
                }
              });
            } : null,
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showInvestDialog(Map<String, dynamic> item, bool isSellHigh) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            '${isSellHigh ? "Sell High" : "Buy Low"} - ${item['coin']}',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Target Price: \$${item['targetPrice'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              Text('APR: ${item['apr'].toStringAsFixed(2)}%', style: const TextStyle(color: Colors.green)),
              Text('Settlement: ${item['settlement']}', style: const TextStyle(color: Colors.white)),
              Text('Min Amount: ${item['minAmount']} ${item['coin'].split('/')[0]}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Investment in ${item['coin']} initiated!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 122, 79, 223), foregroundColor: Colors.black),
              child: const Text('Invest'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Sell High Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDataTable(_generateSellHighData(_sellHighCurrentPage), true),
                      _buildPagination(true),
                    ],
                  ),
                ),
                // Buy Low Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDataTable(_generateBuyLowData(_buyLowCurrentPage), false),
                      _buildPagination(false),
                    ],
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