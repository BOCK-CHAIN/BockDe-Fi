import 'package:bockchain/web/screens/deposit_screen.dart';
import 'package:bockchain/web/screens/recurring_buy_screen.dart';
import 'package:bockchain/web/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
// Import your existing widgets
// import 'widgets/top_navigation_bar.dart';
// import 'widgets/app_footer.dart';

class CryptoTheme {
  static const Color backgroundColor = Color.fromARGB(255, 0, 0, 0);
  static const Color cardColor = Color(0xFF1A1F29);
  static const Color primaryColor = Color(0xFF2B3440);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color greenColor = Color(0xFF00D4AA);
  static const Color redColor = Color(0xFFFF4747);
  static const Color yellowColor = Color.fromARGB(255, 122, 79, 223);
}

class BuyCryptoScreen extends StatefulWidget {
  @override
  _BuyCryptoScreenState createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends State<BuyCryptoScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isBuySelected = true;
  String _selectedTimeframe = '1D';

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

  double _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 20.0; // Mobile
    } else if (screenWidth < 1200) {
      return 32.0; // Tablet
    } else {
      return 48.0; // Desktop
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: CryptoTheme.backgroundColor,
    appBar: _buildCustomAppBar(),
    body: Column(
      children: [
        Expanded(
          child: _getSelectedScreen(),
        ),
      ],
    ),
  );
}

Widget _getSelectedScreen() {
  switch (_selectedIndex) {
    case 0:
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildBuySellContent(),
            _buildHowToBuyCryptoSection(),
            _buildTetherUSDTMarketsSection(),
            _buildPopularConversionsSection(),
          ],
        ),
      );
    case 1:
      return RecurringBuyScreen();
    case 2:
      return DepositScreen();
    case 3:
      return WithdrawScreen();
    default:
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildBuySellContent(),
            _buildHowToBuyCryptoSection(),
            _buildTetherUSDTMarketsSection(),
            _buildPopularConversionsSection(),
          ],
        ),
      );
  }
}

