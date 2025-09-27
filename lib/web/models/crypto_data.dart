class CryptoData {
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double changePercent24h;
  final String icon;

  CryptoData({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.icon,
  });

  bool get isPositive => changePercent24h > 0;
}

// Sample data
class SampleData {
  static List<CryptoData> getCryptoList() {
    return [
      CryptoData(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 43250.50,
        change24h: 1250.30,
        changePercent24h: 2.98,
        icon: '₿',
      ),
      CryptoData(
        symbol: 'ETH',
        name: 'Ethereum',
        price: 2580.75,
        change24h: -45.20,
        changePercent24h: -1.72,
        icon: 'Ξ',
      ),
      CryptoData(
        symbol: 'BNB',
        name: 'BNB',
        price: 315.40,
        change24h: 12.80,
        changePercent24h: 4.23,
        icon: 'BNB',
      ),
      CryptoData(
        symbol: 'ADA',
        name: 'Cardano',
        price: 0.4521,
        change24h: 0.0234,
        changePercent24h: 5.46,
        icon: 'ADA',
      ),
      CryptoData(
        symbol: 'SOL',
        name: 'Solana',
        price: 98.32,
        change24h: -3.45,
        changePercent24h: -3.39,
        icon: 'SOL',
      ),
    ];
  }
}