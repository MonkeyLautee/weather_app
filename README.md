# weather_app

## Features

- API is https://openweathermap.org
- Show weather of current/selected location
- Caching of weather information for a 20 miles (32168.88 metters) radius, if already fetched. Cache duration is 1 hour and after that refetch again.

## Set up instructions

1. Open this directory in the terminal
2. Launch an Android emulator (usually with a command like this: flutter emulators --launch <my-emulator-name>) or connect an Android phone to the laptop (with "USB debugging" option enabled in "Settings/Developer options").
3. Execute: flutter run

## Build APK

Execute this in Windows terminal in the project root directory:

- flutter build apk
- rem Just to open the directory faster than manually:
- cd build\app\outputs\apk\release
- explorer .

## Image copyright

App icon was generated using Dall-E 3 AI from the official Microsoft Copilot Android app.
Path: assets/logo.png

## Data persistance in the app

This app uses Hive as a local database for data persistance.
https://pub.dev/packages/hive

According to multiple benchmarks, Hive is better than popular options like SharedPreferences or SQLite. Source:
https://github.com/hivedb/hive_benchmark
