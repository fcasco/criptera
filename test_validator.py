#!/usr/bin/env python3
"""
Test Validator for Criptera

This script validates the test files in the Criptera project without running them.
It checks for basic syntax and structure to ensure the tests are well-formed.
"""

import os
import re
import sys
from collections import defaultdict

# Define the test directory
TEST_DIR = os.path.join(os.getcwd(), 'test')

# Define patterns to look for in test files
PATTERNS = {
    'imports': r'import\s+[\'"]package:.*[\'"];',
    'test_group': r'group\([\'"].*[\'"]\s*,',
    'test_function': r'test\([\'"].*[\'"]\s*,',
    'widget_test': r'testWidgets\([\'"].*[\'"]\s*,',
    'expect': r'expect\(',
}

def validate_dart_syntax(file_path):
    """Check if the Dart file has valid syntax."""
    # This is a very basic check - just looking for matching braces, etc.
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Check for balanced braces
    braces = {'(': ')', '{': '}', '[': ']'}
    stack = []
    
    for char in content:
        if char in braces.keys():
            stack.append(char)
        elif char in braces.values():
            if not stack:
                return False, f"Unmatched closing brace: {char}"
            
            last_open = stack.pop()
            if braces[last_open] != char:
                return False, f"Mismatched braces: {last_open} and {char}"
    
    if stack:
        return False, f"Unclosed braces: {', '.join(stack)}"
    
    return True, "Syntax is valid"

def analyze_test_file(file_path):
    """Analyze a test file for patterns and structure."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    results = {}
    for name, pattern in PATTERNS.items():
        results[name] = len(re.findall(pattern, content))
    
    return results

def get_test_coverage():
    """Analyze test coverage across the project."""
    coverage = defaultdict(list)
    
    for root, _, files in os.walk(TEST_DIR):
        for file in files:
            if file.endswith('_test.dart'):
                rel_path = os.path.relpath(os.path.join(root, file), TEST_DIR)
                
                # Determine what component is being tested
                if 'market/' in rel_path:
                    component = 'Market'
                elif 'portfolio/' in rel_path:
                    component = 'Portfolio'
                elif 'flutter_candlesticks' in rel_path:
                    component = 'Charts'
                elif 'sparkline' in rel_path:
                    component = 'Charts'
                elif 'main_test' in rel_path:
                    component = 'Core'
                elif 'widget_test' in rel_path:
                    component = 'App'
                else:
                    component = 'Other'
                
                coverage[component].append(rel_path)
    
    return coverage

def main():
    """Main function to validate tests."""
    print("Criptera Test Validator")
    print("======================\n")
    
    # Check if test directory exists
    if not os.path.isdir(TEST_DIR):
        print(f"Error: Test directory not found at {TEST_DIR}")
        return 1
    
    # Find all test files
    test_files = []
    for root, _, files in os.walk(TEST_DIR):
        for file in files:
            if file.endswith('_test.dart'):
                test_files.append(os.path.join(root, file))
    
    if not test_files:
        print("No test files found!")
        return 1
    
    print(f"Found {len(test_files)} test files.\n")
    
    # Validate syntax
    syntax_errors = []
    for file in test_files:
        valid, message = validate_dart_syntax(file)
        if not valid:
            rel_path = os.path.relpath(file, os.getcwd())
            syntax_errors.append((rel_path, message))
    
    if syntax_errors:
        print("Syntax Errors:")
        for file, error in syntax_errors:
            print(f"  - {file}: {error}")
        print()
    else:
        print("All test files have valid syntax.\n")
    
    # Analyze test structure
    print("Test Structure Analysis:")
    total_tests = 0
    total_widget_tests = 0
    
    for file in test_files:
        rel_path = os.path.relpath(file, os.getcwd())
        analysis = analyze_test_file(file)
        
        test_count = analysis['test_function']
        widget_test_count = analysis['widget_test']
        total_tests += test_count
        total_widget_tests += widget_test_count
        
        print(f"  - {rel_path}:")
        print(f"      Groups: {analysis['test_group']}")
        print(f"      Unit Tests: {test_count}")
        print(f"      Widget Tests: {widget_test_count}")
        print(f"      Assertions: {analysis['expect']}")
        print()
    
    print(f"Total Tests: {total_tests} unit tests, {total_widget_tests} widget tests\n")
    
    # Analyze coverage
    coverage = get_test_coverage()
    
    print("Test Coverage by Component:")
    for component, files in coverage.items():
        print(f"  - {component}: {len(files)} test files")
        for file in files:
            print(f"      - {file}")
        print()
    
    # Summary
    print("Summary:")
    print(f"  - {len(test_files)} test files")
    print(f"  - {total_tests} unit tests")
    print(f"  - {total_widget_tests} widget tests")
    print(f"  - {len(syntax_errors)} syntax errors")
    print(f"  - {len(coverage)} components covered")
    
    return 0 if not syntax_errors else 1

if __name__ == "__main__":
    sys.exit(main())