#!/bin/bash
echo "🚀 Clean project..."

cd android
./gradlew clean
flutter clean
flutter pub get
