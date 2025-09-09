import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/sparkline.dart';

void main() {
  group('Sparkline', () {
    test('calculates min and max values correctly', () {
      final List<double> data = [1.0, 5.0, 3.0, 2.0, 4.0];
      final sparkline = Sparkline(
        data: data,
        lineWidth: 2.0,
        lineColor: Colors.blue,
      );
      
      // Access private fields using reflection
      final sparklineState = SparklineState();
      sparklineState.widget = sparkline;
      
      // Call the method that calculates min and max
      sparklineState.updateMinMax();
      
      // Verify min and max values
      expect(sparklineState.min, 1.0);
      expect(sparklineState.max, 5.0);
    });
    
    test('handles empty data gracefully', () {
      final List<double> data = [];
      final sparkline = Sparkline(
        data: data,
        lineWidth: 2.0,
        lineColor: Colors.blue,
      );
      
      // Access private fields using reflection
      final sparklineState = SparklineState();
      sparklineState.widget = sparkline;
      
      // Call the method that calculates min and max
      sparklineState.updateMinMax();
      
      // Verify min and max values default to 0 for empty data
      expect(sparklineState.min, 0.0);
      expect(sparklineState.max, 0.0);
    });
    
    test('handles single value data correctly', () {
      final List<double> data = [3.0];
      final sparkline = Sparkline(
        data: data,
        lineWidth: 2.0,
        lineColor: Colors.blue,
      );
      
      // Access private fields using reflection
      final sparklineState = SparklineState();
      sparklineState.widget = sparkline;
      
      // Call the method that calculates min and max
      sparklineState.updateMinMax();
      
      // Verify min and max values are the same for single value
      expect(sparklineState.min, 3.0);
      expect(sparklineState.max, 3.0);
    });
  });
}