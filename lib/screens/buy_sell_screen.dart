import 'package:flutter/material.dart';
import '../models/crypto_model.dart';
import '../widgets/crypto_list_item.dart';
import '../widgets/buy_sell_form.dart';
import '../theme/app_theme.dart';

class BuySellScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buy USDT with INR',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Supported',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('VISA', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('MC', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hot Cryptos',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                ...hotCryptos.map((crypto) => CryptoListItem(crypto: crypto)).toList(),
              ],
            ),
          ),
          SizedBox(height: 24),
          BuySellForm(),
        ],
      ),
    );
  }
}