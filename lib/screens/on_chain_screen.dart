import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnChainScreen extends StatefulWidget {
  const OnChainScreen({Key? key}) : super(key: key);

  @override
  State<OnChainScreen> createState() => _OnChainScreenState();
}

class _OnChainScreenState extends State<OnChainScreen> {
  final List<OnChainYieldData> yieldData = [
    OnChainYieldData(
      coinIcon: Icons.attach_money,
      coinName: 'USDT',
      coinColor: Colors.green,
      protocol: 'Plasma',
      earningsIcon: Icons.attach_money,
      earningsName: 'USDT',
      earningsColor: Colors.green,
      apr: '2%',
      duration: 'Locked',
      hasExtraRewards: true,
      protocolColor: Colors.blue,
    ),
    OnChainYieldData(
      coinIcon: Icons.currency_bitcoin,
      coinName: 'BTC',
      coinColor: Colors.orange,
      protocol: 'Solv',
      earningsIcon: Icons.auto_awesome,
      earningsName: 'SOLV',
      earningsColor: Colors.purple,
      apr: '0.8% - 1.6%',
      duration: 'Locked',
      hasExtraRewards: false,
      protocolColor: Colors.purple,
    ),
    OnChainYieldData(
      coinIcon: Icons.account_balance,
      coinName: 'WBETH',
      coinColor: Colors.yellow,
      protocol: 'EigenLayer',
      earningsIcon: Icons.diamond,
      earningsName: 'EIGEN',
      earningsColor: Colors.indigo,
      apr: '0.2% - 0.4%',
      duration: 'Locked',
      hasExtraRewards: false,
      protocolColor: Colors.indigo,
    ),
    OnChainYieldData(
      coinIcon: Icons.monetization_on,
      coinName: 'BNB',
      coinColor: Colors.amber,
      protocol: 'Lista',
      earningsIcon: Icons.monetization_on,
      earningsName: 'BNB',
      earningsColor: Colors.amber,
      apr: '0.2% - 0.4%',
      duration: 'Locked',
      hasExtraRewards: false,
      protocolColor: Colors.amber,
    ),
  ];

