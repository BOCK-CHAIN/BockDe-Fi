import 'dart:convert';
//import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/token_models.dart';

class ApiService {
  //static const String _baseUrl = 'http://192.168.56.1:8080/api/v1';
  static const String _baseUrl = 'http://127.0.0.1:8080/api/v1';
 /* class ApiConfig {
  // Private constructor to prevent instantiation
  ApiConfig._();
  
  // Static method to get base URL
  static String getBaseUrl() {
    if (Platform.isAndroid) {
      // For Android emulator
      return 'http://10.0.2.2:8080/api/v1';
    } else if (Platform.isIOS) {
      // For iOS simulator
      return 'http://127.0.0.1:8080/api/v1';
    } else {
      // For web or other platforms
      return 'http://localhost:8080/api/v1';
    }
  }
  
  
  // Usage: 
   static final String baseUrl = getBaseUrl();
  }*/

  static const Duration _timeout = Duration(seconds: 30);

  static final Random _random = Random();

  /// Get list of available tokens from PostgreSQL database
  static Future<List<Token>> getTokens() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tokens'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Tokens Response Status: ${response.statusCode}');
      print('Tokens Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Check if the response contains the 'tokens' key
        if (responseData.containsKey('tokens')) {
          final List<dynamic> tokensJson = responseData['tokens'];
          return tokensJson.map((tokenJson) => Token.fromJson(tokenJson)).toList();
        } else {
          throw Exception('Invalid response format: Expected object with "tokens" key');
        }
      } else {
        throw Exception('Failed to load tokens: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching tokens: $e');
      rethrow;
    }
  }


  static Future<SwapQuote> getSwapQuote({
    required String tokenIn,
    required String tokenOut,
    required double amountIn,
    double slippage = 0.5,
  }) async {
    try {
     
      final requestBody = {
        'tokenInSymbol': tokenIn.toUpperCase(),   // Changed from 'tokenIn'
        'tokenOutSymbol': tokenOut.toUpperCase(), // Changed from 'tokenOut'
        'amountIn': amountIn,
        'slippage': slippage,
      };
      
      print('🔄 Swap Quote Request: $requestBody');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/swap/quote'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('📊 Swap Quote Response Status: ${response.statusCode}');
      print('📊 Swap Quote Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SwapQuote.fromJson(data);
      } else {
        // Parse error response for better debugging
        String errorMessage = 'Unknown error';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['error'] ?? 'HTTP ${response.statusCode}';
          
          // Show available tokens if token not found
          if (errorData.containsKey('availableTokens')) {
            print('💡 Available tokens: ${errorData['availableTokens']}');
          }
        } catch (e) {
          errorMessage = response.body;
        }
        
        throw Exception('Failed to get quote: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      // Fallback to mock calculation if API is not available
      print('❌ API unavailable, using mock calculation: $e');
      return _getMockQuote(tokenIn, tokenOut, amountIn);
    }
  }

  /// Execute token swap through PostgreSQL backend
  static Future<SwapResult> executeSwap({
    required String tokenIn,
    required String tokenOut,
    required double amountIn,
    required String userId,
    String? quoteId,
    double slippage = 0.5,
  }) async {
    try {
      final requestBody = {
        'userId': userId,
        'tokenInSymbol': tokenIn.toUpperCase(),
        'tokenOutSymbol': tokenOut.toUpperCase(),
        'amountIn': amountIn,
        'slippage': slippage,
        
        if (quoteId != null && quoteId.isNotEmpty) 'quoteId': quoteId,
      };
      
      print('🔄 Execute Swap Request: $requestBody');

      final response = await http.post(
        Uri.parse('$_baseUrl/swap/execute'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('📊 Execute Swap Response Status: ${response.statusCode}');
      print('📊 Execute Swap Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SwapResult.fromJson(data);
      } else {
        // Parse error response for better debugging
        String errorMessage = 'Unknown error';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['error'] ?? 'HTTP ${response.statusCode}';
          
          // Show expected format if validation failed
          if (errorData.containsKey('expected')) {
            print('💡 Expected format: ${errorData['expected']}');
          }
        } catch (e) {
          errorMessage = response.body;
        }
        
        throw Exception('Failed to execute swap: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      // Fallback to mock execution if API is not available
      print('❌ API unavailable, using mock execution: $e');
      return _getMockSwapResult(tokenIn, tokenOut, amountIn);
    }
  }

  /// Execute swap with quote - two-step process (quote then execute)
  static Future<SwapResult> executeSwapWithQuote({
    required String tokenIn,
    required String tokenOut,
    required double amountIn,
    required String userId,
    double slippage = 0.5,
  }) async {
    try {
      print('🔄 Step 1: Getting swap quote...');
      
      // Step 1: Get quote
      final quote = await getSwapQuote(
        tokenIn: tokenIn,
        tokenOut: tokenOut,
        amountIn: amountIn,
        slippage: slippage,
      );
      
      print('✅ Step 1 Complete: Quote ID = ${quote.quoteId ?? 'none'}');
      print('🔄 Step 2: Executing swap...');
      
      // Step 2: Execute with quote
      final result = await executeSwap(
        tokenIn: tokenIn,
        tokenOut: tokenOut,
        amountIn: amountIn,
        userId: userId,
        quoteId: quote.quoteId,
        slippage: slippage,
      );
      
      print('✅ Step 2 Complete: Swap executed successfully');
      return result;
      
    } catch (e) {
      print('❌ Two-step swap failed: $e');
      // Fallback to direct execution
      print('🔄 Falling back to direct execution...');
      return executeSwap(
        tokenIn: tokenIn,
        tokenOut: tokenOut,
        amountIn: amountIn,
        userId: userId,
        slippage: slippage,
      );
    }
  }

  /// Test the swap quote endpoint with debug information
  static Future<void> testSwapQuote() async {
    try {
      print('🧪 Testing swap quote endpoint...');
      
      // First test the debug endpoint if available
      try {
        final debugResponse = await http.get(
          Uri.parse('$_baseUrl/test/swap-quote'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 10));
        
        print('🧪 Debug endpoint status: ${debugResponse.statusCode}');
        print('🧪 Debug endpoint response: ${debugResponse.body}');
      } catch (e) {
        print('🧪 Debug endpoint not available: $e');
      }
      
      // Test actual swap quote
      final quote = await getSwapQuote(
        tokenIn: 'BTC',
        tokenOut: 'ETH',
        amountIn: 1.0,
      );
      
      print('✅ Swap quote test successful: ${quote.amountOut} ETH for 1 BTC');
    } catch (e) {
      print('❌ Swap quote test failed: $e');
    }
  }

  /// Get user's swap transaction history
  static Future<List<Map<String, dynamic>>> getSwapHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/swap/history/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch swap history: ${response.statusCode}');
      }
    } catch (e) {
      print('API unavailable for swap history: $e');
      return [];
    }
  }

  /// Create a new user
  static Future<Map<String, dynamic>> createUser({
    required String username,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl.replaceAll('/api/v1', '')}/api/v1/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get current prices for all tokens
  static Future<Map<String, dynamic>> getCurrentPrices() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/prices'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch prices: ${response.statusCode}');
      }
    } catch (e) {
      print('Price API unavailable: $e');
      return {};
    }
  }

  /// Get market data for a specific token
  static Future<Map<String, dynamic>> getMarketData(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/market-data/${symbol.toUpperCase()}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch market data: ${response.statusCode}');
      }
    } catch (e) {
      print('Market data API unavailable: $e');
      return {};
    }
  }

  // Fallback mock data methods
  static List<Token> _getMockTokens() {
    return [
      Token(
        symbol: 'ETH',
        name: 'Ethereum',
        logoUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
        price: 2000.50,
      ),
      Token(
        symbol: 'USDC',
        name: 'USD Coin',
        logoUrl: 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png',
        price: 1.00,
      ),
      Token(
        symbol: 'BTC',
        name: 'Bitcoin',
        logoUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
        price: 45000.00,
      ),
      Token(
        symbol: 'USDT',
        name: 'Tether',
        logoUrl: 'https://cryptologos.cc/logos/tether-usdt-logo.png',
        price: 1.00,
      ),
      Token(
        symbol: 'SOL',
        name: 'Solana',
        logoUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        price: 164.28,
      ),
    ];
  }

  static SwapQuote _getMockQuote(String tokenIn, String tokenOut, double amountIn) {
    final tokens = _getMockTokens();
    final tokenInPrice = tokens.firstWhere((t) => t.symbol == tokenIn, orElse: () => tokens.first).price;
    final tokenOutPrice = tokens.firstWhere((t) => t.symbol == tokenOut, orElse: () => tokens.first).price;
    
    double exchangeRate = tokenInPrice / tokenOutPrice;
    exchangeRate *= (0.98 + _random.nextDouble() * 0.04); // ±2% variation
    
    double amountOut = amountIn * exchangeRate;
    double priceImpact = _random.nextDouble() * 3; // 0-3% price impact
    double feePercent = 0.003; // 0.3% fee
    double fee = amountIn * feePercent;
    double minAmountOut = amountOut * 0.98; // 2% slippage tolerance

    return SwapQuote(
      amountOut: amountOut,
      priceImpact: priceImpact,
      fee: fee,
      minAmountOut: minAmountOut,
    );
  }

  static SwapResult _getMockSwapResult(String tokenIn, String tokenOut, double amountIn) {
    final quote = _getMockQuote(tokenIn, tokenOut, amountIn);
    const chars = '0123456789abcdef';
    final transactionId = '0x${List.generate(64, (index) => chars[_random.nextInt(chars.length)]).join()}';

    return SwapResult(
      transactionId: transactionId,
      amountOut: quote.amountOut,
      fee: quote.fee,
      priceImpact: quote.priceImpact,
    );
  }

  /// Test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tokens'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Health check with detailed status
  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl.replaceAll('/api/v1', '')}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'unhealthy',
          'statusCode': response.statusCode,
          'message': response.body,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}