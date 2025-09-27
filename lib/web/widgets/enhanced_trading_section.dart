import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/token_models.dart';

class AppColors {
  static const Color primary = Color(0xFFF0B90B);
  static const Color background = Color(0xFF0C0C0C);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color success = Color(0xFF2EBD85);
  static const Color error = Color(0xFFFF4747);
}

class EnhancedTradingSection extends StatefulWidget {
  const EnhancedTradingSection({super.key});

  @override
  State<EnhancedTradingSection> createState() => _EnhancedTradingSectionState();
}

class _EnhancedTradingSectionState extends State<EnhancedTradingSection> {
  final TextEditingController _amountController = TextEditingController();
  final String _userId = "user123"; // In real app, get from auth
  
  List<Token> _tokens = [];
  Token? _fromToken;
  Token? _toToken;
  SwapQuote? _currentQuote;
  bool _isLoading = false;
  bool _isSwapping = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTokens();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadTokens() async {
    try {
      final tokens = await ApiService.getTokens();
      if (mounted) {
        setState(() {
          _tokens = tokens;
          if (_tokens.isNotEmpty) {
            _fromToken = _tokens.firstWhere((t) => t.symbol == 'ETH', orElse: () => _tokens.first);
            _toToken = _tokens.firstWhere((t) => t.symbol == 'USDC', orElse: () => _tokens.length > 1 ? _tokens[1] : _tokens.first);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load tokens: $e';
        });
      }
    }
  }

  void _onAmountChanged() {
    if (_amountController.text.isNotEmpty && _fromToken != null && _toToken != null) {
      _getQuote();
    } else {
      if (mounted) {
        setState(() {
          _currentQuote = null;
        });
      }
    }
  }

  Future<void> _getQuote() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty || _fromToken == null || _toToken == null) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final quote = await ApiService.getSwapQuote(
        tokenIn: _fromToken!.symbol,
        tokenOut: _toToken!.symbol,
        amountIn: amount,
      );

      if (mounted) {
        setState(() {
          _currentQuote = quote;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to get quote: $e';
          _isLoading = false;
          _currentQuote = null;
        });
      }
    }
  }

  Future<void> _executeSwap() async {
    if (_currentQuote == null || _fromToken == null || _toToken == null) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      _isSwapping = true;
      _errorMessage = '';
    });

    try {
      final result = await ApiService.executeSwap(
        tokenIn: _fromToken!.symbol,
        tokenOut: _toToken!.symbol,
        amountIn: amount,
        userId: _userId,
      );

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Swap Successful!',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction ID: ${result.transactionId}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'You received: ${result.amountOut.toStringAsFixed(6)} ${_toToken!.symbol}',
                  style: const TextStyle(color: AppColors.success),
                ),
                Text(
                  'Fee: ${result.fee.toStringAsFixed(6)} ${_fromToken!.symbol}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  'Price Impact: ${result.priceImpact.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: result.priceImpact > 5 ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        );

        // Clear form
        _amountController.clear();
        setState(() {
          _currentQuote = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Swap failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSwapping = false;
        });
      }
    }
  }

  void _swapTokens() {
    setState(() {
      final temp = _fromToken;
      _fromToken = _toToken;
      _toToken = temp;
    });
    _onAmountChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Swap Tokens',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // From token section
          _buildTokenInput(
            label: 'From',
            selectedToken: _fromToken,
            controller: _amountController,
            onTokenChanged: (token) {
              setState(() {
                _fromToken = token;
              });
              _onAmountChanged();
            },
          ),

          const SizedBox(height: 16),

          // Swap button
          Center(
            child: GestureDetector(
              onTap: _swapTokens,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.swap_vert,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // To token section
          _buildTokenOutput(
            label: 'To',
            selectedToken: _toToken,
            outputAmount: _currentQuote?.amountOut,
            onTokenChanged: (token) {
              setState(() {
                _toToken = token;
              });
              _onAmountChanged();
            },
          ),

          if (_isLoading) ...[
            const SizedBox(height: 16),
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ],

          if (_currentQuote != null) ...[
            const SizedBox(height: 16),
            _buildSwapDetails(),
          ],

          if (_errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Swap button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _currentQuote != null && !_isSwapping && !_isLoading
                  ? _executeSwap
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSwapping
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Swap Tokens',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenInput({
    required String label,
    required Token? selectedToken,
    required TextEditingController controller,
    required Function(Token) onTokenChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildTokenSelector(selectedToken, onTokenChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenOutput({
    required String label,
    required Token? selectedToken,
    required double? outputAmount,
    required Function(Token) onTokenChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  outputAmount?.toStringAsFixed(6) ?? '0.0',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildTokenSelector(selectedToken, onTokenChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSelector(Token? selectedToken, Function(Token) onTokenChanged) {
    return GestureDetector(
      onTap: () => _showTokenSelector(onTokenChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedToken?.logoUrl.isNotEmpty == true)
              Image.network(
                selectedToken!.logoUrl,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.currency_bitcoin, size: 20, color: AppColors.primary),
              )
            else
              const Icon(Icons.currency_bitcoin, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              selectedToken?.symbol ?? 'Select',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapDetails() {
    if (_currentQuote == null || _fromToken == null || _toToken == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow('Price Impact', '${_currentQuote!.priceImpact.toStringAsFixed(2)}%'),
          _buildDetailRow('Liquidity Fee', '${_currentQuote!.fee.toStringAsFixed(6)} ${_fromToken!.symbol}'),
          _buildDetailRow('Minimum Received', '${_currentQuote!.minAmountOut.toStringAsFixed(6)} ${_toToken!.symbol}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showTokenSelector(Function(Token) onTokenChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Token',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _tokens.length,
                itemBuilder: (context, index) {
                  final token = _tokens[index];
                  return ListTile(
                    leading: token.logoUrl.isNotEmpty
                        ? Image.network(
                            token.logoUrl,
                            width: 32,
                            height: 32,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.currency_bitcoin, size: 32, color: AppColors.primary),
                          )
                        : const Icon(Icons.currency_bitcoin, size: 32, color: AppColors.primary),
                    title: Text(
                      token.name,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      token.symbol,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Text(
                      '\$${token.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      onTokenChanged(token);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}