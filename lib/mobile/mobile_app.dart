import 'package:flutter/material.dart';
import 'screens/datbase_service.dart';
import 'screens/mobile_login_screen.dart';
import 'screens/wallet_connect_service.dart';

/// Entry function for mobile app
Future<void> runMobileApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔄 Connecting to Neon database...');
    await DatabaseService.initializeTables();
    debugPrint('✅ Database connected successfully!');
  } catch (e) {
    debugPrint('❌ Database connection failed: $e');
  }

  runApp(const MobileApp());
}

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  late final WalletService _walletService;

  @override
  void initState() {
    super.initState();
    _walletService = WalletService();
    // _walletService.initWeb3Client();
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
      home: MobileLoginScreen(walletService: _walletService),
    );
  }
}
