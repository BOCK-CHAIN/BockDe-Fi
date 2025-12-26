import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class NavigationItem {
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  NavigationItem(this.title, this.icon, this.selectedIcon);
}

// Data Models
class NotificationItem {
  final String id;
  final String type;
  final String user;
  final String action;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.user,
    required this.action,
    required this.timestamp,
    required this.isRead,
  });
}

class TrendingArticle {
  final String id;
  final String title;
  int reads;
  int likes;
  int rank;
  final bool isHot;
  final DateTime timestamp;

  TrendingArticle({
    required this.id,
    required this.title,
    required this.reads,
    required this.likes,
    required this.rank,
    required this.isHot,
    required this.timestamp,
  });
}

class HistoryItem {
  final String id;
  final String activity;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.activity,
    required this.timestamp,
  });
}

class AnalyticsData {
  int totalViews;
  double engagement;
  int newFollowers;
  double earnings;

  AnalyticsData({
    this.totalViews = 0,
    this.engagement = 0.0,
    this.newFollowers = 0,
    this.earnings = 0.0,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String author;
  final String content;
  final String type;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final bool isLive;
  final double priceChange;
  final bool isVerified;

  NewsItem({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLive,
    required this.priceChange,
    required this.isVerified,
  });
}

class SquareScreen extends StatefulWidget {
  const SquareScreen({Key? key}) : super(key: key);

  @override
  State<SquareScreen> createState() => _SquareScreenState();
}

class _SquareScreenState extends State<SquareScreen> with TickerProviderStateMixin {
  int selectedNavIndex = 0;
  int selectedTabIndex = 0;
  Timer? _newsTimer;
  Timer? _notificationTimer;
  Timer? _trendingTimer;
  Timer? _analyticsTimer;
  Timer? _historyTimer;
  List<NewsItem> _newsItems = [];
  List<NotificationItem> _notifications = [];
  List<TrendingArticle> _trendingArticles = [];
  List<HistoryItem> _historyItems = [];
  AnalyticsData _analytics = AnalyticsData();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;
  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> navigationItems = [
    NavigationItem('Home', Icons.home_outlined, Icons.home),
    NavigationItem('Notification', Icons.notifications_outlined, Icons.notifications),
    NavigationItem('Profile', Icons.person_outline, Icons.person),
    NavigationItem('Trending Articles', Icons.trending_up_outlined, Icons.trending_up),
    NavigationItem('News', Icons.article_outlined, Icons.article),
    NavigationItem('Bookmarked and\nLiked', Icons.bookmark_border_outlined, Icons.bookmark),
    NavigationItem('History', Icons.history_outlined, Icons.history),
    NavigationItem('Creator Center', Icons.dashboard_customize_outlined, Icons.dashboard_customize),
    NavigationItem('Settings', Icons.settings_outlined, Icons.settings),
  ];

  final List<String> squareTabs = [
    'Recommended',
    'Following',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _generateInitialNews();
    _generateInitialNotifications();
    _generateInitialTrending();
    _generateInitialHistory();
    _generateInitialAnalytics();
    
    _startRealTimeNewsUpdates();
    _startRealTimeNotifications();
    _startRealTimeTrending();
    _startRealTimeAnalytics();
    _startRealTimeHistory();
  }

  @override
  void dispose() {
    _newsTimer?.cancel();
    _notificationTimer?.cancel();
    _trendingTimer?.cancel();
    _analyticsTimer?.cancel();
    _historyTimer?.cancel();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateInitialNews() {
    final random = Random();
    final cryptos = ['BTC', 'ETH', 'BNB', 'ADA', 'DOT', 'SOL', 'MATIC', 'AVAX'];
    final newsTypes = ['Market Update', 'Analysis', 'Breaking News', 'Opinion', 'Tutorial'];
    final authors = ['BlockchainBaller', 'BOCK De-Fi Official', 'TraderPro', 'MarketAnalyst', 'CoinGuru'];

    for (int i = 0; i < 20; i++) {
      _newsItems.add(NewsItem(
        id: i.toString(),
        title: _generateNewsTitle(cryptos[random.nextInt(cryptos.length)]),
        author: authors[random.nextInt(authors.length)],
        content: _generateNewsContent(),
        type: newsTypes[random.nextInt(newsTypes.length)],
        timestamp: DateTime.now().subtract(Duration(minutes: random.nextInt(1440))),
        likes: random.nextInt(500),
        comments: random.nextInt(100),
        isLive: random.nextBool() && i < 3,
        priceChange: (random.nextDouble() - 0.5) * 20,
        isVerified: random.nextBool(),
      ));
    }
  }

  void _generateInitialNotifications() {
    final random = Random();
    final users = ['CryptoTrader', 'BlockchainExpert', 'MarketAnalyst', 'CoinGuru', 'TradePro', 'BitcoinBull'];
    final actions = [
      {'type': 'like', 'action': 'liked your post'},
      {'type': 'comment', 'action': 'commented on your post'},
      {'type': 'follow', 'action': 'started following you'},
      {'type': 'mention', 'action': 'mentioned you in a post'},
      {'type': 'share', 'action': 'shared your post'},
    ];

    for (int i = 0; i < 15; i++) {
      final action = actions[random.nextInt(actions.length)];
      _notifications.add(NotificationItem(
        id: i.toString(),
        type: action['type']!,
        user: users[random.nextInt(users.length)],
        action: action['action']!,
        timestamp: DateTime.now().subtract(Duration(minutes: random.nextInt(1440))),
        isRead: random.nextBool(),
      ));
    }
  }

  void _generateInitialTrending() {
    final articles = [
      'Bitcoin Price Prediction: Will BTC Reach \$100K in 2024?',
      'Ethereum 2.0: The Complete Guide to Staking',
      'DeFi vs Traditional Finance: A Comprehensive Comparison',
      'NFT Market Analysis: Trends and Opportunities',
      'Altcoin Season: Which Coins to Watch',
      'Crypto Regulations: What You Need to Know',
      'Web3 Development: Getting Started Guide',
      'BOCK De-Fi Smart Chain: Complete Tutorial',
      'Yield Farming Strategies for 2024',
      'Layer 2 Solutions: Scaling Ethereum',
    ];
    
    final random = Random();
    for (int i = 0; i < articles.length; i++) {
      _trendingArticles.add(TrendingArticle(
        id: i.toString(),
        title: articles[i],
        reads: 1000 + random.nextInt(5000),
        likes: 50 + random.nextInt(500),
        rank: i + 1,
        isHot: random.nextBool() && i < 3,
        timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      ));
    }
  }

  void _generateInitialHistory() {
    final activities = [
      'Viewed post: "Bitcoin Technical Analysis"',
      'Liked comment by @CryptoExpert',
      'Shared article: "DeFi Explained"',
      'Followed @MarketAnalyst',
      'Commented on trending post',
      'Bookmarked: "Trading Strategies Guide"',
      'Watched live stream: "Market Update"',
      'Joined discussion: "Altcoin Predictions"',
    ];
    
    final random = Random();
    for (int i = 0; i < 20; i++) {
      _historyItems.add(HistoryItem(
        id: i.toString(),
        activity: activities[random.nextInt(activities.length)],
        timestamp: DateTime.now().subtract(Duration(minutes: random.nextInt(2880))),
      ));
    }
  }

  void _generateInitialAnalytics() {
    final random = Random();
    _analytics = AnalyticsData(
      totalViews: 12500 + random.nextInt(1000),
      engagement: 8.2 + (random.nextDouble() - 0.5) * 2,
      newFollowers: 156 + random.nextInt(50),
      earnings: 45.30 + (random.nextDouble() * 10),
    );
  }

  String _generateNewsTitle(String crypto) {
    final titles = [
      'How I Earn \$20 to \$50 from BOCK De-Fi without investing \$0',
      '$crypto Price Analysis: Breaking Through Resistance',
      'Major $crypto Update: New Partnership Announced',
      '$crypto Soars 15% After Major Institutional Investment',
      'Technical Analysis: $crypto Shows Bullish Momentum',
      'Breaking: $crypto Adoption Increases by 300%',
      'Simple ways to earn free money on BOCK De-Fi',
    ];
    return titles[Random().nextInt(titles.length)];
  }

  String _generateNewsContent() {
    final contents = [
      'When I first started exploring BOCK De-Fi, I was surprised to learn that it isn\'t just a place to trade crypto it also offers many simple ways to earn free money. Over time, I figured out a few reliable methods that consistently gave me between \$20 and \$50 in extra rewards, all without needing to take big risks. Here\'s exactly how I did it, step by step.\n\n1. BOCK De-Fi Learn & Earn...',
      'The cryptocurrency market is showing strong bullish momentum as institutional investors continue to pour money into digital assets. Key resistance levels are being tested as we approach critical support zones.',
      'Latest technical indicators suggest a potential breakout pattern forming. Traders are closely monitoring key resistance levels and volume indicators for confirmation signals.',
      'In a surprising turn of events, major partnerships are being announced that could reshape the crypto landscape. Industry experts believe this could be the catalyst for the next bull run.',
      'Market sentiment remains optimistic despite recent volatility. Key support levels are holding strong, and institutional interest continues to grow across major cryptocurrencies.',
    ];
    return contents[Random().nextInt(contents.length)];
  }

  void _startRealTimeNewsUpdates() {
    _newsTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _addNewNewsItem();
      }
    });
  }

