import 'package:flutter/material.dart';
import 'top_navigation_bar.dart'; // Your existing file
import 'app_footer.dart'; // Your existing file

class MainLayout extends StatefulWidget {
  final Widget child;
  final bool isDarkMode;
  final Function(bool) onThemeToggle;
  final String selectedLanguage;
  final Function(String) onLanguageChange;

  const MainLayout({
    super.key,
    required this.child,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        isDarkMode: widget.isDarkMode,
        onThemeToggle: widget.onThemeToggle,
        selectedLanguage: widget.selectedLanguage,
        onLanguageChange: widget.onLanguageChange,
      ),
      backgroundColor: const Color(0xFF0F0F1E), // Match your theme
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: widget.child,
            ),
          ),
          // Footer at the bottom
          const AppFooter(),
        ],
      ),
    );
  }
}