  void _showSubscribeDialog(OnChainYieldData data) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return SubscribeDialog(yieldData: data);
      },
    );
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
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/binance_logo.png', // You'll need to add this asset
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.account_balance, color: Color.fromARGB(255, 122, 79, 223)),
            ),
            const SizedBox(width: 8),
            Text(
              'BINANCE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            margin: EdgeInsets.only(right: padding * 0.5),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16, 
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Deposit',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
            
            SizedBox(height: padding * 2),
            
            // Table
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Table Header - hide on mobile
                  if (!isMobile) _buildTableHeader(),
                  
                  // Table Rows
                  ...yieldData.asMap().entries.map((entry) {
                    int index = entry.key;
                    OnChainYieldData data = entry.value;
                    bool isLast = index == yieldData.length - 1;
                    
                    return Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A20),
                        border: Border(
                          bottom: BorderSide(
                            color: isLast ? Colors.transparent : Colors.white10,
                            width: 1,
                          ),
                        ),
                        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(8)) : null,
                      ),
                      child: isMobile 
                          ? _buildMobileRow(data)
                          : _buildDesktopRow(data),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'On-Chain Yields',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Unlock the potential of on-chain rewards and stay ahead with earning opportunities.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'What is On-Chain Yields',
              style: TextStyle(
                color: Color.fromARGB(255, 122, 79, 223),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.info_outline,
              color: Color.fromARGB(255, 122, 79, 223),
              size: 14,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Simplified mobile animation
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.monetization_on,
                color: Color.fromARGB(255, 122, 79, 223),
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'On-Chain Yields',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Unlock the potential of on-chain rewards and stay ahead with earning opportunities.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'What is On-Chain Yields',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.info_outline,
                    color: Color.fromARGB(255, 122, 79, 223),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Animated Yield Icon
        Container(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating ring
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),
              ),
              // Hexagonal dots around the ring
              ...List.generate(6, (index) {
                final angle = (index * 60) * 3.14159 / 180;
                final radius = 90.0;
                return Positioned(
                  left: 100 + radius * math.cos(angle) - 8,
                  top: 100 + radius * math.sin(angle) - 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.white60,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
              // Center golden coin
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 122, 79, 223),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monetization_on,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 768 ? 32.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: padding),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Coins',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Protocols',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Earnings',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'APR',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Duration',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 100), // Space for Subscribe button
        ],
      ),
    );
  }

  Widget _buildMobileRow(OnChainYieldData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Coin and Subscribe button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: data.coinColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.coinIcon,
                    color: data.coinColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.coinName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data.protocol,
                      style: TextStyle(
                        color: data.protocolColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _showSubscribeDialog(data),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Subscribe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Details row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Earnings column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earnings',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: data.earningsColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        data.earningsIcon,
                        color: data.earningsColor,
                        size: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.earningsName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (data.hasExtraRewards) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      '⚡ Extra Rewards',
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 79, 223),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            
            // APR column
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'APR',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.apr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            // Duration column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.duration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopRow(OnChainYieldData data) {
    return Row(
      children: [
        // Coins
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: data.coinColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.coinIcon,
                  color: data.coinColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                data.coinName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Protocols
        Expanded(
          flex: 2,
          child: Text(
            data.protocol,
            style: TextStyle(
              color: data.protocolColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Earnings
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: data.earningsColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.earningsIcon,
                  color: data.earningsColor,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.earningsName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              if (data.hasExtraRewards) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '⚡ Extra Rewards',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // APR
        Expanded(
          flex: 1,
          child: Text(
            data.apr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Duration
        Expanded(
          flex: 1,
          child: Text(
            data.duration,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        
        // Subscribe Button
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () => _showSubscribeDialog(data),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Subscribe',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnChainYieldData {
  final IconData coinIcon;
  final String coinName;
  final Color coinColor;
  final String protocol;
  final Color protocolColor;
  final IconData earningsIcon;
  final String earningsName;
  final Color earningsColor;
  final String apr;
  final String duration;
  final bool hasExtraRewards;

  OnChainYieldData({
    required this.coinIcon,
    required this.coinName,
    required this.coinColor,
    required this.protocol,
    required this.protocolColor,
    required this.earningsIcon,
    required this.earningsName,
    required this.earningsColor,
    required this.apr,
    required this.duration,
    required this.hasExtraRewards,
  });
}

class SubscribeDialog extends StatefulWidget {
  final OnChainYieldData yieldData;

  const SubscribeDialog({Key? key, required this.yieldData}) : super(key: key);

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _autoSubscribe = false;
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isDesktop = screenWidth > 768;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 20 : 40,
      ),
      child: Container(
        width: isMobile ? double.infinity : (isDesktop ? 600 : 500),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 100,
        ),
        padding: EdgeInsets.all(isMobile ? 16 : (isDesktop ? 32 : 24)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2329),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Subscribe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 6 : 8, 
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Product Rules',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isMobile ? 10 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 16 : 24),
              
              // Sold Out Warning (for USDT/Plasma as shown in image)
              if (widget.yieldData.coinName == 'USDT')
                Container(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  margin: EdgeInsets.only(bottom: isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info, 
                        color: const Color.fromARGB(255, 122, 79, 223), 
                        size: isMobile ? 18 : 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'The product has been sold out, and there is an insufficient amount available to subscribe.',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // APR Display
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '60D',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.yieldData.apr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.yieldData.hasExtraRewards) ...[
                          SizedBox(width: isMobile ? 8 : 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 6 : 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '⚡ Extra Rewards',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 122, 79, 223),
                                fontSize: isMobile ? 10 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isMobile ? 16 : 20),
              
              // Source of Rewards
              Row(
                children: [
                  Text(
                    'Source of Rewards',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.info_outline, 
                    color: Colors.white70, 
                    size: isMobile ? 14 : 16,
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 8 : 12),
              
              Row(
                children: [
                  Container(
                    width: isMobile ? 16 : 20,
                    height: isMobile ? 16 : 20,
                    decoration: BoxDecoration(
                      color: widget.yieldData.protocolColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.circle,
                      color: widget.yieldData.protocolColor,
                      size: isMobile ? 8 : 12,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    widget.yieldData.protocol,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 16 : 20),
              
              // XPL Airdrop Note (for Plasma/USDT)
              if (widget.yieldData.protocol == 'Plasma')
                Container(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  margin: EdgeInsets.only(bottom: isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info, 
                            color: Colors.blue, 
                            size: isMobile ? 14 : 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please note that the APR is in USDT, not the APR at which XPL',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: isMobile ? 11 : 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 2 : 4),
                      Wrap(
                        children: [
                          Text(
                            'Airdrops are distributed post TGE. Find out more about the XPL Airdrop allocation ',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: isMobile ? 11 : 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'here.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 122, 79, 223),
                                fontSize: isMobile ? 11 : 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              // Subscribe Amount
              Text(
                'Subscribe Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: isMobile ? 8 : 12),
              
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16, 
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Min 100',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: isMobile ? 14 : 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: isMobile ? 16 : 20,
                          height: isMobile ? 16 : 20,
                          decoration: BoxDecoration(
                            color: widget.yieldData.coinColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.yieldData.coinIcon,
                            color: widget.yieldData.coinColor,
                            size: isMobile ? 10 : 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.yieldData.coinName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            // Set MAX amount logic here
                          },
                          child: Text(
                            'MAX',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              fontSize: isMobile ? 10 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              // Auto-Subscribe Checkbox
              Row(
                children: [
                  Transform.scale(
                    scale: isMobile ? 0.9 : 1.0,
                    child: Checkbox(
                      value: _autoSubscribe,
                      onChanged: (value) {
                        setState(() {
                          _autoSubscribe = value ?? false;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 122, 79, 223),
                      checkColor: Colors.black,
                    ),
                  ),
                  Text(
                    'Auto-Subscribe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: isMobile ? 0.9 : 1.0,
                    child: Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 122, 79, 223),
                      checkColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: isMobile ? 12 : 15),
                      child: Text.rich(
                        TextSpan(
                          text: 'I have read and agreed to ',
                          style: TextStyle(
                            color: Colors.white70, 
                            fontSize: isMobile ? 11 : 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'On-chain Yields Service Terms and Conditions',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 122, 79, 223),
                                decoration: TextDecoration.underline,
                                fontSize: isMobile ? 11 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 20 : 24),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _acceptedTerms && _amountController.text.isNotEmpty
                      ? () {
                          // Handle subscription logic here
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Subscription request submitted!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}