import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/market/coin_exchange_stats.dart';

void main() {
  group('CoinExchangeStats', () {
    final Map<String, dynamic> testCoin = {
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'price_usd': 50000.0,
      'percent_change_24h': 2.5,
      'market_cap_usd': 950000000000.0,
      'volume_usd_24h': 25000000000.0,
      'max_supply': 21000000.0,
      'available_supply': 19000000.0,
    };
    
    final List<Map<String, dynamic>> testExchanges = [
      {
        'name': 'Binance',
        'price_usd': 50100.0,
        'volume_usd': 5000000000.0,
      },
      {
        'name': 'Coinbase',
        'price_usd': 49900.0,
        'volume_usd': 3000000000.0,
      },
      {
        'name': 'Kraken',
        'price_usd': 50050.0,
        'volume_usd': 2000000000.0,
      },
    ];
    
    testWidgets('renders coin stats correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinExchangeStats(
              coin: testCoin,
              exchanges: testExchanges,
            ),
          ),
        ),
      );

      // Verify that the coin name and price are displayed
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('\$50,000.00'), findsOneWidget);
      
      // Verify that market stats are displayed
      expect(find.text('Market Cap'), findsOneWidget);
      expect(find.text('\$950,000,000,000.00'), findsOneWidget);
      
      expect(find.text('24h Volume'), findsOneWidget);
      expect(find.text('\$25,000,000,000.00'), findsOneWidget);
      
      // Verify that supply information is displayed
      expect(find.text('Available Supply'), findsOneWidget);
      expect(find.text('19,000,000 BTC'), findsOneWidget);
      
      expect(find.text('Maximum Supply'), findsOneWidget);
      expect(find.text('21,000,000 BTC'), findsOneWidget);
    });
    
    testWidgets('renders exchange list correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinExchangeStats(
              coin: testCoin,
              exchanges: testExchanges,
            ),
          ),
        ),
      );

      // Verify that exchange names are displayed
      expect(find.text('Binance'), findsOneWidget);
      expect(find.text('Coinbase'), findsOneWidget);
      expect(find.text('Kraken'), findsOneWidget);
      
      // Verify that exchange prices are displayed
      expect(find.text('\$50,100.00'), findsOneWidget);
      expect(find.text('\$49,900.00'), findsOneWidget);
      expect(find.text('\$50,050.00'), findsOneWidget);
      
      // Verify that exchange volumes are displayed
      expect(find.text('\$5,000,000,000.00'), findsOneWidget);
      expect(find.text('\$3,000,000,000.00'), findsOneWidget);
      expect(find.text('\$2,000,000,000.00'), findsOneWidget);
    });
    
    test('calculateAveragePrice returns correct average', () {
      // Test the average price calculation
      final double avgPrice = calculateAveragePrice(testExchanges);
      
      // Expected: (50100 + 49900 + 50050) / 3 = 50016.67
      expect(avgPrice, closeTo(50016.67, 0.01));
    });
    
    test('calculateTotalVolume returns correct total', () {
      // Test the total volume calculation
      final double totalVolume = calculateTotalVolume(testExchanges);
      
      // Expected: 5000000000 + 3000000000 + 2000000000 = 10000000000
      expect(totalVolume, 10000000000.0);
    });
  });
}