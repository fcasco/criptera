import 'package:flutter_test/flutter_test.dart';
import 'package:criptera/main.dart';

void main() {
  group('Main App Functions', () {
    test('loadPortfolio initializes portfolio data correctly', () {
      // Test the portfolio loading function
      loadPortfolio();
      
      // Verify that the portfolio data structures are initialized
      expect(portfolioMap, isA<Map<String, Map<String, dynamic>>>());
      expect(portfolioDisplay, isA<List<Map<String, dynamic>>>());
    });
    
    test('loadMarketData initializes market data correctly', () {
      // Test the market data loading function
      loadMarketData();
      
      // Verify that the market data structures are initialized
      expect(marketListData, isA<List<Map<String, dynamic>>>());
      expect(filteredMarketListData, isA<List<Map<String, dynamic>>>());
    });
    
    test('filterMarketData filters data correctly', () {
      // Initialize test data
      marketListData = [
        {
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'price_usd': 50000.0,
        },
        {
          'symbol': 'ETH',
          'name': 'Ethereum',
          'price_usd': 3000.0,
        },
        {
          'symbol': 'XRP',
          'name': 'Ripple',
          'price_usd': 1.0,
        },
      ];
      
      // Test filtering by name
      filterMarketData('bit');
      expect(filteredMarketListData.length, 1);
      expect(filteredMarketListData[0]['symbol'], 'BTC');
      
      // Test filtering by symbol
      filterMarketData('eth');
      expect(filteredMarketListData.length, 1);
      expect(filteredMarketListData[0]['symbol'], 'ETH');
      
      // Test filtering with no matches
      filterMarketData('xyz');
      expect(filteredMarketListData.length, 0);
      
      // Test filtering with empty string (should return all)
      filterMarketData('');
      expect(filteredMarketListData.length, 3);
    });
    
    test('sortMarketData sorts data correctly', () {
      // Initialize test data
      marketListData = [
        {
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'price_usd': 50000.0,
          'market_cap_usd': 950000000000.0,
          'percent_change_24h': 2.5,
        },
        {
          'symbol': 'ETH',
          'name': 'Ethereum',
          'price_usd': 3000.0,
          'market_cap_usd': 350000000000.0,
          'percent_change_24h': 5.0,
        },
        {
          'symbol': 'XRP',
          'name': 'Ripple',
          'price_usd': 1.0,
          'market_cap_usd': 50000000000.0,
          'percent_change_24h': -2.0,
        },
      ];
      
      // Test sorting by market cap (default)
      sortMarketData(0);
      expect(marketListData[0]['symbol'], 'BTC');
      expect(marketListData[1]['symbol'], 'ETH');
      expect(marketListData[2]['symbol'], 'XRP');
      
      // Test sorting by price
      sortMarketData(1);
      expect(marketListData[0]['symbol'], 'BTC');
      expect(marketListData[1]['symbol'], 'ETH');
      expect(marketListData[2]['symbol'], 'XRP');
      
      // Test sorting by 24h change
      sortMarketData(2);
      expect(marketListData[0]['symbol'], 'ETH');
      expect(marketListData[1]['symbol'], 'BTC');
      expect(marketListData[2]['symbol'], 'XRP');
    });
  });
}