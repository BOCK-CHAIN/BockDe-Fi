import 'package:bockchain/screens/buy_crypto_screen.dart';
import 'package:bockchain/screens/earn_screen.dart';
import 'package:bockchain/screens/market_screen.dart';
import 'package:bockchain/screens/p2p_trade_screen.dart';
import 'package:bockchain/screens/spot_screen.dart';
import 'package:bockchain/screens/square_screen.dart';
import 'package:bockchain/screens/trade_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopNavigationBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;
  final String selectedLanguage;
  final Function(String) onLanguageChange;
  
  const TopNavigationBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  String? hoveredItem;
  bool showLanguageDropdown = false;
  
  final List<Map<String, dynamic>> navItems = [
    {'title': 'Buy Crypto', 'hasDropdown': false},
    {'title': 'Markets', 'hasDropdown': false},
    {'title': 'Trade', 'hasDropdown': true},
    {'title': 'Futures', 'hasDropdown': true},
    {'title': 'Earn', 'hasDropdown': true},
    {'title': 'Square', 'hasDropdown': true},
    {'title': 'More', 'hasDropdown': true},
  ];

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'हिंदी', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2D2D4A),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 122, 79, 223), Color(0xFFA855F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Bock Chain',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
  child: Row(
    children: navItems.map((item) {
      return MouseRegion(
        onEnter: (_) => setState(() => hoveredItem = item['title']),
        onExit: (_) => setState(() => hoveredItem = null),
        child: GestureDetector(  // ✅ Add this
          onTap: () {
            if (item['title'] == 'Buy Crypto') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyCryptoScreen(), // ✅ Navigate
                ),
              );
            }
            if (item['title'] == 'Markets') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarketScreen(), // ✅ Navigate
                ),
              );
            }
            if (item['title'] == 'Earn') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EarnScreen(), // ✅ Navigate
                ),
              );
            }
            if (item['title'] == 'Trade') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradeScreen(), // ✅ Navigate
                ),
              );
            }
            if (item['title'] == 'Square') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SquareScreen(), // ✅ Navigate
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hoveredItem == item['title'] 
                        ? const Color(0xFF8B5CF6)
                        : Colors.white70,
                  ),
                ),
                if (item['hasDropdown']) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: hoveredItem == item['title'] 
                        ? const Color(0xFF8B5CF6)
                        : Colors.white70,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList(),
  ),
),
          
          // Right Side Actions
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                // Search Icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Log In Button
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Log In',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Sign Up Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Additional Icons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.language,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Search Cryptocurrencies',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for coins, tokens...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(color: const Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Log In to Bock Chain',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email/Phone Number',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Add login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSignUpDialog();
                    },
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.inter(color: const Color(0xFF8B5CF6)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add forgot password logic
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign Up for Bock Chain',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email/Phone Number',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2D2D4A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Add signup logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showLoginDialog();
                },
                child: Text(
                  'Already have an account? Log In',
                  style: GoogleFonts.inter(color: const Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDownloadOptions() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Download Bock Chain App',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDownloadButton('App Store', Icons.apple, () {}),
                  _buildDownloadButton('Play Store', Icons.android, () {}),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(color: const Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D4A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}