import 'package:flutter/material.dart';

class RecurringBuyScreen extends StatefulWidget {
  @override
  _RecurringBuyScreenState createState() => _RecurringBuyScreenState();
}

class _RecurringBuyScreenState extends State<RecurringBuyScreen> {
  String fromAsset = 'INR';
  String toAsset = 'USDT';
  String amount = '1,500 - 100,000';
  String selectedPeriod = '3Y';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(55.0), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Create Recurring Plan + Top Cryptos (responsive)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    // Desktop/tablet layout
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildRecurringBuySection(),
                        ),
                        SizedBox(width: 48),
                        Expanded(
                          flex: 1,
                          child: _buildTopCryptosSection(),
                        ),
                      ],
                    );
                  } else {
                    // Mobile layout - stack vertically
                    return Column(
                      children: [
                        _buildRecurringBuySection(),
                        SizedBox(height: 32),
                        _buildTopCryptosSection(),
                      ],
                    );
                  }
                },
              ),
              
              SizedBox(height: 64),
              
              // Section 2: How does dollar-cost averaging (DCA) work?
              _buildDCAExplanationSection(),
              
              SizedBox(height: 64),
              
              // Section 3: Benefits of DCA via Recurring Buy
              _buildBenefitsSection(),
              
              SizedBox(height: 64),
              
              // Section 4: Risks of DCA via Recurring Buy
              _buildRisksSection(),
              
              SizedBox(height: 64),
              
              // Section 5: Getting started
              _buildGettingStartedSection(),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCryptosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              'Top Cryptos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.info_outline,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
        
        SizedBox(height: 24),
        
        // Time period selector - responsive
        LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setting time',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTimeButton('3Y', true),
                    _buildTimeButton('1Y', false),
                    _buildTimeButton('6M', false),
                    _buildTimeButton('3M', false),
                  ],
                ),
              ],
            );
          },
        ),
        
        SizedBox(height: 32),
        
        // Crypto list
        Column(
          children: [
            _buildCryptoItem('BTC', 'Bitcoin', '₹ 1384063.56', '184.00%', Colors.orange),
            SizedBox(height: 16),
            _buildCryptoItem('ETH', 'Ethereum', '₹ 42649.5', '108.00%', Colors.blue),
            SizedBox(height: 16),
            _buildCryptoItem('BNB', 'BNB', '₹ 2133.46', '125.00%', Colors.yellow),
            SizedBox(height: 16),
            _buildCryptoItem('ADA', 'Cardano', '', '95.00%', Colors.blue),
            SizedBox(height: 16),
            _buildCryptoItem('XRP', 'XRP', '₹ 41.99', '360.00%', Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildRecurringBuySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - responsive wrap for mobile
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Row(
                children: [
                  Text(
                    'Create Recurring Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A4A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Auto-Invest with stablecoin >',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Recurring Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A4A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Auto-Invest with stablecoin >',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
        
        SizedBox(height: 32),
        
        // Select Assets
        Text(
          'Select Assets',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        SizedBox(height: 16),
        
        // Asset selection - responsive
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Row(
                children: [
                  Expanded(child: _buildAssetSelector(fromAsset, '₹', const Color.fromARGB(255, 122, 79, 223))),
                  SizedBox(width: 16),
                  Text('To', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  SizedBox(width: 16),
                  Expanded(child: _buildAssetSelector(toAsset, 'U', Colors.teal)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildAssetSelector(fromAsset, '₹', const Color.fromARGB(255, 122, 79, 223)),
                  SizedBox(height: 16),
                  Center(
                    child: Text('To', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  ),
                  SizedBox(height: 16),
                  _buildAssetSelector(toAsset, 'U', Colors.teal),
                ],
              );
            }
          },
        ),
        
        SizedBox(height: 32),
        
        // Amount
        Text(
          'Amount',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        SizedBox(height: 16),
        
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                'INR',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 32),
        
        // Repeat
        Text(
          'Repeat',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        SizedBox(height: 16),
        
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly, Sunday, 11:00 (UTC+5)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            ],
          ),
        ),
        
        SizedBox(height: 32),
        
        // You receive
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'You receive ',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: '0 USDT',
                style: TextStyle(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 32),
        
        // Continue Button
        Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 122, 79, 223),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetSelector(String asset, String iconText, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iconText,
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
            asset,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _buildDCAExplanationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main heading
        Text(
          'How does dollar-cost averaging (DCA) work?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Responsive layout
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDCATextContent(),
                  ),
                  SizedBox(width: 48),
                  Expanded(
                    flex: 1,
                    child: _buildDCAExampleCards(),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDCATextContent(),
                  SizedBox(height: 32),
                  _buildDCAExampleCards(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDCATextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is DCA?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 12),
        
        Text(
          'DCA is an investment strategy where an investor invests fixed amounts at regular intervals to reduce the influence of volatility over their investment.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        
        SizedBox(height: 32),
        
        Text(
          'How do I calculate the DCA amount for my crypto investments?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 12),
        
        Text(
          'DCA amount = Total cost / Total no. of shares',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDCAExampleCards() {
    return Column(
      children: [
        // Last week card
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last week',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'BNB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$200',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Container(
                height: 1,
                child: Row(
                  children: List.generate(20, (index) => 
                    Expanded(
                      child: Container(
                        height: 1,
                        color: index % 2 == 0 ? Colors.white24 : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$2,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // Plus sign
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF3A3A3A),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white54,
            size: 20,
          ),
        ),
        
        SizedBox(height: 16),
        
        // After a month card
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'After a month',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'BNB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$400',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Container(
                height: 1,
                child: Row(
                  children: List.generate(20, (index) => 
                    Expanded(
                      child: Container(
                        height: 1,
                        color: index % 2 == 0 ? Colors.white24 : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$4,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 24),
        
        // Summary section
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$6,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Total BNB Amount',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '20',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Text(
                    'Average Cost',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: Text(
                      '\$6,000 ÷ 20 = \$300/token',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Benefits of DCA section
        Text(
          'Benefits of DCA via Recurring Buy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Benefits grid - responsive
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 900 ? 3 : 
                                 constraints.maxWidth > 600 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: crossAxisCount == 1 ? 2.0 : 1.2,
              children: [
                _buildBenefitCard(
                  icon: Icons.eco,
                  title: 'Steady Portfolio Growth',
                  description: 'Consistent investments at periodic intervals gradually grows your crypto wealth over time and reap the gains of invested projects\' growth.',
                ),
                _buildBenefitCard(
                  icon: Icons.star,
                  title: 'Disciplined Saving',
                  description: 'Automates your crypto purchases and ensures you invest with discipline regardless of market conditions.',
                ),
                _buildBenefitCard(
                  icon: Icons.shield,
                  title: 'Risk Reduction',
                  description: 'Manages impact from the volatile crypto market by spreading out your investments and smoothing out price swings.',
                ),
                _buildBenefitCard(
                  icon: Icons.schedule,
                  title: 'Convenience & Flexibility',
                  description: 'Choose between weekly, bi-weekly or even monthly purchases and cryptocurrencies you want to buy beforehand.',
                ),
                _buildBenefitCard(
                  icon: Icons.group_work,
                  title: 'Easy Access to Binance Ecosystem',
                  description: 'Get your stash of crypto ready to explore other Binance products such as staking, spot trading, or even buying your first NFT.',
                ),
                _buildBenefitCard(
                  icon: Icons.favorite,
                  title: 'Emotional Detachment',
                  description: 'Remove the stress of timing the market and making impulsive decisions based on market conditions.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRisksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Risks of DCA section
        Text(
          'Risks of DCA via Recurring Buy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Missing Out on Large Gains
        Text(
          'Missing Out on Large Gains',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 12),
        
        Text(
          'DCA does not include lump sum investments during market dips, thus you may miss out on a larger profit.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Crypto Facts
        Text(
          'Crypto Facts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 12),
        
        Text(
          'Such large gains require investors to time the market correctly which is almost impossible, which is why DCA can help smooth out market timings.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Lack of Detailed Investment Information
        Text(
          'Lack of Detailed Investment Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 12),
        
        Text(
          'DCA strategy does not help identify good investments. Hence, it\'s important to DYOR before committing to a DCA approach.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGettingStartedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Getting started section
        Text(
          'Getting started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 32),
        
        // Getting started steps - responsive grid
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Desktop/tablet layout - 2 columns
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStepCard(
                          icon: Icons.credit_card,
                          title: 'Select debit/credit card',
                          description: 'Log in to your Binance account and tap on the [Credit/Debit Card] option on the app homepage or top header on the website.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStepCard(
                          icon: Icons.monetization_on,
                          title: 'Select crypto and enable Recurring Buy',
                          description: 'Next, choose your crypto to purchase and enable the Recurring Buy feature on the same page.',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStepCard(
                          icon: Icons.folder,
                          title: 'Select your fiat currency',
                          description: 'Choose from over 40+ fiat currencies and pick your preferred local currency.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStepCard(
                          icon: Icons.schedule,
                          title: 'Set up the frequency',
                          description: 'Choose between weekly, bi-weekly or monthly. You can also select the day and time for your Recurring Buy.',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStepCard(
                          icon: Icons.add_card,
                          title: 'Select your payment methods',
                          description: 'We currently accept Visa or Mastercard payments. You can choose to use one of your existing cards or add a new card.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(child: Container()), // Empty space to maintain alignment
                    ],
                  ),
                ],
              );
            } else {
              // Mobile layout - single column
              return Column(
                children: [
                  _buildStepCard(
                    icon: Icons.credit_card,
                    title: 'Select debit/credit card',
                    description: 'Log in to your Binance account and tap on the [Credit/Debit Card] option on the app homepage or top header on the website.',
                  ),
                  SizedBox(height: 16),
                  _buildStepCard(
                    icon: Icons.monetization_on,
                    title: 'Select crypto and enable Recurring Buy',
                    description: 'Next, choose your crypto to purchase and enable the Recurring Buy feature on the same page.',
                  ),
                  SizedBox(height: 16),
                  _buildStepCard(
                    icon: Icons.folder,
                    title: 'Select your fiat currency',
                    description: 'Choose from over 40+ fiat currencies and pick your preferred local currency.',
                  ),
                  SizedBox(height: 16),
                  _buildStepCard(
                    icon: Icons.schedule,
                    title: 'Set up the frequency',
                    description: 'Choose between weekly, bi-weekly or monthly. You can also select the day and time for your Recurring Buy.',
                  ),
                  SizedBox(height: 16),
                  _buildStepCard(
                    icon: Icons.add_card,
                    title: 'Select your payment methods',
                    description: 'We currently accept Visa or Mastercard payments. You can choose to use one of your existing cards or add a new card.',
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 28,
            ),
          ),
          
          SizedBox(height: 20),
          
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 12),
          
          Text(
            description,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
          ),
          
          SizedBox(height: 16),
          
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 8),
          
          Text(
            description,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeButton(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildCryptoItem(String symbol, String name, String price, String roi, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                symbol == 'BTC' ? '₿' : 
                symbol == 'ETH' ? 'Ξ' :
                symbol == 'BNB' ? 'B' :
                symbol == 'ADA' ? 'A' :
                'X',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Name and symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'HistoricalROI',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Price and ROI
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (price.isNotEmpty)
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                roi,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}