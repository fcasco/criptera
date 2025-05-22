import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/market/change_bar.dart';

void main() {
  group('ChangeBar Widget', () {
    testWidgets('renders positive change correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeBar(
              percentChange: 5.25,
              width: 100.0,
            ),
          ),
        ),
      );

      // Verify that the widget displays the correct percentage
      expect(find.text('+5.25%'), findsOneWidget);
      
      // Verify that the color is green for positive change
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ChangeBar),
          matching: find.byType(Container).first,
        ),
      );
      
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.green);
    });

    testWidgets('renders negative change correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeBar(
              percentChange: -3.75,
              width: 100.0,
            ),
          ),
        ),
      );

      // Verify that the widget displays the correct percentage
      expect(find.text('-3.75%'), findsOneWidget);
      
      // Verify that the color is red for negative change
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ChangeBar),
          matching: find.byType(Container).first,
        ),
      );
      
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('renders zero change correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeBar(
              percentChange: 0.0,
              width: 100.0,
            ),
          ),
        ),
      );

      // Verify that the widget displays the correct percentage
      expect(find.text('0.00%'), findsOneWidget);
      
      // Verify that the color is grey for zero change
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ChangeBar),
          matching: find.byType(Container).first,
        ),
      );
      
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.grey);
    });
  });
}