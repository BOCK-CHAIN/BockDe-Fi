import 'package:flutter/material.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/app_footer.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  bool _isDarkMode = true;
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0D0D1A) : Colors.grey[100],
      appBar: TopNavigationBar(
        isDarkMode: _isDarkMode,
        onThemeToggle: (bool darkMode) {
          setState(() {
            _isDarkMode = darkMode;
          });
        },
        selectedLanguage: _selectedLanguage,
        onLanguageChange: (String languageCode) {
          setState(() {
            _selectedLanguage = languageCode;
          });
        },
      ),
      /*bottomNavigationBar: isMobile
          ? AppBottomNavigationBar(
              currentIndex: _currentBottomNavIndex,
              onTap: (index) {
                setState(() {
                  _currentBottomNavIndex = index;
                });
              },
            )
          : null,*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Content Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 55,
                vertical: isMobile ? 30 : 60,
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeftContent(isMobile),
                        const SizedBox(height: 40),
                        _buildRightContent(isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Content
                        Expanded(
                          flex: 3,
                          child: _buildLeftContent(isMobile),
                        ),
                        
                        const SizedBox(width: 60),
                        
                        // Right Content
                        Expanded(
                          flex: 2,
                          child: _buildRightContent(isMobile),
                        ),
                      ],
                    ),
            ),
            
            // Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Headline
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: 'Get Verified',
                style: TextStyle(
                  color: const Color.fromARGB(255, 122, 79, 223), // Binance yellow
                ),
              ),
              TextSpan(
                text: ' and\nStart Your Crypto\nJourney',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // Balance Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your Estimated Balance',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.help_outline,
                  size: 16,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Balance Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '0.00',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                    fontSize: isMobile ? 36 : 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'BTC',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '≈ \$0.00',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[500] : Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Text(
              'Today\'s PnL  \$0.00 (0.00%)',
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // Action Buttons
        Row(
          children: [
            // Verify Now Button
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223), // Binance yellow
                borderRadius: BorderRadius.circular(6),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Verify action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Verify Now',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Watch Tutorial Button
            TextButton.icon(
              onPressed: () {
                // Watch tutorial action
              },
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 16,
                ),
              ),
              label: Text(
                'Watch Tutorial',
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Popular/New Listing Tabs
        Row(
          children: [
            _buildTab('Popular', true),
            const SizedBox(width: 24),
            _buildTab('New Listing', false),
            const Spacer(),
            if (!isMobile)
              TextButton(
                onPressed: () {
                  // View all coins action
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All 350+ Coins',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 14,
                    ),
                  ],
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Crypto List
        Column(
          children: [
            _buildCryptoItem('BTC', 'Bitcoin', '\$110,357.76', '-0.78%', false, Icons.currency_bitcoin, const Color(0xFFF7931A)),
            _buildCryptoItem('ETH', 'Ethereum', '\$4,435.55', '-3.01%', false, Icons.diamond, const Color(0xFF627EEA)),
            _buildCryptoItem('BNB', 'BNB', '\$844.97', '-1.17%', false, Icons.hexagon, const Color(0xFFF0B90B)),
            _buildCryptoItem('XRP', 'XRP', '\$2.92', '-0.42%', false, Icons.water_drop, const Color(0xFF00AAE4)),
            _buildCryptoItem('SOL', 'Solana', '\$189.54', '-4.59%', false, Icons.wb_sunny, const Color(0xFF9945FF)),
          ],
        ),
        
        const SizedBox(height: 40),
        
        // News Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all news action
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All News',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // News Items
            Column(
              children: [
                _buildNewsItem(
                  'Ethereum Holdings Impact Valuation of SharpLink and Bitmine',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  'Ethereum(ETH) Drops Below 4,400 USDT with a 5.10% Decrease in 24 Hours',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  'Bitcoin Faces Potential Volatility Amid Market Sentiment',
                ),
              ],
            ),
          ],
        ),
        
        if (isMobile) ...[
          const SizedBox(height: 30),
          Center(
            child: TextButton(
              onPressed: () {
                // View all coins action
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All 350+ Coins',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isActive
                ? (_isDarkMode ? Colors.white : Colors.black87)
                : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 122, 79, 223), // Binance yellow
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCryptoItem(String symbol, String name, String price, String change, bool isPositive, IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 18,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Symbol and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Price and Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? const Color(0xFF0ECB81) : const Color(0xFFF6465D),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: _isDarkMode ? Colors.grey[300] : Colors.black87,
          fontSize: 14,
          height: 1.4,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}