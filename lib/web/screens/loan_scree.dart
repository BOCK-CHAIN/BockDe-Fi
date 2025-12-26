import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final TextEditingController _collateralController = TextEditingController();
  final TextEditingController _borrowController = TextEditingController();
  String selectedCollateral = 'BNB';
  String selectedBorrow = 'BTC';
  bool _agreedToTerms = false;

  // Mock data for loan rates - in real app, this would come from API
  final List<Map<String, dynamic>> _loanData = [
    {
      'coin': 'BTC',
      'icon': '₿',
      'hourlyRate': '0.000125%',
      'annualRate': '1.095%',
      'color': Colors.orange,
    },
    {
      'coin': 'ETH',
      'icon': 'Ξ',
      'hourlyRate': '0.000137%',
      'annualRate': '1.201%',
      'color': Colors.blue,
    },
    {
      'coin': 'BNB',
      'icon': 'B',
      'hourlyRate': '0.000104%',
      'annualRate': '0.912%',
      'color': Colors.yellow[700]!,
    },
    {
      'coin': 'USDT',
      'icon': '₮',
      'hourlyRate': '0.000083%',
      'annualRate': '0.727%',
      'color': Colors.green,
    },
    {
      'coin': 'USDC',
      'icon': '\$',
      'hourlyRate': '0.000079%',
      'annualRate': '0.692%',
      'color': Colors.blue[600]!,
    },
    {
      'coin': 'ADA',
      'icon': '₳',
      'hourlyRate': '0.000146%',
      'annualRate': '1.279%',
      'color': Colors.indigo,
    },
    {
      'coin': 'DOT',
      'icon': '●',
      'hourlyRate': '0.000152%',
      'annualRate': '1.331%',
      'color': Colors.pink,
    },
    {
      'coin': 'SOL',
      'icon': '◎',
      'hourlyRate': '0.000134%',
      'annualRate': '1.174%',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        title: Text(
          'Borrow Market',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header with search
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2329),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF2B3139)),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2329),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2B3139)),
              ),
              child: Column(
                children: [
                  // Table header - hide on mobile, show as cards instead
                  if (!isMobile) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF2B3139)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Loanable Coin',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Hourly Interest Rate',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Annual Interest Rate',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Table rows
                  Expanded(
                    child: ListView.builder(
                      itemCount: _loanData.length,
                      itemBuilder: (context, index) {
                        final item = _loanData[index];
                        
                        if (isMobile) {
                          // Mobile card layout
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2B3139),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF3C4142)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: item['color'],
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: Text(
                                              item['icon'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          item['coin'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _showBorrowDialog(context, item['coin']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size(70, 32),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Borrow',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hourly Rate',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['hourlyRate'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Annual Rate',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['annualRate'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Desktop table layout
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: index < _loanData.length - 1
                                  ? const Border(
                                      bottom: BorderSide(color: Color(0xFF2B3139)),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: item['color'],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item['icon'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        item['coin'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item['hourlyRate'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item['annualRate'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () => _showBorrowDialog(context, item['coin']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size(60, 32),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Borrow',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showBorrowDialog(BuildContext context, String coin) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF1E2329),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: isMobile 
                  ? const EdgeInsets.all(16) 
                  : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Container(
                width: isMobile ? double.infinity : 500,
                constraints: isMobile ? BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ) : null,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Borrow Flexible Rate Loan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 18 : 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Warning message
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline, color: Color.fromARGB(255, 122, 79, 223), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'To adjust your Loan-To-Value ratio manually, please enter the preferred collateral amount and borrowing amount to lower the risk of liquidation.',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: isMobile ? 13 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Collateral section
                        Text(
                          'Collateral',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF3C4142)),
                          ),
                          child: isMobile 
                              ? Column(
                                  children: [
                                    TextField(
                                      controller: _collateralController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Amount',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(12),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Color(0xFF3C4142)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Max',
                                            style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 122, 79, 223),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'B',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'BNB',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _collateralController,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Amount',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(12),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: Color(0xFF3C4142)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Max',
                                            style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 122, 79, 223),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'B',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'BNB',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning_amber_outlined, color: Color.fromARGB(255, 122, 79, 223), size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Collateralized BNB assets will not be eligible for Launchpool rewards.',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: isMobile ? 11 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Borrow section
                        Text(
                          'I want to borrow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B3139),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF3C4142)),
                          ),
                          child: isMobile
                              ? Column(
                                  children: [
                                    TextField(
                                      controller: _borrowController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Amount',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(12),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Color(0xFF3C4142)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 122, 79, 223),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '₿',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            coin,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _borrowController,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Amount',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(12),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: Color(0xFF3C4142)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 122, 79, 223),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '₿',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            coin,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Current LTV
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current LTV',
                              style: TextStyle(color: Colors.white, fontSize: isMobile ? 15 : 16),
                            ),
                            Text(
                              '-',
                              style: TextStyle(color: Colors.white, fontSize: isMobile ? 15 : 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Terms checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(255, 122, 79, 223),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey[300], 
                                      fontSize: isMobile ? 13 : 14,
                                    ),
                                    children: const [
                                      TextSpan(text: 'I have read and I agree to '),
                                      TextSpan(
                                        text: 'BOCK De-Fi Loan Service Agreement',
                                        style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'BOCK De-Fi Simple Earn Service Agreement',
                                        style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Start Borrowing button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: !_agreedToTerms ? null : () {
                              // Handle borrow action
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Borrow request submitted'),
                                  backgroundColor: Color.fromARGB(255, 122, 79, 223),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _agreedToTerms 
                                  ? const Color.fromARGB(255, 122, 79, 223) 
                                  : Colors.grey[600],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'Start Borrowing',
                              style: TextStyle(
                                fontSize: isMobile ? 15 : 16,
                                fontWeight: FontWeight.w600,
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
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _collateralController.dispose();
    _borrowController.dispose();
    super.dispose();
  }
}