PreferredSizeWidget _buildCustomAppBar() {
  return AppBar(
    backgroundColor: CryptoTheme.backgroundColor,
    elevation: 0,
    leading: Container(),
    toolbarHeight: 60,
    title: Container(
      height: 40,
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) => setState(() => _selectedIndex = index),
        indicator: BoxDecoration(
          color: CryptoTheme.primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: CryptoTheme.textPrimary,
        unselectedLabelColor: CryptoTheme.textSecondary,
        labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 13, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: MediaQuery.of(context).size.width < 600 ? 11 : 13, fontWeight: FontWeight.w400),
        tabs: [
          Tab(text: 'Buy & Sell'),
          Tab(text: 'Recurring Buy'),
          Tab(text: 'Deposit'),
          Tab(text: 'Withdraw'),
        ],
      ),
    ),
    actions: MediaQuery.of(context).size.width > 600 ? [
      Container(
        margin: EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, color: CryptoTheme.textPrimary, size: 20),
            SizedBox(width: 4),
            Text('Orders', style: TextStyle(color: CryptoTheme.textPrimary, fontSize: 14)),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline, color: CryptoTheme.textPrimary, size: 20),
            SizedBox(width: 4),
            Text('FAQ', style: TextStyle(color: CryptoTheme.textPrimary, fontSize: 14)),
          ],
        ),
      ),
    ] : null,
  );
}

  Widget _buildBuySellContent() {
    final horizontalPadding = _getHorizontalPadding(context);
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
      child: isMobile ? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeftColumn(),
            SizedBox(height: 32),
            _buildRightColumn(),
          ],
        ) : 
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: _buildLeftColumn(),
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: _buildRightColumn(),
            ),
          ],
        ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Buy USDT with INR',
                style: TextStyle(
                  color: CryptoTheme.textPrimary,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Supported',
              style: TextStyle(
                color: CryptoTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF1A3AC4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFEB001B),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'MC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 48),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width < 600 ? double.infinity : 500),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: CryptoTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2A2F3A), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hot Cryptos',
                style: TextStyle(
                  color: CryptoTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              _buildCryptoRow('BNB', 'assets/bnb.png', '\$856.70', '+0.93%'),
              SizedBox(height: 16),
              _buildCryptoRow('BTC', 'assets/btc.png', '\$111,076.76', '+0.47%'),
              SizedBox(height: 16),
              _buildCryptoRow('ETH', 'assets/eth.png', '\$4,582.34', '+1.38%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: CryptoTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isBuySelected = true),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isBuySelected ? CryptoTheme.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          color: _isBuySelected ? CryptoTheme.textPrimary : CryptoTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isBuySelected = false),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: !_isBuySelected ? CryptoTheme.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Sell',
                        style: TextStyle(
                          color: !_isBuySelected ? CryptoTheme.textPrimary : CryptoTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        _buildSpendSection(),
        SizedBox(height: 16),
        _buildReceiveSection(),
        SizedBox(height: 24),
        _buildPaymentMethodSection(),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: CryptoTheme.yellowColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Add New Card',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spend',
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '1,500 - 100,000',
                  style: TextStyle(
                    color: CryptoTheme.textSecondary,
                    fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2F3A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: CryptoTheme.yellowColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '₹',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'INR',
                      style: TextStyle(
                        color: CryptoTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: CryptoTheme.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiveSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Receive',
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '0',
                  style: TextStyle(
                    color: CryptoTheme.textSecondary,
                    fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2F3A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: CryptoTheme.greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'T',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'USDT',
                      style: TextStyle(
                        color: CryptoTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: CryptoTheme.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2A2F3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A3AC4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Color(0xFFEB001B),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      'MC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Card (VISA/Mastercard)',
                    style: TextStyle(
                      color: CryptoTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: CryptoTheme.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToBuyCryptoSection() {
    final horizontalPadding = _getHorizontalPadding(context);
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Buy Crypto',
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          isMobile ? 
            Column(
              children: [
                _buildHowToStepCard(
                  '1. Enter Amount & Select Payment',
                  'Enter the amount, select the available payment method, and choose the payment account or bind the payment card.',
                  Icons.credit_card,
                ),
                SizedBox(height: 24),
                _buildHowToStepCard(
                  '2. Confirm Order',
                  'Confirmation of transaction detail information, including trading pair quotes, fees, and other explanatory tips.',
                  Icons.shopping_cart,
                ),
                SizedBox(height: 24),
                _buildHowToStepCard(
                  '3. Receive Crypto',
                  'After successful payment, the purchased crypto will be deposited into your Spot or Funding Wallet.',
                  Icons.account_balance_wallet,
                ),
              ],
            ) :
            Row(
              children: [
                Expanded(
                  child: _buildHowToStepCard(
                    '1. Enter Amount & Select Payment',
                    'Enter the amount, select the available payment method, and choose the payment account or bind the payment card.',
                    Icons.credit_card,
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _buildHowToStepCard(
                    '2. Confirm Order',
                    'Confirmation of transaction detail information, including trading pair quotes, fees, and other explanatory tips.',
                    Icons.shopping_cart,
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _buildHowToStepCard(
                    '3. Receive Crypto',
                    'After successful payment, the purchased crypto will be deposited into your Spot or Funding Wallet.',
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHowToStepCard(String title, String description, IconData icon) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2A2F3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF2A2F3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    icon,
                    color: CryptoTheme.textSecondary,
                    size: 28,
                  ),
                ),
                if (title.contains('3.'))
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: CryptoTheme.yellowColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.diamond,
                          color: Colors.black,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                if (title.contains('2.'))
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      width: 20,
                      height: 12,
                      decoration: BoxDecoration(
                        color: CryptoTheme.yellowColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTetherUSDTMarketsSection() {
    final horizontalPadding = _getHorizontalPadding(context);
    final isMobile = MediaQuery.of(context).size.width < 1024;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tether USDt Markets',
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          isMobile ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftChartSection(),
                SizedBox(height: 40),
                _buildRightMarketsSection(),
              ],
            ) :
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildLeftChartSection(),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: _buildRightMarketsSection(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLeftChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUSDTINRInfo(),
        SizedBox(height: 32),
        _buildTimeFrameSelector(),
        SizedBox(height: 24),
        _buildChartPlaceholder(),
      ],
    );
  }

  Widget _buildRightMarketsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Markets',
          style: TextStyle(
            color: CryptoTheme.textPrimary,
            fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 32),
        _buildMarketStatsGrid(),
        SizedBox(height: 32),
        _buildMarketDescription(),
        SizedBox(height: 32),
        Text(
          'Conversion Tables',
          style: TextStyle(
            color: CryptoTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 24),
        _buildExchangeRateCards(),
        SizedBox(height: 40),
        _buildDetailedConversionTables(),
      ],
    );
  }

  Widget _buildUSDTINRInfo() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: CryptoTheme.greenColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'T',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: CryptoTheme.yellowColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '₹',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'USDT/INR',
                style: TextStyle(
                  color: CryptoTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '₹ 87.85',
                      style: TextStyle(
                        color: CryptoTheme.textPrimary,
                        fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '-0.02%',
                    style: TextStyle(
                      color: CryptoTheme.redColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFrameSelector() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeFrameButton('1D'),
          _buildTimeFrameButton('7D'),
          _buildTimeFrameButton('1M'),
          _buildTimeFrameButton('3M'),
          _buildTimeFrameButton('1Y'),
        ],
      ),
    );
  }

  Widget _buildTimeFrameButton(String timeframe) {
    bool isSelected = _selectedTimeframe == timeframe;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeframe = timeframe),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CryptoTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          timeframe,
          style: TextStyle(
            color: isSelected ? CryptoTheme.textPrimary : CryptoTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: MediaQuery.of(context).size.width < 600 ? 200 : 280,
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ChartGridPainter(),
            ),
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.width < 600 ? 80 : 120,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CryptoTheme.yellowColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '87.846',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('104', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                SizedBox(height: MediaQuery.of(context).size.width < 600 ? 12 : 24),
                Text('100', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                SizedBox(height: MediaQuery.of(context).size.width < 600 ? 12 : 24),
                Text('96.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                if (MediaQuery.of(context).size.width >= 600) ...[
                  SizedBox(height: 24),
                  Text('92.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 24),
                  Text('84.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 24),
                  Text('80.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 24),
                  Text('76.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 24),
                  Text('72.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 24),
                  Text('68.000', style: TextStyle(color: CryptoTheme.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 80,
            top: MediaQuery.of(context).size.width < 600 ? 84 : 124,
            child: Container(
              height: 2,
              color: CryptoTheme.yellowColor,
            ),
          ),
          Positioned(
            right: 12,
            top: 50,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'INR',
                style: TextStyle(
                  color: CryptoTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStatsGrid() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Column(
      children: [
        isMobile ? 
          Column(
            children: [
              _buildMarketStatCard('Popularity', '#4', hasInfoIcon: true),
              SizedBox(height: 16),
              _buildMarketStatCard('Market Cap', '₹14,688.93B', hasInfoIcon: true),
              SizedBox(height: 16),
              _buildMarketStatCard('Volume', '₹11,348.28B', hasInfoIcon: true),
              SizedBox(height: 16),
              _buildMarketStatCard('Circulation Supply', '167.21B', hasInfoIcon: true),
            ],
          ) :
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildMarketStatCard(
                      'Popularity',
                      '#4',
                      hasInfoIcon: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildMarketStatCard(
                      'Market Cap',
                      '₹14,688.93B',
                      hasInfoIcon: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMarketStatCard(
                      'Volume',
                      '₹11,348.28B',
                      hasInfoIcon: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildMarketStatCard(
                      'Circulation Supply',
                      '167.21B',
                      hasInfoIcon: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMarketStatCard(String title, String value, {bool hasInfoIcon = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: CryptoTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (hasInfoIcon) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  color: CryptoTheme.textSecondary,
                  size: 14,
                ),
              ],
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketDescription() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Tether USDt is experiencing a rise in value this week. Currently, Tether USDt is priced at ₹87.85 per USDt, with a circulating supply of 167.21B USDt, resulting in a total market capitalisation of ₹14,688.93B.\n\nOver the past 24 hours, the trading volume for Tether USDt has increased by ₹-222,803,144,525,288.09, representing a -19.6332% rise. Moreover, USDt worth ₹11,348.28B has been traded in the last day.',
        style: TextStyle(
          color: CryptoTheme.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildExchangeRateCards() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return isMobile ? 
      Column(
        children: [
          _buildExchangeRateCard('7 days exchange rate', '+0.03%', isPositive: true),
          SizedBox(height: 16),
          _buildExchangeRateCard('24-hour exchange rate', '-0.02%', isPositive: false),
        ],
      ) :
      Row(
        children: [
          Expanded(
            child: _buildExchangeRateCard(
              '7 days exchange rate',
              '+0.03%',
              isPositive: true,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildExchangeRateCard(
              '24-hour exchange rate',
              '-0.02%',
              isPositive: false,
            ),
          ),
        ],
      );
  }

  Widget _buildExchangeRateCard(String title, String percentage, {required bool isPositive}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            percentage,
            style: TextStyle(
              color: isPositive ? CryptoTheme.greenColor : CryptoTheme.redColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedConversionTables() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return isMobile ?
      Column(
        children: [
          _buildConversionTableDetailed(
            'USDT to INR',
            [
              {'amount': '0.5 USDT', 'converted': '43.92 INR'},
              {'amount': '1 USDT', 'converted': '87.83 INR'},
              {'amount': '5 USDT', 'converted': '439.17 INR'},
              {'amount': '10 USDT', 'converted': '878.35 INR'},
              {'amount': '50 USDT', 'converted': '4,391.74 INR'},
              {'amount': '100 USDT', 'converted': '8,783.49 INR'},
              {'amount': '500 USDT', 'converted': '43,917.45 INR'},
              {'amount': '1000 USDT', 'converted': '87,834.89 INR'},
            ],
          ),
          SizedBox(height: 24),
          _buildConversionTableDetailed(
            'INR to USDT',
            [
              {'amount': '0.5 INR', 'converted': '0.0056925 USDT'},
              {'amount': '1 INR', 'converted': '0.011385 USDT'},
              {'amount': '5 INR', 'converted': '0.056925 USDT'},
              {'amount': '10 INR', 'converted': '0.11385 USDT'},
              {'amount': '50 INR', 'converted': '0.5692498 USDT'},
              {'amount': '100 INR', 'converted': '1.1384997 USDT'},
              {'amount': '500 INR', 'converted': '5.6924985 USDT'},
              {'amount': '1000 INR', 'converted': '11.38 USDT'},
            ],
          ),
        ],
      ) :
      Row(
        children: [
          Expanded(
            child: _buildConversionTableDetailed(
              'USDT to INR',
              [
                {'amount': '0.5 USDT', 'converted': '43.92 INR'},
                {'amount': '1 USDT', 'converted': '87.83 INR'},
                {'amount': '5 USDT', 'converted': '439.17 INR'},
                {'amount': '10 USDT', 'converted': '878.35 INR'},
                {'amount': '50 USDT', 'converted': '4,391.74 INR'},
                {'amount': '100 USDT', 'converted': '8,783.49 INR'},
                {'amount': '500 USDT', 'converted': '43,917.45 INR'},
                {'amount': '1000 USDT', 'converted': '87,834.89 INR'},
              ],
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: _buildConversionTableDetailed(
              'INR to USDT',
              [
                {'amount': '0.5 INR', 'converted': '0.0056925 USDT'},
                {'amount': '1 INR', 'converted': '0.011385 USDT'},
                {'amount': '5 INR', 'converted': '0.056925 USDT'},
                {'amount': '10 INR', 'converted': '0.11385 USDT'},
                {'amount': '50 INR', 'converted': '0.5692498 USDT'},
                {'amount': '100 INR', 'converted': '1.1384997 USDT'},
                {'amount': '500 INR', 'converted': '5.6924985 USDT'},
                {'amount': '1000 INR', 'converted': '11.38 USDT'},
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildConversionTableDetailed(String title, List<Map<String, String>> conversions) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF2A2F3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          ...conversions.map((conversion) => Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    conversion['amount']!,
                    style: TextStyle(
                      color: CryptoTheme.textSecondary,
                      fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    conversion['converted']!,
                    style: TextStyle(
                      color: CryptoTheme.textPrimary,
                      fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPopularConversionsSection() {
    final horizontalPadding = _getHorizontalPadding(context);
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Tether USDt Conversions',
            style: TextStyle(
              color: CryptoTheme.textPrimary,
              fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'A selection of other popular currency conversions of Tether USDt to various fiat currencies.',
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          SizedBox(height: 40),
          isMobile ? 
            _buildMobileConversionGrid() : 
            _buildDesktopConversionGrid(),
          SizedBox(height: 60),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: CryptoTheme.textSecondary,
                fontSize: 14,
              ),
              children: [
                TextSpan(text: 'This site is protected by reCAPTCHA and the Google '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: CryptoTheme.yellowColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: CryptoTheme.yellowColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' apply.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileConversionGrid() {
    return Column(
      children: [
        _buildCurrencyConversionCard('USDT to USD', '1 USDT = 0.9999948 USD', CryptoTheme.greenColor, Color(0xFFFFD700)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to TRY', '1 USDT = 41.03 TRY', CryptoTheme.greenColor, Color(0xFFE91E63)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to RUB', '1 USDT = 80.45 RUB', CryptoTheme.greenColor, Color(0xFF757575)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to EUR', '1 USDT = 0.8629955 EUR', CryptoTheme.greenColor, Color(0xFF1976D2)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to SAR', '1 USDT = 3.7499805 SAR', CryptoTheme.greenColor, Color(0xFF4CAF50)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to AUD', '1 USDT = 1.5499919 AUD', CryptoTheme.greenColor, Color(0xFF2196F3)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to BRL', '1 USDT = 5.4399717 BRL', CryptoTheme.greenColor, Color(0xFF4CAF50)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to VND', '1 USDT = 26,351.82 VND', CryptoTheme.greenColor, Color(0xFFE91E63)),
        SizedBox(height: 20),
        _buildCurrencyConversionCard('USDT to INR', '1 USDT = 87.85 INR', CryptoTheme.greenColor, CryptoTheme.yellowColor),
      ],
    );
  }

  Widget _buildDesktopConversionGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to USD',
                '1 USDT = 0.9999948 USD',
                CryptoTheme.greenColor,
                Color(0xFFFFD700),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to TRY',
                '1 USDT = 41.03 TRY',
                CryptoTheme.greenColor,
                Color(0xFFE91E63),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to RUB',
                '1 USDT = 80.45 RUB',
                CryptoTheme.greenColor,
                Color(0xFF757575),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to EUR',
                '1 USDT = 0.8629955 EUR',
                CryptoTheme.greenColor,
                Color(0xFF1976D2),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to SAR',
                '1 USDT = 3.7499805 SAR',
                CryptoTheme.greenColor,
                Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to AUD',
                '1 USDT = 1.5499919 AUD',
                CryptoTheme.greenColor,
                Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to BRL',
                '1 USDT = 5.4399717 BRL',
                CryptoTheme.greenColor,
                Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to VND',
                '1 USDT = 26,351.82 VND',
                CryptoTheme.greenColor,
                Color(0xFFE91E63),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildCurrencyConversionCard(
                'USDT to INR',
                '1 USDT = 87.85 INR',
                CryptoTheme.greenColor,
                CryptoTheme.yellowColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyConversionCard(String title, String conversion, Color leftIconColor, Color rightIconColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CryptoTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2A2F3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: CryptoTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: leftIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'T',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: rightIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getCurrencySymbol(title),
                        style: TextStyle(
                          color: rightIconColor == CryptoTheme.yellowColor ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            conversion,
            style: TextStyle(
              color: CryptoTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String title) {
  if (title.contains('USD')) return '€' ;
  if (title.contains('TRY')) return '₺';
  if (title.contains('RUB')) return '₽';
  if (title.contains('EUR')) return '€';
  if (title.contains('SAR')) return '﷼';
  if (title.contains('AUD')) return '€' ;
  if (title.contains('BRL')) return '€' ;
  if (title.contains('VND')) return '₫';
  if (title.contains('INR')) return '₹';
  return '€' ; // Default fallback
}

  Widget _buildCryptoRow(String symbol, String iconPath, String price, String change) {
    Color changeColor = change.startsWith('+') ? CryptoTheme.greenColor : Colors.red;
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getCryptoColor(symbol),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getCryptoIcon(symbol),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          symbol,
          style: TextStyle(
            color: CryptoTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: TextStyle(
                color: CryptoTheme.textPrimary,
                fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              change,
              style: TextStyle(
                color: changeColor,
                fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCryptoColor(String symbol) {
    switch (symbol) {
      case 'BNB':
        return CryptoTheme.yellowColor;
      case 'BTC':
        return Color(0xFFF7931A);
      case 'ETH':
        return Color(0xFF627EEA);
      default:
        return CryptoTheme.primaryColor;
    }
  }

  String _getCryptoIcon(String symbol) {
    switch (symbol) {
      case 'BNB':
        return 'B';
      case 'BTC':
        return '₿';
      case 'ETH':
        return 'Ξ';
      default:
        return symbol[0];
    }
  }
}

class ChartGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF2A2F3A)
      ..strokeWidth = 1;

    for (int i = 1; i < 10; i++) {
      double y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 80, y),
        paint,
      );
    }

    for (int i = 1; i < 8; i++) {
      double x = 20 + ((size.width - 100) / 8) * i;
      canvas.drawLine(
        Offset(x, 20),
        Offset(x, size.height - 20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}