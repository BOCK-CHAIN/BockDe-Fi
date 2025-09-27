import 'package:bockchain/web/screens/arbitrage_screen.dart';
import 'package:bockchain/web/screens/dual_invest_screen.dart';
import 'package:bockchain/web/screens/on_chain_screen.dart';
import 'package:flutter/material.dart';

class AdvancedScreen extends StatefulWidget {
  const AdvancedScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedScreen> createState() => _AdvancedScreenState();
}

class _AdvancedScreenState extends State<AdvancedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  // Sample data
  final List<Map<String, dynamic>> dualInvestmentData = [
    {
      'coin': 'BTC',
      'icon': '₿',
      'color': Colors.orange,
      'apr': 'Up to 133.05%',
      'settlement': '1-178 days'
    },
    {
      'coin': 'ETH',
      'icon': 'Ξ',
      'color': Colors.blue,
      'apr': 'Up to 205.63%',
      'settlement': '1-115 days'
    },
    {
      'coin': 'BNB',
      'icon': 'BNB',
      'color': Colors.amber,
      'apr': 'Up to 64.47%',
      'settlement': '3-178 days'
    }
  ];

  final List<Map<String, dynamic>> smartArbitrageData = [
    {
      'coin': 'BTC/USDT',
      'icon': '₿',
      'color': Colors.orange,
      'nextAPR': '7.76%',
      'apr30d': '7.47%'
    },
    {
      'coin': 'ETH/USDT',
      'icon': 'Ξ',
      'color': Colors.blue,
      'nextAPR': '4.77%',
      'apr30d': '6.23%'
    },
    {
      'coin': 'SOL/USDT',
      'icon': 'S',
      'color': Colors.purple,
      'nextAPR': '10.95%',
      'apr30d': '5.77%'
    }
  ];

  final List<Map<String, dynamic>> onChainYieldsData = [
    {
      'coin': 'BTC',
      'icon': '₿',
      'color': Colors.orange,
      'protocol': 'Solv',
      'protocolIcon': '🟣',
      'apr': '0.8%-1.1%',
      'soldOut': false
    },
    {
      'coin': 'WBETH',
      'icon': 'W',
      'color': Colors.yellow.shade700,
      'protocol': 'EigenLayer',
      'protocolIcon': '🔵',
      'apr': '0.2%-0.4%',
      'soldOut': false
    },
    {
      'coin': 'USDT',
      'icon': '\$',
      'color': Colors.green,
      'protocol': 'Plasma',
      'protocolIcon': '⚪',
      'apr': '2%',
      'soldOut': true
    }
  ];

  bool get isMobile => MediaQuery.of(context).size.width < 768;
  double get horizontalPadding => isMobile ? 16.0 : 55.0;

  void _handleViewMore(String section) {
    switch (section) {
      case 'dual-investment':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DualInvestScreen()),
        );
        break;
        
      case 'smart-arbitrage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArbitrageScreen()),
        );
        break;
        
      case 'on-chain-yields':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnChainScreen()),
        );
        break;
        
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Section "$section" not found'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Widget _buildCoinIcon(String icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          icon,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isDisabled = false,
  }) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? Colors.grey.shade700
            : isPrimary
                ? const Color.fromARGB(255, 122, 79, 223)
                : Colors.grey.shade800,
        foregroundColor: isDisabled
            ? Colors.grey.shade500
            : isPrimary
                ? Colors.black
                : Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16, 
          vertical: 8
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: isMobile ? 12 : 14,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: isMobile 
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Advanced Earn',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Benefit from our innovative products that are designed to help navigate the various market scenarios.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '*Advanced Earn products involve higher risks. See our ',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'FAQ',
                      style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                    TextSpan(
                      text: ' for more information.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'What is Advanced Earn',
                    style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 30, height: 40, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Container(width: 30, height: 50, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Container(width: 30, height: 60, color: Colors.grey.shade700),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.trending_up,
                    size: 36,
                    color: Color.fromARGB(255, 122, 79, 223),
                  ),
                ],
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Advanced Earn',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Benefit from our innovative products that are designed to help navigate the\nvarious market scenarios.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '*Advanced Earn products involve higher risks. See our ',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'FAQ',
                            style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 122, 79, 223)),
                          ),
                          TextSpan(
                            text: ' for more information.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'What is Advanced Earn',
                          style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: 40, height: 60, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 80, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 100, color: Colors.grey.shade700),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.trending_up,
                      size: 48,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isMobile
        ? Column(
            children: [
              _buildTab('Dual Investment', Icons.link, 0),
              _buildTab('Smart Arbitrage', Icons.smart_toy, 1),
              _buildTab('On-chain Yields', Icons.currency_bitcoin, 2),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTab('Dual Investment', Icons.link, 0),
              _buildTab('Smart Arbitrage', Icons.smart_toy, 1),
              _buildTab('On-chain Yields', Icons.currency_bitcoin, 2),
            ],
          ),
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        width: isMobile ? double.infinity : null,
        margin: isMobile ? const EdgeInsets.symmetric(vertical: 2) : null,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16, 
          vertical: isMobile ? 12 : 8
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade700 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDualInvestmentTab() {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enjoy high rewards - Buy Low, Sell High',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enjoy high rewards - Buy Low, Sell High',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (!isMobile) ...[
                  const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Coins', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('APR', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('Settlement Date', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 3, child: SizedBox()),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                ],
                ...dualInvestmentData.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildCoinIcon(item['icon'], item['color']),
                              const SizedBox(width: 12),
                              Text(
                                item['coin'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('APR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(
                                    item['apr'],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Settlement', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(
                                    item['settlement'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  text: 'Customize',
                                  onPressed: () {},
                                  isPrimary: false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildActionButton(
                                  text: 'Subscribe',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                _buildCoinIcon(item['icon'], item['color']),
                                const SizedBox(width: 12),
                                Text(
                                  item['coin'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['apr'],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['settlement'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                _buildActionButton(
                                  text: 'Customize',
                                  onPressed: () {},
                                  isPrimary: false,
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  text: 'Subscribe',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _handleViewMore('dual-investment'),
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartArbitrageTab() {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arbitrage Steadily and Increase Your Profits Easily',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Arbitrage Steadily and Increase Your Profits Easily',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (!isMobile) ...[
                  const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Portfolio', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('Next APR  00 : 32 : 00', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('30d APR', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                ],
                ...smartArbitrageData.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  _buildCoinIcon(item['icon'], item['color']),
                                  Positioned(
                                    right: -4,
                                    bottom: -4,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '\$',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['coin'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Next APR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(
                                    item['nextAPR'],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('30d APR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(
                                    item['apr30d'],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _buildActionButton(
                              text: 'Subscribe',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    _buildCoinIcon(item['icon'], item['color']),
                                    Positioned(
                                      right: -4,
                                      bottom: -4,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '\$',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item['coin'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['nextAPR'],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['apr30d'],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildActionButton(
                              text: 'Subscribe',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _handleViewMore('smart-arbitrage'),
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnChainYieldsTab() {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unlock the potential of on-chain rewards and stay ahead with earning opportunities.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Unlock the potential of on-chain rewards and stay ahead with earning opportunities.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book, size: 16),
                    label: const Text('Tutorials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (!isMobile) ...[
                  const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Coins', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('Protocols', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: Text('APR', style: TextStyle(color: Colors.grey))),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                ],
                ...onChainYieldsData.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildCoinIcon(item['icon'], item['color']),
                              const SizedBox(width: 12),
                              Text(
                                item['coin'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Protocol', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Row(
                                    children: [
                                      Text(
                                        item['protocolIcon'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['protocol'],
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('APR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(
                                    item['apr'],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: item['soldOut']
                                ? Column(
                                    children: [
                                      const Text(
                                        'Sold Out',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildActionButton(
                                        text: 'Check',
                                        onPressed: () {},
                                        isPrimary: false,
                                        isDisabled: true,
                                      ),
                                    ],
                                  )
                                : _buildActionButton(
                                    text: 'Subscribe',
                                    onPressed: () {},
                                  ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                _buildCoinIcon(item['icon'], item['color']),
                                const SizedBox(width: 12),
                                Text(
                                  item['coin'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  item['protocolIcon'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['protocol'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['apr'],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: item['soldOut']
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sold Out',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildActionButton(
                                        text: 'Check',
                                        onPressed: () {},
                                        isPrimary: false,
                                        isDisabled: true,
                                      ),
                                    ],
                                  )
                                : _buildActionButton(
                                    text: 'Subscribe',
                                    onPressed: () {},
                                  ),
                          ),
                        ],
                      ),
                )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _handleViewMore('on-chain-yields'),
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          _buildHeroSection(),
          _buildCustomTabBar(),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(child: _buildDualInvestmentTab()),
                SingleChildScrollView(child: _buildSmartArbitrageTab()),
                SingleChildScrollView(child: _buildOnChainYieldsTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}