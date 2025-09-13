import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabs;
  final Function(int) onTap;

  const CustomTabBar({
    Key? key,
    required this.tabController,
    required this.tabs,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTap,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}