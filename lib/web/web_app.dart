import 'package:flutter/material.dart';
import 'package:bockchain/web/screens/home_screen.dart'; // Your existing HomeScreen

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Directly return your existing HomeScreen for web
    return const HomeScreen();
  }
}
