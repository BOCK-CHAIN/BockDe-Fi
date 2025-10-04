import 'package:flutter/material.dart';

class MobileSquareScreen extends StatefulWidget {
  const MobileSquareScreen({Key? key}) : super(key: key);

  @override
  State<MobileSquareScreen> createState() => _MobileSquareScreenState();
}

class _MobileSquareScreenState extends State<MobileSquareScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? const HomeScreen() : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color.fromARGB(255, 122, 79, 223),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.currency_bitcoin, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'BINANCE SQUARE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 122, 79, 223),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Discover'),
              Tab(text: 'Following'),
              Tab(text: 'News'),
              Tab(text: 'Academy'),
              Tab(text: 'Moments'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DiscoverTab(),
            FollowingTab(),
            NewsTab(),
            AcademyTab(),
            MomentsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}

// Discover Tab
class DiscoverTab extends StatelessWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPostCard(
          author: 'Marcus Corvinus',
          time: '18h',
          badge: 'Bullish',
          content: '\$PEPE just pumped from 0.000000923 ➜ 0.000000968 with strong momentum. Buyers are defending above 0.000000960, showing bulls still in control. If this zone holds, another breakout attempt looks possible....',
          price: '0.00000964',
          change: '+5.01%',
          pnl: '+\$2,739.22',
          pnlPercent: '+15731.74%',
          chartData: [0.2, 0.3, 0.25, 0.4, 0.8, 0.9, 0.7],
        ),
        const SizedBox(height: 16),
        _buildBreakingNewsCard(),
      ],
    );
  }

  Widget _buildPostCard({
    required String author,
    required String time,
    required String badge,
    required String content,
    required String price,
    required String change,
    required String pnl,
    required String pnlPercent,
    required List<double> chartData,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 16, color: Colors.blue),
                        ],
                      ),
                      Text('$time  $badge', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(change, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: CustomPaint(
                      painter: ChartPainter(chartData),
                      child: Container(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text('My 30 Days\' PNL', style: TextStyle(fontSize: 12)),
                        Text(pnl, style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(pnlPercent, style: const TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.comment_outlined, '2'),
                _buildActionButton(Icons.thumb_up_outlined, '38'),
                _buildActionButton(Icons.repeat, '2'),
                _buildActionButton(Icons.share_outlined, '0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakingNewsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Mariana is coming wrght', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('34m', style: TextStyle(color: Colors.grey, fontSize: 12)),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 8),
            const Text('🚨 BREAKING NEWS: The probability of a Fed rate cut in October has skyrocketed to 96.7% 😱🔥'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Following Tab
class FollowingTab extends StatelessWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final creators = [
      'Yi He', 'Richard Teng', 'CZ', 'Faruk Abubakar',
      'Meat Memed', 'Chumba Money', 'CeM BNB', 'CryptoGhost',
      'NFTgators', 'BitcoinKE'
    ];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Don\'t Miss', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Follow your favorite creators and read their posts on this page.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: creators.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text(creators[index], style: const TextStyle(fontWeight: FontWeight.bold))),
                        const Icon(Icons.check_circle, color: Colors.black),
                        const SizedBox(width: 8),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Follow (10)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

// News Tab
class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = [
      {'time': '11:13', 'title': 'OpenAI Surpasses SpaceX as World\'s Most Valuable Startup'},
      {'time': '08:33', 'title': 'U.S. Senate Delays Vote on Government Funding Bill Amid Stalemate'},
      {'time': '08:23', 'title': 'Trump Urges Republicans to Address Government Waste Amid Shutdown'},
      {'time': '08:13', 'title': 'Polymarket Set to Reopen for U.S. Users After Regulatory Ban'},
      {'time': '08:10', 'title': 'Sui Group Holdings to Launch Synthetic Dollar Token'},
      {'time': '08:10', 'title': 'Avalanche Treasury Co. Announces Major Business Merger with Mountain Lake Acquisition Corp.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: news.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('◆ Oct 2 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );
        }
        final item = news[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  ),
                  Container(width: 2, height: 60, color: Colors.grey[300]),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(item['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Academy Tab
class AcademyTab extends StatelessWidget {
  const AcademyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategory(Icons.grid_view, 'Blockchain'),
            _buildCategory(Icons.image, 'NFT'),
            _buildCategory(Icons.account_balance, 'DeFi'),
            _buildCategory(Icons.security, 'Security'),
            _buildCategory(Icons.show_chart, 'Trading'),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Top Picks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildArticleCard('A Beginner\'s Guide to Cryptocurrency Trading'),
        const SizedBox(height: 24),
        const Text('Trending Articles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTrendingItem('What Is Injective (INJ)?'),
        _buildTrendingItem('What Is OpenEden (EDEN)?'),
        _buildTrendingItem('What Is Falcon Finance (FF)?'),
      ],
    );
  }

  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildArticleCard(String title) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTrendingItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                const Text('Altcoin', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

// Moments Tab
class MomentsTab extends StatelessWidget {
  const MomentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLiveCard('3,946', 'well come 🤝 and enjoy 😜😃', 'Zain_Global', '3h', '1.9K'),
        const SizedBox(height: 16),
        _buildLiveCard('539', 'Sharing Crypto Knowledge', 'Malik Shabi ul Hassan', '1h', '196'),
      ],
    );
  }

  Widget _buildLiveCard(String viewers, String message, String author, String time, String comments) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('🎙️ LIVE', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 80,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(viewers, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎙️ $message', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(author, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Text(time, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    const Icon(Icons.comment_outlined, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(comments, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Darcey Sulin QvOJ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Text('@Square-Creator-4991cd7acd0ba', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('0 Following', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 24),
              Text('0 Followers', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Features', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildFeature(Icons.article_outlined, 'Content'),
              _buildFeature(Icons.school_outlined, 'Creator\nAcademy'),
              _buildFeature(Icons.show_chart, 'Data center'),
              _buildFeature(Icons.edit_outlined, 'Write to earn'),
              _buildFeature(Icons.bookmark_outline, 'Bookmarked\nand Liked'),
              _buildFeature(Icons.calendar_today_outlined, 'Task Center'),
              _buildFeature(Icons.visibility_outlined, 'Browse History'),
              _buildFeature(Icons.create_outlined, 'CreatorPad', isNew: true),
            ],
          ),
          const SizedBox(height: 24),
          const Text('What\'s Happening?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Trends For You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        onPressed: () {},
        child: const Icon(Icons.edit, color: Colors.black),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label, {bool isNew = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28),
            ),
            if (isNew)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('New', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

// Custom Chart Painter
class ChartPainter extends CustomPainter {
  final List<double> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}