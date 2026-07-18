#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

echo "🧹 [1/6] Cleaning workspace and fetching dependencies..."
flutter clean > /dev/null
flutter pub get > /dev/null

echo "🌐 [2/6] Generating localization files (i18n)..."
flutter gen-l10n

echo "⚙️ [3/6] Running build_runner for code generation..."
dart run build_runner build --delete-conflicting-outputs > /dev/null

echo "🔍 [4/6] Running static code analysis..."
flutter analyze

echo "🧠 [5/6] Running custom_lint (riverpod_lint Riverpod-specific checks)..."
dart run custom_lint

echo "🧪 [6/6] Executing unit and golden tests..."
flutter test

echo "✅ [SUCCESS] Codebase is in perfect shape. Safe to push!"