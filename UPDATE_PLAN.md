# Criptera Update Plan

This document outlines the comprehensive plan to update the Criptera cryptocurrency portfolio and market explorer app to modern Flutter standards and ensure compatibility with the latest Flutter SDK.

## Current State Analysis

Criptera is a Flutter application forked from [trace](https://github.com/trentpiercy/trace) that provides cryptocurrency portfolio tracking and market exploration features. The app allows users to:

- Track their cryptocurrency portfolio
- Explore market data
- View detailed coin statistics
- Analyze portfolio performance over time
- Customize the app with different themes

### Technical Assessment

1. **Flutter SDK Version**: 
   - Current: SDK '>=2.19.2 <3.0.0'
   - Latest: Flutter 3.32.0 with Dart 3.8.0

2. **Dependencies**:
   - shared_preferences: ^2.0.18 → 2.5.3
   - path_provider: ^2.0.13 → 2.1.5
   - url_launcher: ^6.1.10 → 6.3.1
   - http: ^0.13.5 → 1.4.0
   - package_info: ^2.0.2 → 2.0.2 (deprecated, should be replaced with package_info_plus)
   - awesome_circular_chart: ^1.0.0 → 1.1.0
   - flutter_launcher_icons: ^0.12.0 → 0.14.3
   - Missing flutter_lints: 5.0.0

3. **Deprecated APIs**:
   - Several deprecated APIs are still in use:
     - accentColor (should be colorScheme.secondary)
     - textTheme.caption (should be textTheme.bodySmall)
     - textSelectionHandleColor (marked with FIXME comments)

4. **Null Safety**:
   - The project has partial null safety implementation but needs a complete review

5. **API Endpoints**:
   - The app uses CryptoCompare API which is still functional

## Update Plan

### 1. Flutter SDK and Dart Update

**Priority: High**

- Update Flutter SDK constraints to support Dart 3
- Migrate to Flutter 3.32.0 and Dart 3.8.0
- Update the environment section in pubspec.yaml

### 2. Dependency Updates

**Priority: High**

- Update all dependencies to their latest versions
- Replace deprecated package_info with package_info_plus
- Add flutter_lints for better code quality
- Update pubspec.yaml with the new dependency versions

### 3. API Modernization

**Priority: Medium**

- Replace deprecated Flutter APIs:
  - Replace accentColor with colorScheme.secondary
  - Replace textTheme.caption with textTheme.bodySmall
  - Fix textSelectionHandleColor issues
  - Update any other deprecated APIs found during testing

### 4. Complete Null Safety Migration

**Priority: High**

- Review and update all code to ensure proper null safety
- Add required null safety operators (?, !, late) where needed
- Update method signatures to reflect null safety
- Fix any runtime null safety issues

### 5. Code Refactoring

**Priority: Medium**

- Refactor code to follow modern Flutter patterns
- Implement proper state management (consider Provider or Riverpod)
- Separate business logic from UI components
- Improve error handling and loading states

### 6. UI/UX Improvements

**Priority: Low**

- Update UI to follow Material Design 3 guidelines
- Implement adaptive layouts for different screen sizes
- Add dark mode improvements
- Enhance accessibility features

### 7. Testing and Quality Assurance

**Priority: Medium**

- Add unit tests for core functionality
- Implement widget tests for UI components
- Set up integration tests for critical user flows
- Ensure the app works on the latest iOS and Android versions

### 8. Documentation

**Priority: Low**

- Update README.md with current information
- Add code documentation
- Create developer guidelines for future contributions

## Implementation Timeline

1. **Phase 1: Foundation Updates** (1-2 weeks)
   - Update Flutter SDK and dependencies
   - Fix critical deprecated APIs
   - Complete null safety migration

2. **Phase 2: Modernization** (2-3 weeks)
   - Refactor code architecture
   - Implement proper state management
   - Update UI to Material Design 3

3. **Phase 3: Enhancement and Testing** (1-2 weeks)
   - Add tests
   - Improve error handling
   - Update documentation

## Conclusion

This update plan provides a structured approach to modernize the Criptera app and ensure its compatibility with the latest Flutter SDK. By following this plan, the app will not only work with current Flutter versions but also adopt modern development practices that will make future maintenance easier.