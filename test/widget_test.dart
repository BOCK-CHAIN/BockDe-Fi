import 'package:flutter_test/flutter_test.dart';

import 'package:bock/main.dart';

void main() {
  testWidgets('App loads and displays Binance title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BinanceApp());

    // Verify that the app loads and shows the Binance title
    expect(find.text('Binance'), findsOneWidget);
    
    // Verify that key elements are present
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Top Cryptocurrencies'), findsOneWidget);
  });

  testWidgets('Bottom navigation works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BinanceApp());

    // Test navigation (this assumes your bottom nav has specific icons/text)
    // You'll need to adjust based on your actual bottom navigation implementation
    
    // Find and tap on different navigation items
    // Example: await tester.tap(find.byIcon(Icons.wallet));
    // await tester.pump();
    
    // Verify navigation worked
    // expect(find.text('Spot Wallet'), findsOneWidget);
  });
}