  void _startRealTimeNotifications() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (mounted) {
        _addNewNotification();
      }
    });
  }

  void _startRealTimeTrending() {
    _trendingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (mounted) {
        _updateTrendingArticles();
      }
    });
  }

  void _startRealTimeAnalytics() {
    _analyticsTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        _updateAnalytics();
      }
    });
  }

  void _startRealTimeHistory() {
    _historyTimer = Timer.periodic(const Duration(seconds: 18), (timer) {
      if (mounted) {
        _addNewHistoryItem();
      }
    });
  }

  void _addNewNewsItem() {
    final random = Random();
    final cryptos = ['BTC', 'ETH', 'BNB', 'ADA', 'DOT', 'SOL', 'MATIC', 'AVAX'];
    final authors = ['BlockchainBaller', 'CryptoExpert', 'TraderPro', 'MarketAnalyst', 'CoinGuru'];
    final newsTypes = ['Market Update', 'Analysis', 'Breaking News', 'Opinion', 'Tutorial'];

    final newItem = NewsItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _generateNewsTitle(cryptos[random.nextInt(cryptos.length)]),
      author: authors[random.nextInt(authors.length)],
      content: _generateNewsContent(),
      type: newsTypes[random.nextInt(newsTypes.length)],
      timestamp: DateTime.now(),
      likes: random.nextInt(50),
      comments: random.nextInt(20),
      isLive: random.nextBool() && random.nextInt(10) < 2,
      priceChange: (random.nextDouble() - 0.5) * 10,
      isVerified: random.nextBool(),
    );

    setState(() {
      _newsItems.insert(0, newItem);
      if (_newsItems.length > 50) {
        _newsItems = _newsItems.take(50).toList();
      }
    });
  }

  void _addNewNotification() {
    final random = Random();
    final users = ['CryptoTrader', 'BlockchainExpert', 'MarketAnalyst', 'CoinGuru', 'TradePro', 'BitcoinBull'];
    final actions = [
      {'type': 'like', 'action': 'liked your post'},
      {'type': 'comment', 'action': 'commented on your post'},
      {'type': 'follow', 'action': 'started following you'},
      {'type': 'mention', 'action': 'mentioned you in a post'},
      {'type': 'share', 'action': 'shared your post'},
    ];

    final action = actions[random.nextInt(actions.length)];
    final newNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: action['type']!,
      user: users[random.nextInt(users.length)],
      action: action['action']!,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _notifications.insert(0, newNotification);
      if (_notifications.length > 50) {
        _notifications = _notifications.take(50).toList();
      }
    });
  }

  void _updateTrendingArticles() {
    final random = Random();
    setState(() {
      for (var article in _trendingArticles) {
        article.reads += random.nextInt(100);
        article.likes += random.nextInt(10);
      }
      
      if (random.nextBool()) {
        _trendingArticles.shuffle();
        for (int i = 0; i < _trendingArticles.length; i++) {
          _trendingArticles[i].rank = i + 1;
        }
      }
    });
  }

  void _updateAnalytics() {
    final random = Random();
    setState(() {
      _analytics.totalViews += random.nextInt(50);
      _analytics.engagement += (random.nextDouble() - 0.5) * 0.2;
      if (random.nextBool()) _analytics.newFollowers += random.nextInt(5);
      if (random.nextBool()) _analytics.earnings += random.nextDouble() * 2;
    });
  }

  void _addNewHistoryItem() {
    final activities = [
      'Viewed post: "Market Analysis Update"',
      'Liked comment by @NewTrader',
      'Shared article: "Latest Crypto News"',
      'Followed @TrendingAnalyst',
      'Commented on hot post',
      'Bookmarked: "Investment Guide"',
      'Watched live stream: "Daily Briefing"',
      'Joined discussion: "Market Predictions"',
    ];
    
    final random = Random();
    final newHistory = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      activity: activities[random.nextInt(activities.length)],
      timestamp: DateTime.now(),
    );

    setState(() {
      _historyItems.insert(0, newHistory);
      if (_historyItems.length > 50) {
        _historyItems = _historyItems.take(50).toList();
      }
    });
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      drawer: _isMobile ? _buildMobileDrawer() : null,
      body: _isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1E2026),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.apps, color: Colors.black, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'BOCK De-Fi SQUARE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedNavIndex == index;
                final item = navigationItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2B3139) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected ? Colors.white : const Color(0xFF848E9C),
                      size: 22,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF848E9C),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedNavIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileAppBar(),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildLeftNavigation(),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildMobileAppBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2026),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2B3139), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.apps, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'BOCK De-Fi SQUARE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            Icon(Icons.dark_mode_outlined, color: Color(0xFF848E9C), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftNavigation() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2026),
        border: Border(
          right: BorderSide(color: Color(0xFF2B3139), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.home_outlined, color: Colors.white, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.apps, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                Icon(Icons.language, color: Color(0xFF848E9C), size: 24),
                const SizedBox(width: 12),
                Icon(Icons.dark_mode_outlined, color: Color(0xFF848E9C), size: 24),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.apps, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'BOCK D-Fi SQUARE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedNavIndex == index;
                final item = navigationItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2B3139) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected ? Colors.white : const Color(0xFF848E9C),
                      size: 22,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF848E9C),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedNavIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (selectedNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildNotificationContent();
      case 2:
        return _buildProfileContent();
      case 3:
        return _buildTrendingArticlesContent();
      case 4:
        return _buildNewsContent();
      case 5:
        return _buildBookmarkedContent();
      case 6:
        return _buildHistoryContent();
      case 7:
        return _buildCreatorCenterContent();
      case 8:
        return _buildSettingsContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: _buildContentArea(),
        ),
      ],
    );
  }

  Widget _buildNotificationContent() {
    return Column(
      children: [
        _buildPageHeader('Notifications', _notifications.where((n) => !n.isRead).length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(_notifications[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: [
        _buildPageHeader('Profile'),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(_isMobile ? 16 : 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(_isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2026),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2B3139), width: 1),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: _isMobile ? 40 : 50,
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        child: Text(
                          'U',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your Username',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Crypto Enthusiast | BOCK De-Fi Square User',
                        style: TextStyle(
                          color: Color(0xFF848E9C),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _isMobile ? 
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProfileStat('Posts', '24'),
                              _buildProfileStat('Followers', '1.2K'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProfileStat('Following', '456'),
                              _buildProfileStat('Likes', '8.9K'),
                            ],
                          ),
                        ],
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProfileStat('Posts', '24'),
                          _buildProfileStat('Followers', '1.2K'),
                          _buildProfileStat('Following', '456'),
                          _buildProfileStat('Likes', '8.9K'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingArticlesContent() {
    return Column(
      children: [
        _buildPageHeader('Trending Articles'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5 + 0.5 * _pulseController.value),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Text(
                'Live trending updates',
                style: TextStyle(color: Color(0xFF848E9C), fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _trendingArticles.length,
            itemBuilder: (context, index) {
              return _buildTrendingArticleCard(_trendingArticles[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsContent() {
    return Column(
      children: [
        _buildPageHeader('Crypto News'),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _newsItems.length,
            itemBuilder: (context, index) {
              return _buildNewsCard(_newsItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkedContent() {
    return Column(
      children: [
        _buildPageHeader('Bookmarked and Liked'),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF2B3139), width: 1),
                    ),
                  ),
                  child: const TabBar(
                    indicatorColor: Color.fromARGB(255, 122, 79, 223),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xFF848E9C),
                    tabs: [
                      Tab(text: 'Bookmarked'),
                      Tab(text: 'Liked'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildBookmarkedList(),
                      _buildLikedList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryContent() {
    return Column(
      children: [
        _buildPageHeader('Activity History'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.update, color: Color(0xFF848E9C), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Real-time activity tracking',
                  style: TextStyle(color: Color(0xFF848E9C), fontSize: _isMobile ? 10 : 12),
                ),
              ),
              if (!_isMobile) ...[
                const SizedBox(width: 8),
                Text(
                  'Last update: ${_formatTimestamp(_historyItems.isNotEmpty ? _historyItems[0].timestamp : DateTime.now())}',
                  style: const TextStyle(color: Color(0xFF848E9C), fontSize: 10),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _historyItems.length,
            itemBuilder: (context, index) {
              return _buildHistoryCard(_historyItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorCenterContent() {
    return Column(
      children: [
        _buildPageHeader('Creator Center'),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(_isMobile ? 16 : 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(_isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2026),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2B3139), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1 + 0.1 * _pulseController.value),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green, width: 1),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle, color: Colors.green, size: 6),
                                    SizedBox(width: 4),
                                    Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _isMobile ? 
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildAnalyticCard('Total Views', '${_analytics.totalViews}', Icons.visibility)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildAnalyticCard('Engagement', '${_analytics.engagement.toStringAsFixed(1)}%', Icons.favorite)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildAnalyticCard('New Followers', '${_analytics.newFollowers}', Icons.person_add)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildAnalyticCard('Earnings', '\${_analytics.earnings.toStringAsFixed(2)}', Icons.monetization_on)),
                            ],
                          ),
                        ],
                      ) :
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildAnalyticCard('Total Views', '${_analytics.totalViews}', Icons.visibility)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildAnalyticCard('Engagement', '${_analytics.engagement.toStringAsFixed(1)}%', Icons.favorite)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildAnalyticCard('New Followers', '${_analytics.newFollowers}', Icons.person_add)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildAnalyticCard('Earnings', '\${_analytics.earnings.toStringAsFixed(2)}', Icons.monetization_on)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(_isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2026),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2B3139), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Creator Tools',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isMobile ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCreatorTool('Content Scheduler', 'Schedule your posts', Icons.schedule),
                      _buildCreatorTool('Analytics Dashboard', 'Track your performance', Icons.analytics),
                      _buildCreatorTool('Monetization', 'Earn from your content', Icons.paid),
                      _buildCreatorTool('Community Management', 'Engage with followers', Icons.group),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      children: [
        _buildPageHeader('Settings'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingsSection('Account', [
                _buildSettingItem('Profile Information', Icons.person),
                _buildSettingItem('Privacy Settings', Icons.privacy_tip),
                _buildSettingItem('Security', Icons.security),
                _buildSettingItem('Verification', Icons.verified),
              ]),
              _buildSettingsSection('Notifications', [
                _buildSettingItem('Push Notifications', Icons.notifications),
                _buildSettingItem('Email Notifications', Icons.email),
                _buildSettingItem('SMS Notifications', Icons.sms),
              ]),
              _buildSettingsSection('Preferences', [
                _buildSettingItem('Language', Icons.language),
                _buildSettingItem('Theme', Icons.palette),
                _buildSettingItem('Currency', Icons.monetization_on),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: _isMobile ? 16 : 24, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2026),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2B3139), width: 1),
        ),
      ),
      child: _isMobile ? 
      Row(
        children: [
          ...List.generate(squareTabs.length, (index) {
            final isSelected = selectedTabIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(
                          bottom: BorderSide(color: Color.fromARGB(255, 122, 79, 223), width: 2),
                        )
                      : null,
                ),
                child: Text(
                  squareTabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF848E9C),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF848E9C)),
            onPressed: () {},
          ),
        ],
      ) :
      Row(
        children: [
          ...List.generate(squareTabs.length, (index) {
            final isSelected = selectedTabIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(
                          bottom: BorderSide(color: Color.fromARGB(255, 122, 79, 223), width: 2),
                        )
                      : null,
                ),
                child: Text(
                  squareTabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF848E9C),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Container(
            width: 200,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2B3139),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0xFF848E9C), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF848E9C), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      color: const Color(0xFF0B0E11),
      child: _isMobile ? 
      _buildNewsFeed() :
      Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildNewsFeed(),
          ),
          Container(
            width: 350,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFF2B3139), width: 1),
              ),
            ),
            child: _buildRightSidebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsFeed() {
    return Column(
      children: [
        _buildPostCreationBox(),
        Container(
          margin: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Show 5 Posts',
              style: TextStyle(
                color: Color.fromARGB(255, 122, 79, 223),
                fontSize: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _newsItems.length,
            itemBuilder: (context, index) {
              return _buildNewsCard(_newsItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostCreationBox() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: _isMobile ? 18 : 20,
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                child: const Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts',
                    hintStyle: TextStyle(color: Color(0xFF848E9C)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isMobile ?
          Column(
            children: [
              Row(
                children: [
                  _buildPostOption(Icons.emoji_emotions_outlined),
                  _buildPostOption(Icons.image_outlined),
                  _buildPostOption(Icons.gif_box_outlined),
                  _buildPostOption(Icons.info_outline),
                  _buildPostOption(Icons.poll_outlined),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3139),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Article',
                      style: TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ) :
          Row(
            children: [
              _buildPostOption(Icons.emoji_emotions_outlined),
              _buildPostOption(Icons.image_outlined),
              _buildPostOption(Icons.gif_box_outlined),
              _buildPostOption(Icons.info_outline),
              _buildPostOption(Icons.poll_outlined),
              _buildPostOption(Icons.link),
              _buildPostOption(Icons.location_on_outlined),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B3139),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Article',
                  style: TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostOption(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(6),
      child: Icon(
        icon,
        color: const Color(0xFF848E9C),
        size: 20,
      ),
    );
  }

  Widget _buildNewsCard(NewsItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: _isMobile ? 18 : 20,
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                child: Text(
                  item.author[0],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.author,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isVerified) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _formatTimestamp(item.timestamp),
                          style: const TextStyle(
                            color: Color(0xFF848E9C),
                            fontSize: 12,
                          ),
                        ),
                        if (item.isLive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: Colors.red, size: 6),
                                SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Follow',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: _isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.content,
            style: const TextStyle(
              color: Color(0xFFEAECEF),
              fontSize: 14,
              height: 1.5,
            ),
            maxLines: _isMobile ? 3 : null,
            overflow: _isMobile ? TextOverflow.ellipsis : TextOverflow.visible,
          ),
          if (_isMobile && item.content.length > 150) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Read more',
                style: TextStyle(
                  color: Color.fromARGB(255, 122, 79, 223),
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton(Icons.thumb_up_outlined, item.likes.toString()),
              const SizedBox(width: 24),
              _buildActionButton(Icons.chat_bubble_outline, item.comments.toString()),
              const SizedBox(width: 24),
              _buildActionButton(Icons.share_outlined, _isMobile ? '' : 'Share'),
              const Spacer(),
              _buildActionButton(Icons.bookmark_border, ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF848E9C), size: 20),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E2026), Color(0xFF2B3139)],
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF2B3139),
                ),
                child: const Center(
                  child: Icon(
                    Icons.candlestick_chart,
                    color: Color.fromARGB(255, 122, 79, 223),
                    size: 48,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 6),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Advertisement',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EARN UP TO 100% CONVERT COMMISSION!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trending Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(5, (index) {
                final trends = ['#Bitcoin', '#Ethereum', '#DeFi', '#NFT', '#BOCK De-Fi'];
                final changes = ['+5.2%', '+3.8%', '-1.2%', '+7.1%', '+2.4%'];
                final isPositive = !changes[index].startsWith('-');
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF848E9C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          trends[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        changes[index],
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Widget _buildPageHeader(String title, [int? count]) {
    return Container(
      height: _isMobile ? 60 : 80,
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile ? 16 : 24, 
        vertical: _isMobile ? 8 : 16
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2026),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2B3139), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile ? 20 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: notification.isRead ? const Color(0xFF1E2026) : const Color(0xFF1E2026).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? const Color(0xFF2B3139) : const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3), 
          width: 1
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: _isMobile ? 16 : 20,
            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            child: Text(
              notification.user[0], 
              style: TextStyle(
                color: Colors.black,
                fontSize: _isMobile ? 14 : 16,
              )
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isMobile ? 13 : 14,
                          ),
                          children: [
                            TextSpan(
                              text: notification.user,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' ${notification.action}'),
                          ],
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 122, 79, 223),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            notification.type == 'like' ? Icons.favorite : 
            notification.type == 'comment' ? Icons.comment :
            notification.type == 'follow' ? Icons.person_add : 
            notification.type == 'share' ? Icons.share : Icons.alternate_email,
            color: const Color.fromARGB(255, 122, 79, 223),
            size: _isMobile ? 18 : 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: _isMobile ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF848E9C),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingArticleCard(TrendingArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(_isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: article.isHot ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  article.isHot ? 'HOT' : 'TRENDING', 
                  style: TextStyle(
                    color: article.isHot ? Colors.red : Colors.orange, 
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#${article.rank}',
                  style: const TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: TextStyle(
              color: Colors.white, 
              fontSize: _isMobile ? 14 : 16, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.visibility, color: const Color(0xFF848E9C), size: 16),
              const SizedBox(width: 4),
              Text('${article.reads}', style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.favorite, color: const Color(0xFF848E9C), size: 16),
              const SizedBox(width: 4),
              Text('${article.likes}', style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12)),
              const Spacer(),
              Text(_formatTimestamp(article.timestamp), style: const TextStyle(color: Color(0xFF848E9C), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3139), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2B3139),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.history, color: const Color(0xFF848E9C), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.activity,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _isMobile ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(item.timestamp),
                  style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 122, 79, 223)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: _isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF848E9C),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorTool(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3139),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 122, 79, 223)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: _isMobile ? 14 : 16,
                  )
                ),
                Text(
                  description, 
                  style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12)
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Color(0xFF848E9C), size: 16),
        ],
      ),
    );
  }

  Widget _buildBookmarkedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(_isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2026),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2B3139), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.bookmark, color: Color.fromRGBO(240, 185, 11, 1)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Bookmarked post about crypto trading strategies...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _isMobile ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLikedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(_isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2026),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2B3139), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Liked post about market analysis and predictions...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _isMobile ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2026),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3139), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(_isMobile ? 12 : 16),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _isMobile ? 12 : 16, 
          vertical: _isMobile ? 10 : 12
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF2B3139), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF848E9C)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile ? 14 : 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF848E9C), size: 16),
          ],
        ),
      ),
    );
  }
}

// Main app wrapper to run the application
class BinanceSquareApp extends StatelessWidget {
  const BinanceSquareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOCK De-Fi Square',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF0B0E11),
      ),
      home: const SquareScreen(),
    );
  }
}

void main() {
  runApp(const BinanceSquareApp());
}