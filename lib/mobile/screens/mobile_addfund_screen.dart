import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Models
class Coin {
  final String symbol;
  final String name;
  final String iconUrl;

  Coin({required this.symbol, required this.name, required this.iconUrl});
}

class Network {
  final String id;
  final String name;
  final String fullName;
  final int blockConfirmations;
  final double minDeposit;
  final int estimatedArrival;

  Network({
    required this.id,
    required this.name,
    required this.fullName,
    required this.blockConfirmations,
    required this.minDeposit,
    required this.estimatedArrival,
  });
}

class MobileAddFundScreen extends StatefulWidget {
  const MobileAddFundScreen({Key? key}) : super(key: key);

  @override
  State<MobileAddFundScreen> createState() => _MobileAddFundScreenState();
}

class _MobileAddFundScreenState extends State<MobileAddFundScreen> {
  int currentStep = 0;
  Coin? selectedCoin;
  Network? selectedNetwork;
  String? generatedAddress;
  List<Coin> searchHistory = [];

  // Sample coins data
  final List<Coin> trendingCoins = [
    Coin(symbol: 'BTC', name: 'Bitcoin', iconUrl: '🪙'),
    Coin(symbol: 'ETH', name: 'Ethereum', iconUrl: '💎'),
    Coin(symbol: 'USDT', name: 'TetherUS', iconUrl: '💵'),
    Coin(symbol: 'BNB', name: 'BNB', iconUrl: '🟡'),
  ];

  final List<Coin> allCoins = [
    Coin(symbol: 'BTC', name: 'Bitcoin', iconUrl: '🪙'),
    Coin(symbol: 'ETH', name: 'Ethereum', iconUrl: '💎'),
    Coin(symbol: 'USDT', name: 'TetherUS', iconUrl: '💵'),
    Coin(symbol: 'BNB', name: 'BNB', iconUrl: '🟡'),
    Coin(symbol: '0G', name: '0G', iconUrl: '♾️'),
    Coin(symbol: '1000CAT', name: '1000*Simons Cat', iconUrl: '🐱'),
    Coin(symbol: '1000CHEEMS', name: '1000*cheems.pet', iconUrl: '🐕'),
    Coin(symbol: '1000PEPPER', name: 'PEPPER', iconUrl: '🌶️'),
    Coin(symbol: '1000SATS', name: '1000*SATS (Ordinals)', iconUrl: '💰'),
  ];

  // Sample networks for BTC
  final Map<String, List<Network>> networksByCoin = {
    'BTC': [
      Network(
        id: 'SEGWITBTC',
        name: 'SEGWITBTC',
        fullName: 'BTC(SegWit)',
        blockConfirmations: 1,
        minDeposit: 0.000006,
        estimatedArrival: 1,
      ),
      Network(
        id: 'BTC',
        name: 'BTC',
        fullName: 'Bitcoin',
        blockConfirmations: 1,
        minDeposit: 0.00001,
        estimatedArrival: 1,
      ),
      Network(
        id: 'BSC',
        name: 'BSC',
        fullName: 'BNB Smart Chain (BEP20)',
        blockConfirmations: 1,
        minDeposit: 0.00000002,
        estimatedArrival: 1,
      ),
      Network(
        id: 'LIGHTNING',
        name: 'LIGHTNING',
        fullName: 'Lightning Network',
        blockConfirmations: 1,
        minDeposit: 0.00001999,
        estimatedArrival: 1,
      ),
    ],
    'ETH': [
      Network(
        id: 'ETH',
        name: 'ETH',
        fullName: 'Ethereum (ERC20)',
        blockConfirmations: 12,
        minDeposit: 0.0001,
        estimatedArrival: 2,
      ),
    ],
  };

  String generateAddress(String coinSymbol, String networkId) {
    // Generate a mock address based on coin and network
    if (networkId == 'BTC' || networkId == 'SEGWITBTC') {
      return '15pKwCP6oNDDGpxVBWdrkubZC2awyuhLgN';
    } else if (networkId == 'BSC') {
      return '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';
    } else if (networkId == 'LIGHTNING') {
      return 'lnbc10u1p3pj257pp5yztkwjcvq4k8w7';
    }
    return '15pKwCP6oNDDGpxVBWdrkubZC2awyuhLgN';
  }

  void selectCoin(Coin coin) {
    setState(() {
      selectedCoin = coin;
      selectedNetwork = null;
      generatedAddress = null;
      currentStep = 1;
      
      if (!searchHistory.any((c) => c.symbol == coin.symbol)) {
        searchHistory.insert(0, coin);
        if (searchHistory.length > 5) {
          searchHistory = searchHistory.sublist(0, 5);
        }
      }
    });
  }

  void selectNetwork(Network network) {
    setState(() {
      selectedNetwork = network;
      generatedAddress = generateAddress(selectedCoin!.symbol, network.id);
      currentStep = 2;
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (currentStep > 0) {
              setState(() {
                if (currentStep == 2) {
                  currentStep = 1;
                  generatedAddress = null;
                } else if (currentStep == 1) {
                  currentStep = 0;
                  selectedCoin = null;
                  selectedNetwork = null;
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          currentStep == 0
              ? 'Select Coin'
              : currentStep == 1
                  ? 'Deposit ${selectedCoin?.symbol}'
                  : 'Deposit ${selectedCoin?.symbol}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: currentStep == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.black),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
      body: currentStep == 0
          ? _buildCoinSelection()
          : currentStep == 1
              ? _buildNetworkSelection()
              : _buildDepositDetails(),
    );
  }

  Widget _buildCoinSelection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Coins',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (searchHistory.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () {
                          setState(() {
                            searchHistory.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ...searchHistory.map((coin) => _buildCoinItem(coin)),
                const SizedBox(height: 16),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Trending',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...trendingCoins.map((coin) => _buildCoinItem(coin)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: List.generate(26, (index) {
                    return Expanded(
                      child: Text(
                        String.fromCharCode(65 + index),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              ...allCoins.map((coin) => _buildCoinItem(coin)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoinItem(Coin coin) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange[100],
        child: Text(coin.iconUrl, style: const TextStyle(fontSize: 20)),
      ),
      title: Row(
        children: [
          Text(
            coin.symbol,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      subtitle: Text(
        coin.name,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      onTap: () => selectCoin(coin),
    );
  }

  Widget _buildNetworkSelection() {
    final networks = networksByCoin[selectedCoin!.symbol] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'Choose Network',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: networks.length,
            itemBuilder: (context, index) {
              final network = networks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: InkWell(
                  onTap: () => selectNetwork(network),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              network.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              network.fullName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${network.blockConfirmations} block confirmation/s',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Min. deposit >${network.minDeposit.toStringAsFixed(8)} ${selectedCoin!.symbol}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Est. arrival ${network.estimatedArrival} mins',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: const Color.fromARGB(255, 122, 79, 223)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please note that only supported networks on Binance platform are shown, if you deposit via another network your assets may be lost.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDepositDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'How to deposit? ',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'View guide',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 122, 79, 223),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: QrImageView(
                data: generatedAddress!,
                version: QrVersions.auto,
                size: 200,
                embeddedImage: const AssetImage('assets/btc_icon.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(40, 40),
                ),
                errorStateBuilder: (context, error) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'QR Code',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Network',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      selectedNetwork!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 16),
                          SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  selectedCoin!.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Deposit Address',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          generatedAddress!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () => copyToClipboard(generatedAddress!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Binance supports deposits from all BTC addresses (starting with "1", "3", "bc1p" and "bc1q")',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('More Details'),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// Bottom button
class SaveAndShareButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveAndShareButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Save and Share Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}