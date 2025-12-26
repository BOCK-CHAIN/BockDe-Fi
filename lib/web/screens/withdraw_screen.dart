import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WithdrawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 0, 0, 0), // Dark background
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw AED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency',
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
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
                                color: Color(0xFF00C896),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'د',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
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
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFFB0B0B0),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Pay With',
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFF3A3A3A)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A4A4A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.sync_alt,
                                color: Colors.white,
                                size: 20,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Buy on BOCK De-Fi P2P',
                                    style: TextStyle(
                                      color: Color(0xFFB0B0B0),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(32),
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
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 32),
                        _buildFAQItem(
                          '1',
                          'What is P2P exchange?',
                          Icons.add,
                        ),
                        SizedBox(height: 24),
                        _buildFAQItem(
                          '2',
                          'How do I buy Bitcoin locally on BOCK De-Fi P2P?',
                          Icons.add,
                        ),
                        SizedBox(height: 24),
                        _buildFAQItem(
                          '3',
                          'Learn more about What is P2P Trading and How Does a Local Bitcoin Exchange Work?',
                          Icons.open_in_new,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            // Why Binance section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why BOCK De-Fi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureCard(
                        icon: Icons.star,
                        title: 'Accessible',
                        description: 'Start crypto trading by depositing from 35 available fiat currencies.',
                        iconColor: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        icon: Icons.swap_horiz,
                        title: 'Convenient',
                        description: 'Transact seamlessly with 32 available payment methods.',
                        iconColor: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        icon: Icons.percent,
                        title: 'Low-Cost',
                        description: 'Enjoy advantageous pricing with competitive rates, low fees, and stable conversion rates.',
                        iconColor: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildFeatureCard(
                        icon: Icons.security,
                        title: 'Safe and Secure',
                        description: 'Protect and secure your assets anytime, anywhere.',
                        iconColor: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 80),
            // Top Crypto-Fiat Pairs section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Crypto-Fiat Pairs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Withdraw Local Fiat Currencies to Buy Crypto.',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 48),
                // First row of crypto pairs
                Row(
                  children: [
                    Expanded(
                      child: _buildCryptoPairCard(
                        'USDT to AZN',
                        '1 USDT = 1.720357 AZN',
                        Color(0xFF00D4AA), // USDT green
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildCryptoPairCard(
                        'IO to AZN',
                        '1 IO = 1.0606531 AZN',
                        Color(0xFF2A2A2A), // IO dark
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildCryptoPairCard(
                        'NOT to AZN',
                        '1 NOT = 0.0032096 AZN',
                        Color(0xFFFCD535), // NOT yellow
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Second row of crypto pairs
                Row(
                  children: [
                    Expanded(
                      child: _buildCryptoPairCard(
                        'BB to AZN',
                        '1 BB = 0.235763 AZN',
                        Color(0xFF000000), // BB black
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildCryptoPairCard(
                        'REZ to AZN',
                        '1 REZ = 0.0218688 AZN',
                        Color(0xFF7ED321), // REZ green
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildCryptoPairCard(
                        'SHIB to AZN',
                        '1 SHIB = 0.0000217 AZN',
                        Color(0xFFFF6B35), // SHIB orange/red
                        Color(0xFF6C7AE0), // AZN blue
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                // Footer text
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'This site is protected by reCAPTCHA and the Google ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 122, 79, 223),
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: Color.fromARGB(255, 122, 79, 223),
                        ),
                      ),
                      TextSpan(
                        text: ' apply.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoPairCard(String pair, String rate, Color crypto1Color, Color crypto2Color) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pair,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: crypto1Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: crypto2Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            rate,
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A3A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String number, String question, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Color(0xFF3A3A3A),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            question,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(width: 12),
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ],
    );
  }
}