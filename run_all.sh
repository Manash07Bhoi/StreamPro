#!/bin/bash
flutter analyze
flutter test --timeout 60s test/unit/
flutter build apk --release
flutter build ios --release --no-codesign
