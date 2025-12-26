import 'package:flutter/material.dart';

class SimpleEarnScreen extends StatefulWidget {
  @override
  _SimpleEarnScreenState createState() => _SimpleEarnScreenState();
}

class _SimpleEarnScreenState extends State<SimpleEarnScreen> {
  bool showAllProducts = false;
  Map<String, bool> expandedRows = {};

  // Initial products shown (first 6 items)
  final List<EarnProduct> initialProducts = [
    EarnProduct(
      coin: 'SOMI',
      coinIcon: 'S',
      apr: '0%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFF7B61D3),
    ),
    EarnProduct(
      coin: 'USDC',
      coinIcon: 'U',
      apr: '3.58% ~ 11.85%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFF2775CA),
      subProducts: [
        SubEarnProduct(apr: '11.85%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '3.58%', duration: '30', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'USDT',
      coinIcon: 'U',
      apr: '4.2% ~ 28.04%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFF26A17B),
      subProducts: [
        SubEarnProduct(apr: '28.04%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '4.2%', duration: '7', label: 'Fixed Rate Supply'),
        SubEarnProduct(apr: '5.1%', duration: '14', label: 'Fixed Rate Supply'),
        SubEarnProduct(apr: '6.8%', duration: '30', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'BTC',
      coinIcon: '₿',
      apr: '1.2%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFFF7931A),
    ),
    EarnProduct(
      coin: 'ETH',
      coinIcon: 'E',
      apr: '2.5% ~ 8.9%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFF627EEA),
      subProducts: [
        SubEarnProduct(apr: '8.9%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '2.5%', duration: '15', label: 'Fixed Rate Supply'),
        SubEarnProduct(apr: '3.2%', duration: '30', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'BNB',
      coinIcon: 'B',
      apr: '1.8%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFFF0B90B),
    ),
  ];

  // Additional products shown after "View More"
  final List<EarnProduct> additionalProducts = [
    EarnProduct(
      coin: 'ADA',
      coinIcon: 'A',
      apr: '3.2% ~ 7.5%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFF0033AD),
      subProducts: [
        SubEarnProduct(apr: '7.5%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '3.2%', duration: '30', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'DOT',
      coinIcon: 'D',
      apr: '4.1%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFFE6007A),
    ),
    EarnProduct(
      coin: 'SOL',
      coinIcon: 'S',
      apr: '2.8% ~ 9.2%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFF9945FF),
      subProducts: [
        SubEarnProduct(apr: '9.2%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '2.8%', duration: '7', label: 'Fixed Rate Supply'),
        SubEarnProduct(apr: '3.5%', duration: '14', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'MATIC',
      coinIcon: 'M',
      apr: '5.3%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFF8247E5),
    ),
    EarnProduct(
      coin: 'AVAX',
      coinIcon: 'A',
      apr: '3.7% ~ 12.1%',
      duration: 'Flexible/Locked',
      hasMultipleOptions: true,
      iconColor: Color(0xFFE84142),
      subProducts: [
        SubEarnProduct(apr: '12.1%', duration: 'Flexible', label: 'Max'),
        SubEarnProduct(apr: '3.7%', duration: '30', label: 'Fixed Rate Supply'),
      ],
    ),
    EarnProduct(
      coin: 'DOGE',
      coinIcon: 'D',
      apr: '2.1%',
      duration: 'Flexible',
      hasMultipleOptions: false,
      iconColor: Color(0xFFC2A633),
    ),
  ];

  List<EarnProduct> get displayedProducts {
    if (showAllProducts) {
      return [...initialProducts, ...additionalProducts];
    }
    return initialProducts;
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 768;
  bool get _isTablet => MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2329),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: _isDesktop ? 28 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: _isDesktop ? 28 : 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white, size: _isDesktop ? 28 : 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            
            // Table Section
            _buildTable(),
            
            // Learn More Section (Always visible after table)
            _buildLearnMoreSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(_isDesktop ? 55 : (_isTablet ? 24 : 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Principal-protected Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: _isDesktop ? 32 : (_isTablet ? 30 : 24),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: _isDesktop ? 12 : 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Earn rewards on principal-protected products.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: _isDesktop ? 18 : (_isTablet ? 17 : 16),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.info_outline,
                color: Colors.grey[400],
                size: _isDesktop ? 20 : 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    if (_isMobile) {
      return _buildMobileProductsList();
    } else {
      return _buildDesktopTable();
    }
  }

  Widget _buildMobileProductsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...displayedProducts.map((product) => _buildMobileProductCard(product)),
          if (!showAllProducts) _buildViewMoreButton(),
        ],
      ),
    );
  }

  Widget _buildMobileProductCard(EarnProduct product) {
    bool isExpanded = expandedRows[product.coin] ?? false;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (product.hasMultipleOptions) {
                setState(() {
                  expandedRows[product.coin] = !isExpanded;
                });
              } else {
                _showSubscribeDialog(product);
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: product.iconColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            product.coinIcon,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.coin,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.duration,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product.apr,
                            style: TextStyle(
                              color: product.apr == '0%' ? Colors.grey[400] : Color(0xFF0ECB81),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'APR',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Icon(
                        product.hasMultipleOptions 
                          ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                          : Icons.keyboard_arrow_right,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Sub-products
          if (isExpanded && product.subProducts != null)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF404040), width: 0.5)),
              ),
              child: Column(
                children: product.subProducts!.map((subProduct) => 
                  _buildMobileSubProductRow(subProduct, product)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileSubProductRow(SubEarnProduct subProduct, EarnProduct parentProduct) {
    return GestureDetector(
      onTap: () => _showSubscribeDialog(parentProduct, subProduct: subProduct),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF404040), width: 0.3)),
        ),
        child: Row(
          children: [
            SizedBox(width: 52), // Space for alignment
            Expanded(
              child: Row(
                children: [
                  Text(
                    subProduct.apr,
                    style: TextStyle(
                      color: Color(0xFF0ECB81),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (subProduct.label != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: subProduct.label == 'Max' ? Color(0xFFF0B90B) : Color(0xFF404040),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        subProduct.label!,
                        style: TextStyle(
                          color: subProduct.label == 'Max' ? Colors.black : Colors.grey[300],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${subProduct.duration} Days',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _isDesktop ? 32 : 24),
      decoration: BoxDecoration(
        color: Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...displayedProducts.map((product) => _buildProductRow(product)),
          if (!showAllProducts) _buildViewMoreButton(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isDesktop ? 32 : 20, 
        vertical: _isDesktop ? 20 : 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF404040), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Coin',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: _isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  'APR',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: _isDesktop ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: _isDesktop ? 18 : 16,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Duration(Days)',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: _isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(EarnProduct product) {
    bool isExpanded = expandedRows[product.coin] ?? false;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (product.hasMultipleOptions) {
              setState(() {
                expandedRows[product.coin] = !isExpanded;
              });
            } else {
              _showSubscribeDialog(product);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isDesktop ? 32 : 20, 
              vertical: _isDesktop ? 20 : 16,
            ),
            decoration: BoxDecoration(
              color: isExpanded ? Color(0xFF2B3139) : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF404040), 
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                // Coin Column
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: _isDesktop ? 40 : 32,
                        height: _isDesktop ? 40 : 32,
                        decoration: BoxDecoration(
                          color: product.iconColor,
                          borderRadius: BorderRadius.circular(_isDesktop ? 20 : 16),
                        ),
                        child: Center(
                          child: Text(
                            product.coinIcon,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isDesktop ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: _isDesktop ? 16 : 12),
                      Text(
                        product.coin,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // APR Column
                Expanded(
                  flex: 3,
                  child: Text(
                    product.apr,
                    style: TextStyle(
                      color: product.apr == '0%' ? Colors.grey[400] : Color(0xFF0ECB81),
                      fontSize: _isDesktop ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Duration Column with Arrow
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Text(
                        product.duration,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isDesktop ? 18 : 16,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        product.hasMultipleOptions 
                          ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                          : Icons.keyboard_arrow_right,
                        color: Colors.grey[400],
                        size: _isDesktop ? 24 : 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Expanded Sub-products
        if (isExpanded && product.subProducts != null)
          ...product.subProducts!.map((subProduct) => _buildSubProductRow(subProduct, product)),
      ],
    );
  }

  Widget _buildSubProductRow(SubEarnProduct subProduct, EarnProduct parentProduct) {
    return GestureDetector(
      onTap: () => _showSubscribeDialog(parentProduct, subProduct: subProduct),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _isDesktop ? 32 : 20, 
          vertical: _isDesktop ? 16 : 12,
        ),
        margin: EdgeInsets.only(left: _isDesktop ? 56 : 44),
        decoration: BoxDecoration(
          color: Color(0xFF2B3139),
          border: Border(
            bottom: BorderSide(color: Color(0xFF404040), width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(), // Empty space for alignment
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    subProduct.apr,
                    style: TextStyle(
                      color: Color(0xFF0ECB81),
                      fontSize: _isDesktop ? 16 : 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (subProduct.label != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: subProduct.label == 'Max' ? Color(0xFFF0B90B) : Color(0xFF404040),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        subProduct.label!,
                        style: TextStyle(
                          color: subProduct.label == 'Max' ? Colors.black : Colors.grey[300],
                          fontSize: _isDesktop ? 11 : 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Text(
                    subProduct.duration,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _isDesktop ? 16 : 15,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey[400],
                    size: _isDesktop ? 20 : 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMoreButton() {
    return Container(
      padding: EdgeInsets.all(_isDesktop ? 32 : 20),
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              showAllProducts = true;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isDesktop ? 32 : 24, 
              vertical: _isDesktop ? 16 : 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 122, 79, 223)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View More',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: _isDesktop ? 18 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: _isDesktop ? 12 : 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 122, 79, 223),
                  size: _isDesktop ? 24 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLearnMoreSection() {
    final padding = _isDesktop ? 32.0 : (_isTablet ? 24.0 : 16.0);
    
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learn More',
            style: TextStyle(
              color: Colors.white,
              fontSize: _isDesktop ? 28 : (_isTablet ? 26 : 24),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: _isDesktop ? 40 : 32),
          _isMobile 
            ? _buildMobileLearnMoreCards()
            : _buildDesktopLearnMoreCards(),
          SizedBox(height: _isDesktop ? 32 : 20),
        ],
      ),
    );
  }

  Widget _buildMobileLearnMoreCards() {
    final cards = [
      {
        'icon': Icons.schedule,
        'title': 'Flexible Products',
        'description': 'Subscribe at any time and start earning rewards.',
        'features': ['Redemption Policy', 'Flexible Loans', 'Real-Time APR', 'Bonus Tiered APR'],
      },
      {
        'icon': Icons.lock,
        'title': 'Locked Products',
        'description': 'Lock assets for a fixed term and earn higher rewards',
        'features': ['Rewards Distribution Timeline', 'Daily Maintenance Schedule', 'Redemption Policy'],
      },
      {
        'icon': Icons.pool,
        'title': 'Launchpool & Megadrop Rewards',
        'description': 'Eligible Simple Earn users will automatically participate in Launchpool (applies to both Flexible and Locked BNB) and Megadrop (only applicable to Locked BNB) for rewards.',
        'features': ['Historical Rewards', 'Megadrop FAQ', 'Launchpool FAQ'],
      },
      {
        'icon': Icons.autorenew,
        'title': 'Auto-Subscribe',
        'description': 'Hassle-free automatic subscription for Flexible or Locked.',
        'features': ['Flexible Products', 'Locked Products'],
      },
    ];

    return Column(
      children: cards.map((card) => Container(
        margin: EdgeInsets.only(bottom: 16),
        child: _buildLearnMoreCard(
          icon: card['icon'] as IconData,
          title: card['title'] as String,
          description: card['description'] as String,
          features: card['features'] as List<String>,
        ),
      )).toList(),
    );
  }

  Widget _buildDesktopLearnMoreCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLearnMoreCard(
                icon: Icons.schedule,
                title: 'Flexible Products',
                description: 'Subscribe at any time and start earning rewards.',
                features: [
                  'Redemption Policy',
                  'Flexible Loans',
                  'Real-Time APR',
                  'Bonus Tiered APR',
                ],
              ),
            ),
            SizedBox(width: _isDesktop ? 24 : 16),
            Expanded(
              child: _buildLearnMoreCard(
                icon: Icons.lock,
                title: 'Locked Products',
                description: 'Lock assets for a fixed term and earn higher rewards',
                features: [
                  'Rewards Distribution Timeline',
                  'Daily Maintenance Schedule',
                  'Redemption Policy',
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: _isDesktop ? 24 : 16),
        Row(
          children: [
            Expanded(
              child: _buildLearnMoreCard(
                icon: Icons.pool,
                title: 'Launchpool & Megadrop Rewards',
                description: 'Eligible Simple Earn users will automatically participate in Launchpool (applies to both Flexible and Locked BNB) and Megadrop (only applicable to Locked BNB) for rewards.',
                features: [
                  'Historical Rewards',
                  'Megadrop FAQ',
                  'Launchpool FAQ',
                ],
              ),
            ),
            SizedBox(width: _isDesktop ? 24 : 16),
            Expanded(
              child: _buildLearnMoreCard(
                icon: Icons.autorenew,
                title: 'Auto-Subscribe',
                description: 'Hassle-free automatic subscription for Flexible or Locked.',
                features: [
                  'Flexible Products',
                  'Locked Products',
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearnMoreCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
  }) {
    return Container(
      padding: EdgeInsets.all(_isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _isDesktop ? 56 : 48,
            height: _isDesktop ? 56 : 48,
            decoration: BoxDecoration(
              color: Color(0xFF1E2329),
              borderRadius: BorderRadius.circular(_isDesktop ? 28 : 24),
            ),
            child: Icon(
              icon,
              color: Color.fromARGB(255, 122, 79, 223),
              size: _isDesktop ? 28 : 24,
            ),
          ),
          SizedBox(height: _isDesktop ? 20 : 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: _isDesktop ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: _isDesktop ? 12 : 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: _isDesktop ? 15 : 13,
              height: 1.4,
            ),
          ),
          SizedBox(height: _isDesktop ? 20 : 16),
          ...features.map((feature) => Padding(
            padding: EdgeInsets.only(bottom: _isDesktop ? 10 : 8),
            child: Row(
              children: [
                Container(
                  width: _isDesktop ? 5 : 4,
                  height: _isDesktop ? 5 : 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(_isDesktop ? 2.5 : 2),
                  ),
                ),
                SizedBox(width: _isDesktop ? 10 : 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: _isDesktop ? 14 : 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _showSubscribeDialog(EarnProduct product, {SubEarnProduct? subProduct}) {
    String displayApr = subProduct?.apr ?? product.apr.split(' ')[0];
    String displayDuration = subProduct?.duration ?? 'Flexible';
    
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF2B3139),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: _isMobile 
                ? MediaQuery.of(context).size.width * 0.9
                : MediaQuery.of(context).size.width * 0.5,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              maxWidth: _isDesktop ? 600 : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(
                    _isDesktop ? 32 : 20, 
                    _isDesktop ? 32 : 20, 
                    _isDesktop ? 32 : 20, 
                    _isDesktop ? 24 : 16
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _isDesktop ? 20 : 16, 
                          vertical: _isDesktop ? 10 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1E2329),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Subscribe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: _isDesktop ? 20 : 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _isDesktop ? 20 : 16, 
                          vertical: _isDesktop ? 10 : 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[600]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Product Rules',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: _isDesktop ? 16 : 14,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close, 
                          color: Colors.grey[400], 
                          size: _isDesktop ? 28 : 24,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: _isDesktop ? 32 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // APR Display Box
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: _isDesktop ? 32 : 24, 
                            horizontal: _isDesktop ? 32 : 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E2329),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[600]!, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text(
                                displayDuration,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: _isDesktop ? 14 : 12,
                                ),
                              ),
                              SizedBox(height: _isDesktop ? 12 : 8),
                              Text(
                                displayApr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isDesktop ? 36 : 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: _isDesktop ? 32 : 24),
                        
                        // Amount Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _isDesktop ? 18 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Auto-Subscribe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _isDesktop ? 16 : 14,
                                  ),
                                ),
                                SizedBox(width: _isDesktop ? 12 : 8),
                                Transform.scale(
                                  scale: _isDesktop ? 1.0 : 0.8,
                                  child: Switch(
                                    value: false,
                                    onChanged: (value) {},
                                    activeColor: Color.fromARGB(255, 122, 79, 223),
                                    inactiveThumbColor: Colors.grey[400],
                                    inactiveTrackColor: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: _isDesktop ? 20 : 16),
                        
                        // Amount Input
                        Container(
                          padding: EdgeInsets.all(_isDesktop ? 20 : 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E2329),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[600]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isMobile 
                                ? _buildMobileAmountInput(product)
                                : _buildDesktopAmountInput(product),
                              SizedBox(height: _isDesktop ? 16 : 12),
                              Row(
                                children: [
                                  Text(
                                    'Avail (2 accounts) 0 ${product.coin}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: _isDesktop ? 14 : 12,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color.fromARGB(255, 122, 79, 223),
                                    size: _isDesktop ? 18 : 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Top up',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 122, 79, 223),
                                      fontSize: _isDesktop ? 14 : 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: _isDesktop ? 32 : 24),
                        
                        // Summary Section
                        Text(
                          'Summary',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isDesktop ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: _isDesktop ? 16 : 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Est. Daily Rewards',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: _isDesktop ? 16 : 14,
                              ),
                            ),
                            Text(
                              '-- ${product.coin}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: _isDesktop ? 16 : 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _isDesktop ? 20 : 16),
                        
                        // APR Disclaimer
                        Text(
                          '* APR does not represent actual or predicted returns in fiat currency. Please refer to the Product Rules for reward mechanisms.',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: _isDesktop ? 12 : 11,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: _isDesktop ? 24 : 20),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Section
                Container(
                  padding: EdgeInsets.all(_isDesktop ? 32 : 20),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[700]!, width: 1)),
                  ),
                  child: Column(
                    children: [
                      // Terms Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: _isDesktop ? 1.1 : 0.9,
                            child: Checkbox(
                              value: false,
                              onChanged: (value) {},
                              checkColor: Colors.black,
                              activeColor: Color.fromARGB(255, 122, 79, 223),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: _isDesktop ? 12 : 8),
                              child: RichText(
                                text: TextSpan(
                                  text: 'I have read and agreed to ',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: _isDesktop ? 15 : 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'BOCK De-Fi Simple Earn Service Terms & Conditions',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 122, 79, 223),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _isDesktop ? 20 : 16),
                      
                      // Confirm Button
                      Container(
                        width: double.infinity,
                        height: _isDesktop ? 52 : 44,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: _isDesktop ? 18 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileAmountInput(EarnProduct product) {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF2B3139),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Min 0.1 ${product.coin}',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFF2B3139),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.coin,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'MAX',
                style: TextStyle(
                  color: Color.fromARGB(255, 122, 79, 223),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopAmountInput(EarnProduct product) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: _isDesktop ? 48 : 40,
            decoration: BoxDecoration(
              color: Color(0xFF2B3139),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[600]!),
            ),
            child: TextField(
              style: TextStyle(
                color: Colors.white, 
                fontSize: _isDesktop ? 16 : 14,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: _isDesktop ? 16 : 12, 
                  vertical: _isDesktop ? 14 : 12,
                ),
                hintText: 'Min 0.1 ${product.coin}',
                hintStyle: TextStyle(
                  color: Colors.grey[500], 
                  fontSize: _isDesktop ? 14 : 12,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        SizedBox(width: _isDesktop ? 16 : 12),
        Container(
          height: _isDesktop ? 48 : 40,
          padding: EdgeInsets.symmetric(
            horizontal: _isDesktop ? 20 : 16, 
            vertical: _isDesktop ? 12 : 8,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF2B3139),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: Row(
            children: [
              Text(
                product.coin,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: _isDesktop ? 12 : 8),
              Text(
                'MAX',
                style: TextStyle(
                  color: Color.fromARGB(255, 122, 79, 223),
                  fontSize: _isDesktop ? 14 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Data Models
class EarnProduct {
  final String coin;
  final String coinIcon;
  final String apr;
  final String duration;
  final bool hasMultipleOptions;
  final Color iconColor;
  final List<SubEarnProduct>? subProducts;

  EarnProduct({
    required this.coin,
    required this.coinIcon,
    required this.apr,
    required this.duration,
    required this.hasMultipleOptions,
    required this.iconColor,
    this.subProducts,
  });
}

class SubEarnProduct {
  final String apr;
  final String duration;
  final String? label;

  SubEarnProduct({
    required this.apr,
    required this.duration,
    this.label,
  });
}