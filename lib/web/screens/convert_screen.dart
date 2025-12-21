import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:web/web.dart' as web;
import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';

import 'package:web3dart/web3dart.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({Key? key}) : super(key: key);

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  String fromCurrency = 'ETH';
  String toCurrency = 'USDT';
  double availableFromBalance = 0.0;
  double availableToBalance = 0.0;
  double conversionRate = 2500.0;
  TextEditingController amountController = TextEditingController();
  Timer? _timer;
  String convertedAmount = '0.00';
  bool isLoading = false;
  
  // MetaMask Web3 Integration
  String? _connectedAddress;
  bool _isConnecting = false;
  Web3Client? _web3client;
  List<Map<String, dynamic>> _transactionHistory = [];
  
  final String _rpcUrl = 'https://sepolia.infura.io/v3/67e0fe82bbe141469c0b27ca7546b91a';

  final Map<String, Color> cryptoColors = {
    'ETH': const Color(0x627EEA),
    'USDT': Colors.green,
    'BTC': const Color(0xFFF7931A),
    'BNB': const Color(0xFFF0B90B),
    'USDC': const Color(0xFF2775CA),
  };

  final List<String> availableCurrencies = ['ETH', 'USDT', 'BTC', 'BNB', 'USDC'];

  @override
  void initState() {
    super.initState();
    _initWeb3();
    calculateConversion();
    fetchConversionRate();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        fetchConversionRate();
        if (_connectedAddress != null) {
          _updateBalance();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    amountController.dispose();
    _web3client?.dispose();
    super.dispose();
  }

  void _initWeb3() {
    _web3client = Web3Client(_rpcUrl, http.Client());
  }

  bool _isMetaMaskInstalled() {
    return web.window.hasProperty('ethereum'.toJS).toDart;
  }

  Future<void> _connectMetaMask() async {
    if (!_isMetaMaskInstalled()) {
      _showMetaMaskNotInstalledDialog();
      return;
    }

    setState(() => _isConnecting = true);

    try {
      final accounts = await _requestAccounts();
      
      if (accounts.isNotEmpty) {
        setState(() {
          _connectedAddress = accounts[0];
          _isConnecting = false;
        });
        
        await _updateBalance();
        await _loadTransactionHistory();
        _listenToAccountChanges();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connected: ${_connectedAddress!.substring(0, 6)}...${_connectedAddress!.substring(_connectedAddress!.length - 4)}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isConnecting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<List<String>> _requestAccounts() async {
    try {
     final result = web.window.callMethod(
  'eval'.toJS,
  <js.JSAny?>[
    '(async () => { const accounts = await window.ethereum.request({ method: "eth_requestAccounts" }); return accounts; })()'
        .toJS
  ].toJS
);

      return List<String>.from(result as Iterable);
    } catch (e) {
      print('Error requesting accounts: $e');
      return [];
    }
  }

  Future<void> _updateBalance() async {
    if (_connectedAddress == null || _web3client == null) return;

    try {
      final address = EthereumAddress.fromHex(_connectedAddress!);
      final balance = await _web3client!.getBalance(address);
      
      if (mounted) {
        setState(() {
          availableFromBalance = balance.getInWei / BigInt.from(10).pow(18);
        });
      }
    } catch (e) {
      print('Error updating balance: $e');
    }
  }

  void _listenToAccountChanges() {
    web.window.callMethod(
  'eval'.toJS,
  <js.JSAny?>[
    '''
    window.ethereum.on('accountsChanged', (accounts) => {
      if (accounts.length === 0) {
        console.log('Disconnected');
      }
    });
    '''
        .toJS
  ].toJS
);

  }

  Future<String?> _sendTransaction() async {
    if (_connectedAddress == null) return null;

    try {
      final amount = double.tryParse(amountController.text) ?? 0;
      if (amount <= 0) return null;

      final weiAmount = (amount * 1e18).toInt();
      final hexAmount = '0x${weiAmount.toRadixString(16)}';

      final txHash = (web.window.callMethod(
  'eval'.toJS,        // ← MUST convert method name to JSAny
  [
    '''
    (async () => {
      const tx = {
        from: '$_connectedAddress',
        to: '$_connectedAddress',
        value: '$hexAmount',
        chainId: '0xaa36a7'
      };
      return await window.ethereum.request({
        method: 'eth_sendTransaction',
        params: [tx],
      });
    })()
    '''.toJS
  ].toJS              // ← MUST convert whole list to JS array
) as js.JSAny)
    .dartify();





      return txHash.toString();
    } catch (e) {
      print('Error sending transaction: $e');
      return null;
    }
  }

  Future<void> _loadTransactionHistory() async {
    if (_connectedAddress == null) return;

    try {
      final url = 'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$_connectedAddress&startblock=0&endblock=99999999&page=1&offset=10&sort=desc';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == '1' && data['result'] != null) {
          if (mounted) {
            setState(() {
              _transactionHistory = List<Map<String, dynamic>>.from(data['result']);
            });
          }
        }
      }
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  void _disconnectWallet() {
    setState(() {
      _connectedAddress = null;
      availableFromBalance = 0.0;
      _transactionHistory = [];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet disconnected'), behavior: SnackBarBehavior.floating),
    );
  }

  void _showMetaMaskNotInstalledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text('MetaMask Not Found', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text('Please install MetaMask browser extension.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              web.window.open('https://metamask.io/download/', '_blank');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7645D9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Install', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> fetchConversionRate() async {
    if (!mounted) return;
    
    try {
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=ethereum,tether,bitcoin&vs_currencies=usd'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          if (fromCurrency == 'ETH' && toCurrency == 'USDT') {
            conversionRate = data['ethereum']['usd'].toDouble();
          } else if (fromCurrency == 'USDT' && toCurrency == 'ETH') {
            conversionRate = 1 / data['ethereum']['usd'];
          } else {
            conversionRate = 2500.0;
          }
          calculateConversion();
        });
      }
    } catch (e) {
      if (mounted) setState(() => conversionRate = 2500.0);
    }
  }

  void calculateConversion() {
    if (amountController.text.isEmpty) {
      setState(() => convertedAmount = '0.00');
      return;
    }
    
    double amount = double.tryParse(amountController.text) ?? 0;
    double result = amount * conversionRate;
    
    setState(() {
      convertedAmount = toCurrency == 'BTC' ? result.toStringAsFixed(8) : result.toStringAsFixed(2);
    });
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      
      double tempBalance = availableFromBalance;
      availableFromBalance = availableToBalance;
      availableToBalance = tempBalance;
      
      conversionRate = 1 / conversionRate;
      calculateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final horizontalPadding = isDesktop ? 55.0 : (isTablet ? 24.0 : 16.0);
    
    return Scaffold(
      backgroundColor: const Color(0xFF08060B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF08060B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Swap', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          if (_connectedAddress != null) ...[
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white70),
              onPressed: _showTransactionHistory,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      '${_connectedAddress!.substring(0, 6)}...${_connectedAddress!.substring(_connectedAddress!.length - 4)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _disconnectWallet,
                      child: const Icon(Icons.logout, size: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: _isConnecting ? null : _connectMetaMask,
                icon: _isConnecting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : const Icon(Icons.account_balance_wallet, size: 16),
                label: Text(_isConnecting ? 'Connecting...' : 'Connect Wallet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7645D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white70), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isDesktop ? 24 : 16),

                if (_connectedAddress != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('MetaMask Connected', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Balance: ${availableFromBalance.toStringAsFixed(6)} ETH', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.refresh, color: Colors.white70, size: 20), onPressed: _updateBalance),
                      ],
                    ),
                  ),

                _buildCurrencyContainer(title: 'From', currency: fromCurrency, balance: availableFromBalance, isFrom: true, isDesktop: isDesktop),
                
                SizedBox(height: isDesktop ? 12 : 8),
                
                Center(
                  child: GestureDetector(
                    onTap: swapCurrencies,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF27262C), width: 2),
                      ),
                      child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF7645D9), size: 24),
                    ),
                  ),
                ),
                
                SizedBox(height: isDesktop ? 12 : 8),

                _buildCurrencyContainer(title: 'To', currency: toCurrency, balance: availableToBalance, isFrom: false, isDesktop: isDesktop),
                
                SizedBox(height: isDesktop ? 24 : 20),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1D25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF27262C)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Price', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text('1 $fromCurrency = ${conversionRate.toStringAsFixed(2)} $toCurrency', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Slippage', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text('0.5%', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Network', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text('Sepolia', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isDesktop ? 24 : 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canConvert() && _connectedAddress != null ? _showConvertDialog : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canConvert() && _connectedAddress != null ? const Color(0xFF7645D9) : const Color(0xFF27262C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      _connectedAddress == null ? 'Connect Wallet' : amountController.text.isEmpty ? 'Enter amount' : 'Swap',
                      style: TextStyle(
                        color: _canConvert() && _connectedAddress != null ? Colors.white : Colors.white30,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyContainer({required String title, required String currency, required double balance, required bool isFrom, required bool isDesktop}) {
    final containerPadding = isDesktop ? 20.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27262C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('Balance: ${balance.toStringAsFixed(6)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildCurrencySelector(currency),
              const SizedBox(width: 12),
              Expanded(
                child: isFrom 
                  ? TextField(
                      controller: amountController,
                      onChanged: (value) => calculateConversion(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(hintText: '0.0', hintStyle: TextStyle(color: Color(0xFF52555E)), border: InputBorder.none),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                    )
                  : Text(convertedAmount, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
              ),
            ],
          ),
          if (isFrom) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buildMaxButton()],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(String currency) {
    return GestureDetector(
      onTap: () => _showCurrencyPicker(currency == fromCurrency),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF27262C), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(color: cryptoColors[currency] ?? Colors.grey, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(currency, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxButton() {
    return GestureDetector(
      onTap: () {
        if (_connectedAddress != null && availableFromBalance > 0) {
          final maxAmount = availableFromBalance - 0.001;
          if (maxAmount > 0) {
            amountController.text = maxAmount.toStringAsFixed(6);
            calculateConversion();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF7645D9).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF7645D9).withOpacity(0.5)),
        ),
        child: const Text('MAX', style: TextStyle(color: Color(0xFF7645D9), fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  bool _canConvert() {
    if (amountController.text.isEmpty) return false;
    double? amount = double.tryParse(amountController.text);
    return amount != null && amount > 0;
  }

  void _showCurrencyPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D25),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF52555E), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Select a token', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...availableCurrencies.map((currency) => InkWell(
              onTap: () {
                setState(() {
                  if (isFrom) {
                    fromCurrency = currency;
                  } else {
                    toCurrency = currency;
                  }
                });
                fetchConversionRate();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: const Color(0xFF27262C), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(width: 32, height: 32, decoration: BoxDecoration(color: cryptoColors[currency] ?? Colors.grey, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Text(currency, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showConvertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Confirm Swap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF27262C), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('From', style: TextStyle(color: Colors.white70)),
                      Text('${amountController.text} $fromCurrency', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Icon(Icons.arrow_downward, color: Color(0xFF7645D9)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('To', style: TextStyle(color: Colors.white70)),
                      Text('$convertedAmount $toCurrency', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(child: Text('MetaMask will open to approve', style: TextStyle(color: Colors.blue, fontSize: 11))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _executeSwap();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7645D9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _executeSwap() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7645D9)))),
            SizedBox(height: 20),
            Text('Processing Swap', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Approve in MetaMask', style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    try {
      final txHash = await _sendTransaction();
      Navigator.pop(context);

      if (txHash != null) {
        await _updateBalance();
        await _loadTransactionHistory();
        amountController.clear();
        calculateConversion();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1D25),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Swap Submitted!', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Transaction submitted successfully', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF27262C), borderRadius: BorderRadius.circular(8)),
                  child: SelectableText(txHash, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace')),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    web.window.open('https://sepolia.etherscan.io/tx/$txHash', '_blank');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('View on Etherscan', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showTransactionHistory();
                },
                child: const Text('View History', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7645D9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Transaction failed');
      }
    } catch (e) {
      Navigator.pop(context);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1D25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Swap Failed', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text('Transaction failed: $e', style: const TextStyle(color: Colors.white70)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7645D9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _showTransactionHistory() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1D25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transaction History', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 20),
              if (_transactionHistory.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 60, color: Colors.white30),
                        SizedBox(height: 16),
                        Text('No transactions yet', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _transactionHistory.length,
                    itemBuilder: (context, index) {
                      final tx = _transactionHistory[index];
                      final isSent = tx['from'].toString().toLowerCase() == _connectedAddress!.toLowerCase();
                      final value = BigInt.parse(tx['value'].toString());
                      final ethValue = (value / BigInt.from(10).pow(18)).toStringAsFixed(6);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF27262C), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(isSent ? Icons.arrow_upward : Icons.arrow_downward, color: isSent ? Colors.red : Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Text(isSent ? 'Sent' : 'Received', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text('${isSent ? '-' : '+'} $ethValue ETH', style: TextStyle(color: isSent ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('${isSent ? 'To' : 'From'}: ${tx[isSent ? 'to' : 'from'].toString().substring(0, 10)}...', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatTimestamp(int.parse(tx['timeStamp'].toString())), style: const TextStyle(color: Colors.white30, fontSize: 11)),
                                GestureDetector(
                                  onTap: () {
                                    web.window.open('https://sepolia.etherscan.io/tx/${tx['hash']}', '_blank');
                                  },
                                  child: const Row(
                                    children: [
                                      Text('View', style: TextStyle(color: Color(0xFF7645D9), fontSize: 12)),
                                      SizedBox(width: 4),
                                      Icon(Icons.open_in_new, size: 12, color: Color(0xFF7645D9)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}