import 'package:bockchain/web/screens/convert_screen.dart';
import 'package:bockchain/web/screens/p2p_trade_screen.dart';
import 'package:bockchain/web/screens/spot_screen.dart';
import 'package:bockchain/web/screens/margin_screen.dart';
import 'package:flutter/material.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final List<TradeOption> _tradeOptions = [
    TradeOption(
      title: 'Spot',
      icon: Icons.trending_up,
      description: 'Buy & sell crypto with zero fees',
      primaryColor: const Color(0xFF8B5CF6),
      screen: SpotScreen(),
      features: ['Zero fees', '500+ pairs'],
    ),
    TradeOption(
      title: 'Margin',
      icon: Icons.trending_up_sharp,
      description: 'Trade with up to 10x leverage',
      primaryColor: const Color(0xFFEF4444),
      screen: const MarginScreen(),
      features: ['10x leverage', 'Risk tools'],
    ),
    TradeOption(
      title: 'P2P',
      icon: Icons.people_rounded,
      description: 'Trade directly with other users',
      primaryColor: const Color(0xFF10B981),
      screen: const P2PTradeScreen(),
      features: ['Peer trading', 'Escrow safety'],
    ),
    TradeOption(
      title: 'Convert',
      icon: Icons.swap_horizontal_circle,
      description: 'Instant crypto conversions',
      primaryColor: const Color(0xFFF59E0B),
      screen: const ConvertScreen(),
      features: ['Instant convert', 'Best rates'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 60 : (isTablet ? 40 : 20),
                  vertical: 20,
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 2 : 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 2.2 : 1.6,
                  ),
                  itemCount: _tradeOptions.length,
                  itemBuilder: (context, index) => _buildTradeCard(_tradeOptions[index], index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your trading experience',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2329),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2B3139)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0ECB81),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeCard(TradeOption option, int index) {
    return GestureDetector(
      onTap: () => _navigateToScreen(option),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2A2A2B),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: option.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(option.icon, color: Colors.white, size: 20),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: option.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: option.primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      index == 0 ? 'Popular' : (index == 1 ? 'Pro' : (index == 2 ? 'Safe' : 'Fast')),
                      style: TextStyle(
                        color: option.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                option.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                option.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...option.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: option.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  color: option.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () => _navigateToScreen(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start ${option.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(TradeOption option) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => option.screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class TradeOption {
  final String title;
  final IconData icon;
  final String description;
  final Color primaryColor;
  final Widget screen;
  final List<String> features;

  TradeOption({
    required this.title,
    required this.icon,
    required this.description,
    required this.primaryColor,
    required this.screen,
    required this.features,
  });
}