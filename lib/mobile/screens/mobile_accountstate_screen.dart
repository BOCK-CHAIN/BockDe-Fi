import 'package:flutter/material.dart';

class MobileAccountStateScreen extends StatefulWidget {
  const MobileAccountStateScreen({Key? key}) : super(key: key);

  @override
  State<MobileAccountStateScreen> createState() => _MobileAccountStateScreenState();
}

class _MobileAccountStateScreenState extends State<MobileAccountStateScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample data - replace with your actual data models
  final Map<String, dynamic> accountData = {
    'date': '2025-09-23',
    'userId': '',
    'accountType': 'Wallet',
    'masterAccount': 'All',
    'btcRate': 1.0,
    'btcRateUSD': 111999.0,
    'totalValueBTC': 0.0,
    'spotBTC': 0.0,
    'fundingBTC': 0.0,
    'usdFuturesBTC': 0.0,
    'coinFuturesBTC': 0.0,
    'unrealizedPNL': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'common-title',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Funding'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildFundingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Text(
            'Data refreshes at UTC+0 daily.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Account Details Grid
          _buildAccountDetailsGrid(),
          
          const SizedBox(height: 32),
          
          // Total Value Section
          _buildBalanceCard(
            'Total Value',
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 24),
          
          // Balance Grid
          _buildBalanceGrid(),
          
          const SizedBox(height: 32),
          
          // Spot Section
          const Text(
            'Spot',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildBalanceCard(
            'Total Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
        ],
      ),
    );
  }

  Widget _buildFundingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Funding',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Funding Balance
          _buildBalanceCard(
            'Total Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 24),
          
          // No records found
          _buildNoRecordsSection(),
          
          const SizedBox(height: 32),
          
          // USD(S)-M Futures Section
          const Text(
            'USD(S)-M Futures',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Margin Balance
          _buildBalanceCard(
            'Margin Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 16),
          
          // Wallet Balance and Unrealized PNL
          Row(
            children: [
              Expanded(
                child: _buildSmallBalanceCard(
                  'Wallet Balance',
                  '-- BTC',
                  '≈ -- USDT',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSmallBalanceCard(
                  'Unrealized PNL',
                  '-- BTC',
                  '≈ -- USDT',
                  valueColor: Colors.teal,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Position Section
          const Text(
            'Position',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildNoRecordsSection(),
          
          const SizedBox(height: 24),
          
          // Assets Section
          const Text(
            'Assets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsGrid() {
    return Column(
      children: [
        _buildDetailRow('Date', accountData['date'] as String),
        _buildDetailRow('User ID', ''),
        _buildDetailRow('Account Type', accountData['accountType'] as String),
        _buildDetailRow('Master Account', accountData['masterAccount'] as String),
        const SizedBox(height: 16),
        _buildDetailRow('Rate', ''),
        _buildRateSection(),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1 BTC',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '≈ ${(accountData['btcRateUSD'] as double).toStringAsFixed(0)} USDT',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String title, String btcValue, String usdValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            btcValue,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            usdValue,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBalanceCard(String title, String btcValue, String usdValue,
      {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            btcValue,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          Text(
            usdValue,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceGrid() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSmallBalanceCard('Spot', '-- BTC', '≈ -- USDT'),
              const SizedBox(height: 16),
              _buildSmallBalanceCard('USD(S)-M Futures', '-- BTC', '≈ -- USDT'),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _buildSmallBalanceCard('Funding', '-- BTC', '≈ -- USDT'),
              const SizedBox(height: 16),
              _buildSmallBalanceCard('Coin-M Futures', '-- BTC', '≈ -- USDT'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoRecordsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No records found.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}