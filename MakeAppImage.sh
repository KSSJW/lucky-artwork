#!/bin/bash

flutter build linux --release --target-platform=linux-x64
rm build/linux/x64/release/bundle/data/flutter_assets/kernel_blob.bin
mv build/linux/x64/release/bundle/ LuckyArtwork.AppDir/
chmod +x LuckyArtwork.AppDir/bundle/lucky_artwork
chmod +x LuckyArtwork.AppDir/AppRun
appimagetool LuckyArtwork.AppDir LuckyArtwork-linux-x86_64.AppImage
rm -rf LuckyArtwork.AppDir/bundle/