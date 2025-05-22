import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/market/coin_tabs.dart';
import 'package:criptera/main.dart';

void main() {
  group('CoinTabs', () {
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
    
    setUp(() {
      // Initialize test data
      historyMap = {
        'BTC': {
          'Data': [
            {
              'time': 1620000000,
              'open': 48000.0,
              'high': 51000.0,
              'low': 47500.0,
              'close': 50000.0,
              'volumefrom': 10000.0,
              'volumeto': 500000000.0,
            },
            {
              'time': 1620086400,
              'open': 50000.0,
              'high': 52000.0,
              'low': 49000.0,
              'close': 51000.0,
              'volumefrom': 12000.0,
              'volumeto': 600000000.0,
            },
          ],
        },
      };
      
      exchangeMap = {
        'BTC': [
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
        ],
      };
    });
    
    testWidgets('renders coin details correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinDetails(
              coin: testCoin,
            ),
          ),
        ),
      );

      // Verify that the coin name and price are displayed
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('\$50,000.00'), findsOneWidget);
      
      // Verify that the percent change is displayed
      expect(find.text('+2.50%'), findsOneWidget);
    });
    
    testWidgets('renders tab bar with correct tabs', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinDetails(
              coin: testCoin,
            ),
          ),
        ),
      );

      // Verify that the tab bar is displayed with the correct tabs
      expect(find.text('CHART'), findsOneWidget);
      expect(find.text('BOOK'), findsOneWidget);
      expect(find.text('MARKETS'), findsOneWidget);
    });
    
    testWidgets('switches between tabs correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoinDetails(
              coin: testCoin,
            ),
          ),
        ),
      );

      // Initially, the chart tab should be selected
      expect(find.byType(OHLCVGraph), findsOneWidget);
      
      // Tap on the MARKETS tab
      await tester.tap(find.text('MARKETS'));
      await tester.pumpAndSettle();
      
      // Verify that the markets view is displayed
      expect(find.byType(CoinExchangeStats), findsOneWidget);
      
      // Tap on the BOOK tab
      await tester.tap(find.text('BOOK'));
      await tester.pumpAndSettle();
      
      // Verify that the order book view is displayed
      expect(find.byType(OrderBook), findsOneWidget);
    });
    
    test('formatChartData converts history data correctly', () {
      // Test the chart data formatting function
      final List<Map<String, dynamic>> formattedData = formatChartData(historyMap['BTC']['Data']);
      
      // Verify that the data is formatted correctly
      expect(formattedData.length, 2);
      expect(formattedData[0]['open'], 48000.0);
      expect(formattedData[0]['high'], 51000.0);
      expect(formattedData[0]['low'], 47500.0);
      expect(formattedData[0]['close'], 50000.0);
      expect(formattedData[0]['volumeto'], 500000000.0);
      
      expect(formattedData[1]['open'], 50000.0);
      expect(formattedData[1]['high'], 52000.0);
      expect(formattedData[1]['low'], 49000.0);
      expect(formattedData[1]['close'], 51000.0);
      expect(formattedData[1]['volumeto'], 600000000.0);
    });
  });
}