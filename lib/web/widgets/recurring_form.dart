import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecurringForm extends StatefulWidget {
  @override
  _RecurringFormState createState() => _RecurringFormState();
}

class _RecurringFormState extends State<RecurringForm> {
  String fromCurrency = 'INR';
  String toCurrency = 'USDT';
  String amount = '';
  String frequency = 'Weekly, Tuesday, 21:00 (UTC+5)';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Create Recurring Plan',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Auto-Invest with stablecoin >',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Select Assets Section
          Text(
            'Select Assets',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAssetSelector('INR', AppTheme.warningColor),
              ),
              SizedBox(width: 12),
              Text('To', style: TextStyle(color: AppTheme.textSecondary)),
              SizedBox(width: 12),
              Expanded(
                child: _buildAssetSelector('USDT', AppTheme.successColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // Amount Section
          _buildInputField('Amount', '1,500 - 100,000', 'INR'),
          SizedBox(height: 20),
          
          // Repeat Section  
          _buildDropdownField('Repeat', frequency),
          SizedBox(height: 24),
          
          // Continue Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.warningColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetSelector(String currency, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(currency, style: TextStyle(color: AppTheme.textPrimary)),
          Spacer(),
          Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String placeholder, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  placeholder,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ),
              Text(suffix, style: TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}
