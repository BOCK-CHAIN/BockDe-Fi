import 'package:bockchain/web/screens/buy_crypto_screen.dart';
import 'package:bockchain/web/screens/earn_screen.dart';
import 'package:bockchain/web/screens/market_screen.dart';
import 'package:bockchain/web/screens/square_screen.dart';
import 'package:bockchain/web/screens/trade_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<Map<String, dynamic>> navItems = [
    {'title': 'Buy Crypto', 'hasDropdown': false, 'icon': Icons.shopping_cart_outlined},
    {'title': 'Markets', 'hasDropdown': false, 'icon': Icons.trending_up},
    {'title': 'Trade', 'hasDropdown': true, 'icon': Icons.swap_horiz},
    {'title': 'Futures', 'hasDropdown': true, 'icon': Icons.timeline},
    {'title': 'Earn', 'hasDropdown': true, 'icon': Icons.savings_outlined},
    {'title': 'Square', 'hasDropdown': true, 'icon': Icons.dashboard_outlined},
    {'title': 'More', 'hasDropdown': true, 'icon': Icons.more_horiz},
  ];

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'हिंदी', 'flag': '🇮🇳'},
  ];

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

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
      child: _isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      children: [
        // Hamburger Menu
        IconButton(
          onPressed: () => _showMobileMenu(),
          icon: const Icon(
            Icons.menu,
            color: Colors.white70,
            size: 24,
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Logo Section (Compact)
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Bock Chain',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // Mobile Actions
        Row(
          children: [
            IconButton(
              onPressed: _showSearchDialog,
              icon: const Icon(
                Icons.search,
                color: Colors.white70,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: _showLoginDialog,
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
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
                child: GestureDetector(
                  onTap: () => _navigateToScreen(item['title']),
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
                onPressed: _showSearchDialog,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Log In Button
              TextButton(
                onPressed: _showLoginDialog,
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
                  onPressed: _showSignUpDialog,
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
                    onPressed: _showDownloadOptions,
                    icon: const Icon(
                      Icons.download_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: _showLanguageDialog,
                    icon: const Icon(
                      Icons.language,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onThemeToggle(!widget.isDarkMode),
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
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
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
                          fontSize: 16,
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
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            const Divider(color: Color(0xFF2D2D4A), height: 1),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  ...navItems.map((item) => _buildMobileNavItem(item)).toList(),
                  
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFF2D2D4A), height: 1),
                  const SizedBox(height: 20),
                  
                  // Account Actions
                  _buildMobileActionItem(
                    'Log In',
                    Icons.login,
                    () {
                      Navigator.pop(context);
                      _showLoginDialog();
                    },
                  ),
                  _buildMobileActionItem(
                    'Sign Up',
                    Icons.person_add,
                    () {
                      Navigator.pop(context);
                      _showSignUpDialog();
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFF2D2D4A), height: 1),
                  const SizedBox(height: 20),
                  
                  // Settings
                  _buildMobileActionItem(
                    'Download App',
                    Icons.download_outlined,
                    () {
                      Navigator.pop(context);
                      _showDownloadOptions();
                    },
                  ),
                  _buildMobileActionItem(
                    'Language',
                    Icons.language,
                    () {
                      Navigator.pop(context);
                      _showLanguageDialog();
                    },
                  ),
                  _buildMobileActionItem(
                    'Theme',
                    Icons.dark_mode_outlined,
                    () {
                      widget.onThemeToggle(!widget.isDarkMode);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _navigateToScreen(item['title']);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              item['icon'],
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              item['title'],
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (item['hasDropdown'])
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white30,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileActionItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(String title) {
    switch (title) {
      case 'Buy Crypto':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuyCryptoScreen()),
        );
        break;
      case 'Markets':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketScreen()),
        );
        break;
      case 'Earn':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EarnScreen()),
        );
        break;
      case 'Trade':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradeScreen()),
        );
        break;
      case 'Square':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SquareScreen()),
        );
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: _isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: _isMobile ? MediaQuery.of(context).size.width * 0.8 : 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...languages.map((lang) => ListTile(
                leading: Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                title: Text(
                  lang['name']!,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                onTap: () {
                  widget.onLanguageChange(lang['code']!);
                  Navigator.pop(context);
                },
                selected: widget.selectedLanguage == lang['code'],
                selectedTileColor: const Color(0xFF8B5CF6).withOpacity(0.1),
              )).toList(),
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
          width: _isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
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
          width: _isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
          child: SingleChildScrollView(
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
          width: _isMobile ? MediaQuery.of(context).size.width * 0.8 : 350,
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
              _isMobile ?
              Column(
                children: [
                  _buildDownloadButton('App Store', Icons.apple, () {}, fullWidth: true),
                  const SizedBox(height: 12),
                  _buildDownloadButton('Play Store', Icons.android, () {}, fullWidth: true),
                ],
              ) :
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

  Widget _buildDownloadButton(String text, IconData icon, VoidCallback onTap, {bool fullWidth = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D4A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
        ),
        child: fullWidth ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ) :
        Column(
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