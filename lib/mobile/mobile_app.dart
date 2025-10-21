// main.dart
import 'package:bockchain/mobile/screens/datbase_service.dart';
import 'package:bockchain/mobile/screens/mobile_login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database connection and create tables
  try {
    print('🔄 Connecting to Neon database...');
    await DatabaseService.initializeTables();
    print('✅ Database connected successfully!');
  } catch (e) {
    print('❌ Database connection failed: $e');
  }
  
  runApp(const MobileApp());
}

class MobileApp extends StatelessWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BockChain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MobileLoginScreen(),
    );
  }
}