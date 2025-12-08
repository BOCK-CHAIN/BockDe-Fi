// main.dart
import 'package:bockchain/mobile/screens/datbase_service.dart';
import 'package:bockchain/mobile/screens/mobile_login_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🔄 Connecting to Neon database...');
    await DatabaseService.initializeTables();
    print('✅ Database connected successfully!');
  } catch (e) {
    print('❌ Database connection failed: $e');
  }
  
  runApp(const MobileApp());
}

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  late WalletService _walletService;

  @override
  void initState() {
    super.initState();
    // Create ONE wallet service instance for the entire app
    _walletService = WalletService();
    //_walletService.initWeb3Client();
  }

  @override
  void dispose() {
    _walletService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BockChain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Pass wallet service through route
      home: MobileLoginScreen(walletService: _walletService),
      // OR if you navigate after login, pass it in the navigator
      onGenerateRoute: (settings) {
        // You can handle routes here and pass wallet service
        return null;
      },
    );
  }
}