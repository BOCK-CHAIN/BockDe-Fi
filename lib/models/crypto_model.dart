class CryptoModel {
  final String symbol;
  final String name;
  final String icon;
  final double price;
  final double changePercent;

  CryptoModel({
    required this.symbol,
    required this.name,
    required this.icon,
    required this.price,
    required this.changePercent,
  });
}

// Sample data
final List<CryptoModel> hotCryptos = [
  CryptoModel(symbol: 'BNB', name: 'Binance Coin', icon: '🟡', price: 849.66, changePercent: -2.42),
  CryptoModel(symbol: 'BTC', name: 'Bitcoin', icon: '🟠', price: 110216.00, changePercent: -1.76),
  CryptoModel(symbol: 'ETH', name: 'Ethereum', icon: '🔵', price: 4531.95, changePercent: -2.85),
];

final List<CryptoModel> topCryptos = [
  CryptoModel(symbol: 'SOL', name: 'Solana', icon: '🟣', price: 250.45, changePercent: 342.00),
  CryptoModel(symbol: 'DOT', name: 'Polkadot', icon: '🔴', price: 45.32, changePercent: -30.00),
  CryptoModel(symbol: 'MATIC', name: 'Polygon', icon: '🟣', price: 2.15, changePercent: -56.00),
  CryptoModel(symbol: 'LUNA', name: 'Terra Luna', icon: '🟡', price: 85.67, changePercent: -67.00),
  CryptoModel(symbol: 'AVAX', name: 'Avalanche', icon: '🔴', price: 120.34, changePercent: 19.00),
];
