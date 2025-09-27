class Token {
  final String symbol;
  final String name;
  final String logoUrl;
  final double price;

  Token({
    required this.symbol,
    required this.name,
    required this.logoUrl,
    required this.price,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'logoUrl': logoUrl,
      'price': price,
    };
  }
}

class SwapQuote {
final double amountOut;
  final double priceImpact;
  final double fee;
  final double minAmountOut;
  final double? exchangeRate;
  final double? slippage;
  final String? quoteId;        
  final int? validUntil;        
  final List<Token>? route;
  SwapQuote({
    required this.amountOut,
    required this.priceImpact,
    required this.fee,
    required this.minAmountOut,
    this.exchangeRate,
    this.slippage,
    this.quoteId,
    this.validUntil,
    this.route,
  });

  factory SwapQuote.fromJson(Map<String, dynamic> json) {
    return SwapQuote(
      amountOut: (json['amountOut'] ?? 0.0).toDouble(),
      priceImpact: (json['priceImpact'] ?? 0.0).toDouble(),
      fee: (json['fee'] ?? 0.0).toDouble(),
      minAmountOut: (json['minAmountOut'] ?? 0.0).toDouble(),
      exchangeRate: json['exchangeRate']?.toDouble(),
      slippage: json['slippage']?.toDouble(),
      quoteId: json['quoteId']?.toString(),
      validUntil: json['validUntil']?.toInt(),
      route: json['route'] != null 
          ? (json['route'] as List)
              .map((tokenJson) => Token.fromJson(tokenJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amountOut': amountOut,
      'priceImpact': priceImpact,
      'fee': fee,
      'minAmountOut': minAmountOut,
      if (exchangeRate != null) 'exchangeRate': exchangeRate,
      if (slippage != null) 'slippage': slippage,
      if (quoteId != null) 'quoteId': quoteId,
      if (validUntil != null) 'validUntil': validUntil,
      if (route != null) 'route': route!.map((token) => token.toJson()).toList(),
    };
  }
}

class SwapResult {
  final String transactionId;
  final double amountOut;
  final double fee;
  final double priceImpact;
  final String? status;
  final DateTime? executedAt;
  final String? message;

  SwapResult({
    required this.transactionId,
    required this.amountOut,
    required this.fee,
    required this.priceImpact,
    this.status,
    this.executedAt,
    this.message,
  });

   factory SwapResult.fromJson(Map<String, dynamic> json) {
    return SwapResult(
      transactionId: json['transactionId']?.toString() ?? 
                    json['txHash']?.toString() ?? 
                    'unknown',
      amountOut: (json['amountOut'] ?? 0.0).toDouble(),
      fee: (json['fee'] ?? 0.0).toDouble(),
      priceImpact: (json['priceImpact'] ?? 0.0).toDouble(),
      status: json['status']?.toString(),
      executedAt: json['executedAt'] != null 
          ? DateTime.tryParse(json['executedAt'].toString())
          : null,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amountOut': amountOut,
      'fee': fee,
      'priceImpact': priceImpact,
      if (status != null) 'status': status,
      if (executedAt != null) 'executedAt': executedAt!.toIso8601String(),
      if (message != null) 'message': message,
    };
  }
}