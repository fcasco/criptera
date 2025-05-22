# Criptera Test Suite

This directory contains tests for the Criptera cryptocurrency portfolio app.

## Test Structure

The tests are organized as follows:

- `widget_test.dart`: Basic app initialization tests
- `unit/`: Unit tests for individual components
  - `main_test.dart`: Tests for core app functions
  - `sparkline_test.dart`: Tests for the sparkline chart component
  - `flutter_candlesticks_test.dart`: Tests for the candlestick chart component
  - `market/`: Tests for market-related components
    - `change_bar_test.dart`: Tests for the price change indicator
    - `coin_tabs_test.dart`: Tests for the coin details tabs
    - `coin_exchange_stats_test.dart`: Tests for exchange statistics
  - `portfolio/`: Tests for portfolio-related components
    - `portfolio_tabs_test.dart`: Tests for portfolio management
    - `transaction_sheet_test.dart`: Tests for transaction handling

## Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/unit/main_test.dart
```

## Test Coverage

To generate a coverage report:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Then open `coverage/html/index.html` in a browser to view the coverage report.

## Key Components Tested

1. **Data Processing**
   - Market data filtering and sorting
   - Portfolio value calculations
   - Transaction handling

2. **UI Components**
   - Change indicators
   - Charts (sparkline, candlestick)
   - Transaction forms

3. **Business Logic**
   - Portfolio management
   - Market data analysis
   - Exchange statistics