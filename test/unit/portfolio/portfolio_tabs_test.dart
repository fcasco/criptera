import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/portfolio/portfolio_tabs.dart';
import 'package:criptera/main.dart';

void main() {
  group('PortfolioTabs', () {
    setUp(() {
      // Initialize test data
      portfolioMap = {
        'BTC': {
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'price_usd': 50000.0,
          'holdings': 1.5,
          'percent_change_24h': 2.5,
        },
        'ETH': {
          'symbol': 'ETH',
          'name': 'Ethereum',
          'price_usd': 3000.0,
          'holdings': 10.0,
          'percent_change_24h': -1.2,
        }
      };
      
      // Update portfolio display
      portfolioDisplay = [];
      portfolioMap.forEach((String symbol, Map<String, dynamic> coin) {
        portfolioDisplay.add(coin);
      });
    });
    
    testWidgets('renders portfolio summary correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortfolioTabs(),
          ),
        ),
      );

      // Verify that the total portfolio value is calculated and displayed correctly
      // Total should be: (1.5 * 50000) + (10 * 3000) = 75000 + 30000 = 105000
      expect(find.textContaining('\$105,000'), findsOneWidget);
      
      // Verify that portfolio items are displayed
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });
    
    test('calculatePortfolioValue returns correct total', () {
      // Test the portfolio calculation function
      final double totalValue = calculatePortfolioValue();
      
      // Expected: (1.5 * 50000) + (10 * 3000) = 75000 + 30000 = 105000
      expect(totalValue, 105000.0);
    });
    
    test('calculatePortfolioValueFromSymbols returns correct value for specific coins', () {
      // Test calculating value for specific symbols
      final double btcValue = calculatePortfolioValueFromSymbols(['BTC']);
      final double ethValue = calculatePortfolioValueFromSymbols(['ETH']);
      
      // Expected: 1.5 * 50000 = 75000 for BTC, 10 * 3000 = 30000 for ETH
      expect(btcValue, 75000.0);
      expect(ethValue, 30000.0);
    });
    
    test('calculatePortfolioChange returns correct 24h change', () {
      // Test the portfolio change calculation
      final double changePercent = calculatePortfolioChange();
      
      // Expected weighted change:
      // (75000 * 2.5% + 30000 * -1.2%) / 105000 = (1875 - 360) / 105000 = 1515 / 105000 = 1.44%
      expect(changePercent, closeTo(1.44, 0.01));
    });
  });
}