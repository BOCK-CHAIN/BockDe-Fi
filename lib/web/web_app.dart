import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void runWebApp() {
  runApp(const WebMainApp());
}

class WebMainApp extends StatelessWidget {
  const WebMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binance Trading Platform - Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0B0E11),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}
