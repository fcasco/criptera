#!/bin/bash

# Script to remove unnecessary 'new' keywords from Dart files
# This is safe because the 'new' keyword is optional in Dart 2.0+

# Find all Dart files in the lib directory
find lib -name "*.dart" | while read file; do
  echo "Processing $file..."
  
  # Use sed to replace "new " with "" when it's used to create objects
  # This regex matches "new " followed by a word character, preserving the word character
  sed -i 's/new \([A-Za-z0-9_]\)/\1/g' "$file"
done

echo "Completed removing 'new' keywords from Dart files."