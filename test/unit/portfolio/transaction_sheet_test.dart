import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/portfolio/transaction_sheet.dart';

void main() {
  group('TransactionSheet', () {
    testWidgets('renders buy transaction form correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionSheet(
              coin: 'Bitcoin',
              symbol: 'BTC',
              price: 50000.0,
              isPortfolio: false,
            ),
          ),
        ),
      );

      // Verify that the widget displays the correct title
      expect(find.text('Buy Bitcoin'), findsOneWidget);
      
      // Verify that the form fields are present
      expect(find.byType(TextField), findsNWidgets(2)); // Price and quantity fields
      
      // Verify that the buy button is present
      expect(find.text('BUY'), findsOneWidget);
    });

    testWidgets('renders sell transaction form correctly when in portfolio', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionSheet(
              coin: 'Ethereum',
              symbol: 'ETH',
              price: 3000.0,
              isPortfolio: true,
            ),
          ),
        ),
      );

      // Verify that the widget displays the correct title
      expect(find.text('Sell Ethereum'), findsOneWidget);
      
      // Verify that the form fields are present
      expect(find.byType(TextField), findsNWidgets(2)); // Price and quantity fields
      
      // Verify that the sell button is present
      expect(find.text('SELL'), findsOneWidget);
    });

    testWidgets('validates input fields correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionSheet(
              coin: 'Bitcoin',
              symbol: 'BTC',
              price: 50000.0,
              isPortfolio: false,
            ),
          ),
        ),
      );

      // Try to submit with empty fields
      await tester.tap(find.text('BUY'));
      await tester.pump();
      
      // Verify that validation error messages are shown
      expect(find.text('Please enter a valid price'), findsOneWidget);
      expect(find.text('Please enter a valid quantity'), findsOneWidget);
      
      // Fill in the price field with an invalid value
      await tester.enterText(find.byKey(const Key('priceField')), 'abc');
      await tester.pump();
      
      // Try to submit again
      await tester.tap(find.text('BUY'));
      await tester.pump();
      
      // Verify that validation error is still shown
      expect(find.text('Please enter a valid price'), findsOneWidget);
    });
  });
}