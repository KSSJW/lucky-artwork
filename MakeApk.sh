#!/bin/bash

flutter build apk --release --split-per-abi
mv build/app/outputs/apk/release/app-*.apk .
mv app-arm64-v8a-release.apk LuckyArtwork-android-arm64-v8a.apk
mv app-armeabi-v7a-release.apk LuckyArtwork-android-armeabi-v7a.apk
mv app-x86_64-release.apk LuckyArtwork-android-x86_64.apk