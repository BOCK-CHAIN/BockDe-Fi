import 'package:flutter/material.dart';

class DepositScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;
    
    // Responsive padding
    final horizontalPadding = isDesktop ? 55.0 : (isTablet ? 32.0 : 16.0);
    final topPadding = isDesktop ? 55.0 : (isTablet ? 40.0 : 24.0);
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deposit AED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 24 : (isTablet ? 28 : 32),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isMobile ? 32 : 48),
              
              // Main content section - responsive layout
              _buildMainContent(isMobile, isTablet, isDesktop),
              
              SizedBox(height: isMobile ? 48 : 80),
              
              // Why Binance section
              _buildWhyBinanceSection(isMobile, isTablet, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      // Mobile layout - stacked vertically with adjusted spacing
      return Column(
        children: [
          _buildDepositForm(isMobile, isTablet, isDesktop),
          SizedBox(height: 32),
          _buildFAQSection(isMobile, isTablet, isDesktop),
        ],
      );
    } else {
      // Desktop/tablet layout - side by side
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: _buildDepositForm(isMobile, isTablet, isDesktop),
          ),
          SizedBox(width: isDesktop ? 80 : 40),
          Expanded(
            flex: 1,
            child: _buildFAQSection(isMobile, isTablet, isDesktop),
          ),
        ],
      );
    }
  }

  Widget _buildDepositForm(bool isMobile, bool isTablet, bool isDesktop) {
    final containerPadding = isMobile ? 16.0 : 20.0;
    final buttonHeight = isMobile ? 56.0 : 60.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(containerPadding),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Row(
            children: [
              Container(
                width: isMobile ? 20 : 24,
                height: isMobile ? 20 : 24,
                decoration: BoxDecoration(
                  color: Color(0xFF00C896),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'د',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AED United Arab Emirates dirham',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFB0B0B0),
                size: isMobile ? 18 : 20,
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 24 : 32),
        Text(
          'Pay With',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(containerPadding),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF3A3A3A)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: Color(0xFF4A4A4A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.sync_alt,
                  color: Colors.white,
                  size: isMobile ? 18 : 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'P2P Express',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Buy on Binance P2P',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 32 : 48),
        Container(
          width: double.infinity,
          height: buttonHeight,
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
                color: Colors.black,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection(bool isMobile, bool isTablet, bool isDesktop) {
    final containerPadding = isMobile ? 20.0 : 32.0;
    
    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAQ',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),
          _buildFAQItem(
            '1',
            'What is P2P exchange?',
            Icons.add,
            isMobile,
          ),
          SizedBox(height: isMobile ? 20 : 24),
          _buildFAQItem(
            '2',
            'How do I buy Bitcoin locally on Binance P2P?',
            Icons.add,
            isMobile,
          ),
          SizedBox(height: isMobile ? 20 : 24),
          _buildFAQItem(
            '3',
            'Learn more about What is P2P Trading and How Does a Local Bitcoin Exchange Work?',
            Icons.open_in_new,
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildWhyBinanceSection(bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Binance',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 24 : (isTablet ? 28 : 32),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: isMobile ? 32 : 48),
        
        // Responsive feature cards grid
        _buildFeatureCardsGrid(isMobile, isTablet, isDesktop),
      ],
    );
  }

  Widget _buildFeatureCardsGrid(bool isMobile, bool isTablet, bool isDesktop) {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.star,
        'title': 'Accessible',
        'description': 'Start crypto trading by depositing from 35 available fiat currencies.',
      },
      {
        'icon': Icons.swap_horiz,
        'title': 'Convenient',
        'description': 'Transact seamlessly with 32 available payment methods.',
      },
      {
        'icon': Icons.percent,
        'title': 'Low-Cost',
        'description': 'Enjoy advantageous pricing with competitive rates, low fees, and stable conversion rates.',
      },
      {
        'icon': Icons.security,
        'title': 'Safe and Secure',
        'description': 'Protect and secure your assets anytime, anywhere.',
      },
    ];

    if (isMobile) {
      // Mobile - single column
      return Column(
        children: features.map((feature) => Container(
          margin: EdgeInsets.only(bottom: 20),
          child: _buildFeatureCard(
            icon: feature['icon'],
            title: feature['title'],
            description: feature['description'],
            iconColor: Color.fromARGB(255, 122, 79, 223),
            isMobile: isMobile,
            isTablet: isTablet,
            isDesktop: isDesktop,
          ),
        )).toList(),
      );
    } else if (isTablet) {
      // Tablet - 2x2 grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: features[0]['icon'],
                  title: features[0]['title'],
                  description: features[0]['description'],
                  iconColor: Color.fromARGB(255, 122, 79, 223),
                  isMobile: isMobile,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _buildFeatureCard(
                  icon: features[1]['icon'],
                  title: features[1]['title'],
                  description: features[1]['description'],
                  iconColor: Color.fromARGB(255, 122, 79, 223),
                  isMobile: isMobile,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: features[2]['icon'],
                  title: features[2]['title'],
                  description: features[2]['description'],
                  iconColor: Color.fromARGB(255, 122, 79, 223),
                  isMobile: isMobile,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _buildFeatureCard(
                  icon: features[3]['icon'],
                  title: features[3]['title'],
                  description: features[3]['description'],
                  iconColor: Color.fromARGB(255, 122, 79, 223),
                  isMobile: isMobile,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Desktop - 4 columns
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: feature == features.last ? 0 : 24),
            child: _buildFeatureCard(
              icon: feature['icon'],
              title: feature['title'],
              description: feature['description'],
              iconColor: Color.fromARGB(255, 122, 79, 223),
              isMobile: isMobile,
              isTablet: isTablet,
              isDesktop: isDesktop,
            ),
          ),
        )).toList(),
      );
    }
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required bool isMobile,
    required bool isTablet,
    required bool isDesktop,
  }) {
    final containerPadding = isMobile ? 20.0 : (isTablet ? 24.0 : 32.0);
    final iconSize = isMobile ? 48.0 : (isTablet ? 56.0 : 64.0);
    final iconContainerSize = isMobile ? 28.0 : 32.0;
    
    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: iconContainerSize,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            description,
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: isMobile ? 13 : 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String number, String question, IconData icon, bool isMobile) {
    return InkWell(
      onTap: () {
        // Handle FAQ item tap
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isMobile ? 24 : 28,
              height: isMobile ? 24 : 28,
              decoration: BoxDecoration(
                color: Color(0xFF3A3A3A),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(width: 12),
            Icon(
              icon,
              color: Colors.white,
              size: isMobile ? 18 : 20,
            ),
          ],
        ),
      ),
    );
  }
}