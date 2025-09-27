import 'package:bockchain/web/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
//import 'package:bockchain/widgets/top_navigation.dart';
import 'package:bockchain/web/widgets/app_footer.dart';

class BaseLayout extends StatelessWidget {
  final Widget child; // Screen content
  final bool isDarkMode;
  final String selectedLanguage;
  final Function(bool) onThemeToggle;
  final Function(String) onLanguageChange;

  const BaseLayout({
    super.key,
    required this.child,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ Top Navigation
          TopNavigationBar(
            isDarkMode: isDarkMode,
            onThemeToggle: onThemeToggle,
            selectedLanguage: selectedLanguage,
            onLanguageChange: onLanguageChange,
          ),

          // ✅ Scrollable Content + Footer
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child,          // your page content
                  const AppFooter(), // footer always at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
