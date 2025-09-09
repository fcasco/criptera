import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/flutter_candlesticks.dart';

void main() {
  group('OHLCVGraph', () {
    final List<Map<String, dynamic>> testData = [
      {
        'open': 100.0,
        'high': 110.0,
        'low': 95.0,
        'close': 105.0,
        'volumeto': 1000.0,
      },
      {
        'open': 105.0,
        'high': 115.0,
        'low': 100.0,
        'close': 95.0,
        'volumeto': 1500.0,
      },
      {
        'open': 95.0,
        'high': 105.0,
        'low': 90.0,
        'close': 100.0,
        'volumeto': 1200.0,
      },
    ];
    
    testWidgets('renders candlestick chart correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OHLCVGraph(
              data: testData,
              enableGridLines: true,
              volumeProp: 0.2,
            ),
          ),
        ),
      );

      // Verify that the candlestick chart is rendered
      expect(find.byType(OHLCVGraph), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });
    
    test('findMinMax calculates correct min and max values', () {
      // Test the min/max calculation function
      final Map<String, double> minMax = findMinMax(testData);
      
      // Expected min: 90.0 (lowest 'low' value)
      // Expected max: 115.0 (highest 'high' value)
      expect(minMax['min'], 90.0);
      expect(minMax['max'], 115.0);
    });
    
    test('findMinMaxVolume calculates correct min and max volume', () {
      // Test the min/max volume calculation function
      final Map<String, double> minMaxVolume = findMinMaxVolume(testData);
      
      // Expected min: 1000.0 (lowest 'volumeto' value)
      // Expected max: 1500.0 (highest 'volumeto' value)
      expect(minMaxVolume['min'], 1000.0);
      expect(minMaxVolume['max'], 1500.0);
    });
    
    test('handles empty data gracefully', () {
      // Test with empty data
      final List<Map<String, dynamic>> emptyData = [];
      
      final Map<String, double> minMax = findMinMax(emptyData);
      final Map<String, double> minMaxVolume = findMinMaxVolume(emptyData);
      
      // Expected default values for empty data
      expect(minMax['min'], 0.0);
      expect(minMax['max'], 0.0);
      expect(minMaxVolume['min'], 0.0);
      expect(minMaxVolume['max'], 0.0);
    });
  });
}